
#import "Scanner.h"
#import "GCDAsyncUdpSocket.h"
#import <arpa/inet.h>
#import <ifaddrs.h>
@interface Scanner ()
@property (nonatomic,retain) GCDAsyncUdpSocket* scanSocket;
@property (nonatomic,copy) NSString* routerIP;
@property (nonatomic,retain) NSData *scanSendData;
@property (nonatomic,retain) NSMutableArray* m_deviceIP;
@property (nonatomic,retain) NSMutableArray* m_deviceID;
@end
@implementation Scanner

static bool isRecving = NO;


- (NSString *) routerIp {
    NSString *address = @"error";
    NSString *broadcast_addr = @"error";
    NSString *netmask = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String //ifa_addr
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    broadcast_addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return broadcast_addr;
}

typedef enum {
    ScanStoped,
    ScanStop,
    ScanStart
}ScanDeviceStatus;
static ScanDeviceStatus scanStatus = ScanStoped;

-(Scanner*)ScanDeviceWithTime:(NSTimeInterval)time{
    if (scanStatus != ScanStoped) {
        return nil;
    }
    if (time < 1) {
        return nil;
    }
    scanStatus = ScanStart;
    
    self.m_deviceID = [[NSMutableArray alloc]init];
    self.m_deviceIP = [[NSMutableArray alloc]init];
    
    [self.m_deviceID removeAllObjects];
    [self.m_deviceIP removeAllObjects];
    Byte _ScanSendByte[14]={00,00,00,01,00,00,00,00,00,00,00,00,0x2a,00};
    self.scanSendData = [[NSData alloc] initWithBytes:_ScanSendByte length:14];
    //NSLog(@"_ScanSendData:%@",_ScanSendData);
    self.routerIP = [self routerIp];
    NSLog(@"start scan ip=%@",self.routerIP);
    self.scanSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)];
    NSError *error = nil;
    [self.scanSocket bindToPort:12345 error: &error];
    [self.scanSocket beginReceiving:&error];
    [self.scanSocket enableBroadcast:YES error:&error];
    
    Scanner* _Device_Info = [[Scanner alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^ {
        [self SendScanData];
    });
    [NSThread sleepForTimeInterval:time];
    scanStatus = ScanStoped;
    while (isRecving == YES){
        [NSThread sleepForTimeInterval:0.1];
    }
    if (self.m_deviceIP.count < 1) {
        return nil;
    }
    _Device_Info.Device_ID_Arr = [[NSArray alloc]initWithArray:self.m_deviceID];
    _Device_Info.Device_IP_Arr = [[NSArray alloc]initWithArray:self.m_deviceIP];
    
    [self.scanSocket close];
    self.scanSocket = nil;
    self.routerIP = nil;
    self.scanSendData = nil;
    self.m_deviceID = nil;
    self.m_deviceIP = nil;
    
    scanStatus = ScanStoped;
    return _Device_Info;
}
- (void) SendScanData
{
    [self.scanSocket sendData:self.scanSendData toHost:self.routerIP port:5570 withTimeout:-1 tag:1];
    if (scanStatus == ScanStart){
        const dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void){
            [self SendScanData];
            [self.scanSocket beginReceiving:nil];
        });
    }
}
typedef struct
{
    uint8_t hdr[4];
    uint8_t seq[4];
    uint8_t nabto[4];
    uint8_t localip[4];
    uint8_t localport[2];
    uint8_t dataload[100];
} NabtoScanRecv;

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    //NSLog(@"send scan success tag : %d",(int)tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    //NSLog(@"scan data:%@",data);
    if (data==nil) {
        return;
    }
    Byte *dip = (Byte *)[address bytes];
    NSString* _ip = [[NSString alloc] initWithFormat:@"%d.%d.%d.%d",dip[4],dip[5],dip[6],dip[7]];
    if ([_ip isEqualToString:@"0.0.0.0"]) {
        return;
    }
    if([sock isEqual:self.scanSocket])
    {
        if (data.length < 29)
        {
            return;
        }
        int flg = (int)[self.m_deviceIP indexOfObject:_ip];
        int count = (int)[self.m_deviceIP count];
        if ((flg>=0)&&(flg<count)) {
            return;
        }
        
        Byte *udpdataByte = (Byte *)[data bytes];
        NabtoScanRecv* _RecvInfo = (NabtoScanRecv*)&udpdataByte[0];
        
        if (_RecvInfo->hdr[1] != 0x80) {
            return;
        }
        if (_RecvInfo->dataload[0] != 0x01) {
            return;
        }
        isRecving = YES;
        
        uint16_t port = ((_RecvInfo->localport[0] & 0x00ff) << 8) | _RecvInfo->localport[1];
        NSString *localport = [[NSString alloc] initWithFormat:@"%d",port];
        if(localport == NULL)
        {
            isRecving = NO;
            return;
        }
        int dataload_len = (int)data.length - 27;
        uint8_t *start = _RecvInfo->dataload;
        uint8_t *endpoint=memchr(_RecvInfo->dataload, 0x00, dataload_len);
        if(endpoint == NULL)
        {
            isRecving = NO;
            return;
        }
        int id_len = (int)endpoint- (int)start-1;
        NSString *nabtoid = [[NSString alloc]initWithData:[NSData dataWithBytes:&_RecvInfo->dataload[1] length:id_len] encoding:NSUTF8StringEncoding];
        //NSLog(@"nabtoid:%d %@",nabtoid.length,nabtoid);
        if (nabtoid == NULL) {
            isRecving = NO;
            return;
        }
        NSLog(@"LX520log-> ip: %@ id: %@",_ip,nabtoid);
        if (_ip != NULL) {
            [self.m_deviceIP addObject: _ip];
            [self.m_deviceID addObject: nabtoid];
        }
        
        _ip = nil;
        nabtoid = nil;
        _RecvInfo = nil;
    }
    isRecving = NO;
}


@end
