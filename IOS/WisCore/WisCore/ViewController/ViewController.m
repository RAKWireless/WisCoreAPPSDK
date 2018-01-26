//
//  ViewController.m
//  WisCore
//
//  Created by rakwireless on 2017/4/19.
//  Copyright © 2017年 rak. All rights reserved.
//

#import "ViewController.h"
#import "CommanParameters.h"
#import "ApAddStep1ViewController.h"
#import "SWRevealViewController.h"
#import "DeviceViewController.h"
#import "DeviceData.h"
#import "DeviceInfo.h"
#import "Scanner.h"
#import "LoadingView.h"

@interface ViewController ()
{
    LoadingView *_loadingView;
    bool _isExit;
    Scanner *_deviceScan;
    DeviceData *_deviceData;
    NSMutableArray *_collection_Items;
    NSMutableArray *_local_Items;
    int _deleteRow;
    int _editRow;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:MAIN_BG_COLOR];
    
    // 标题栏
    _topBg=[[UIView alloc]init];
    _topBg.frame = CGRectMake(0, diff_top, viewW, viewH*44/view_fix_height);
    _topBg.userInteractionEnabled=YES;
    [_topBg setBackgroundColor:MAIN_TITLE_BG_COLOR];
    [self.view addSubview:_topBg];
    
    _menuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _menuBtn.frame = CGRectMake(0, 0, viewH*44/view_fix_height, viewH*44/view_fix_height);
    [_menuBtn setImage:[UIImage imageNamed:@"menu_nor@3x.png"] forState:UIControlStateNormal];
    [_menuBtn setImage:[UIImage imageNamed:@"menu_sel@3x.png"] forState:UIControlStateHighlighted];
    [_menuBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    [_menuBtn setTitleColor:[UIColor grayColor]forState:UIControlStateHighlighted];
    _menuBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_menuBtn addTarget:nil action:@selector(_menuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //[_topBg  addSubview:_menuBtn];
    
    _refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn.frame = CGRectMake(viewW-viewH*44/view_fix_height, 0, viewH*44/view_fix_height, viewH*44/view_fix_height);
    [_refreshBtn setImage:[UIImage imageNamed:@"refresh_nor@3x.png"] forState:UIControlStateNormal];
    [_refreshBtn setImage:[UIImage imageNamed:@"refresh_pre@3x.png"] forState:UIControlStateHighlighted];
    [_refreshBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    [_refreshBtn setTitleColor:[UIColor grayColor]forState:UIControlStateHighlighted];
    _refreshBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [_refreshBtn addTarget:nil action:@selector(_refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_topBg  addSubview:_refreshBtn];
    
    _topTitle= [[UILabel alloc] initWithFrame:CGRectMake(0, 0,viewW-viewH*44*2/view_fix_height, viewH*44/view_fix_height)];
    _topTitle.text = NSLocalizedString(@"main_title", nil);
    _topTitle.center=CGPointMake(_topBg.center.x, _topTitle.center.y);
    _topTitle.font = [UIFont boldSystemFontOfSize: main_title_size];
    _topTitle.backgroundColor = [UIColor clearColor];
    _topTitle.textColor = [UIColor blackColor];
    _topTitle.numberOfLines = 0;
    _topTitle.textAlignment=NSTextAlignmentCenter;
    [_topBg addSubview:_topTitle];
    
    _deviceListTableview= [[UITableView alloc] initWithFrame:CGRectMake(0, viewH*65/view_fix_height, viewW, viewH*438/view_fix_height) style:UITableViewStylePlain];
    _deviceListTableview.dataSource = self;
    _deviceListTableview.delegate = self;
    _deviceListTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _deviceListTableview.backgroundColor=[UIColor whiteColor];
    _deviceListTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view  addSubview:_deviceListTableview];
    
    _noDeviceLabel=[[UILabel alloc]initWithFrame:CGRectMake(viewW*20/view_fix_width, viewH*65/view_fix_height, viewW-viewW*40/view_fix_width, viewH*438/view_fix_height)];
    _noDeviceLabel.text= NSLocalizedString(@"main_scan_no_device", nil);
    _noDeviceLabel.font = [UIFont systemFontOfSize: main_title_size];
    _noDeviceLabel.backgroundColor = [UIColor clearColor];
    _noDeviceLabel.textColor = [UIColor blackColor];
    _noDeviceLabel.numberOfLines = 0;
    _noDeviceLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_noDeviceLabel];
    _noDeviceLabel.hidden=YES;

    
    _bottomBg=[[UIView alloc]init];
    _bottomBg.frame = CGRectMake(0, viewH*503/view_fix_height, viewW, viewH*164/view_fix_height);
    _bottomBg.userInteractionEnabled=YES;
    [_bottomBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottomBg];
    
    _addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(0, viewH*38/view_fix_height, viewH*100/view_fix_height, viewH*100/view_fix_height);
    _addBtn.center=CGPointMake(_bottomBg.center.x, _addBtn.center.y);
    [_addBtn setImage:[UIImage imageNamed:@"add device_nor@3x.png"] forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"add device_pre@3x.png"] forState:UIControlStateHighlighted];
    [_addBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor grayColor]forState:UIControlStateHighlighted];
    _addBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_addBtn addTarget:nil action:@selector(_addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBg  addSubview:_addBtn];
    
    _versonLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, _addBtn.frame.origin.y+_addBtn.frame.size.height,viewW, viewH*20/view_fix_height)];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    version=[NSString stringWithFormat:@"V%@",version];
    _versonLabel.text = version;
    _versonLabel.font = [UIFont systemFontOfSize: contact_text_size];
    _versonLabel.backgroundColor = [UIColor clearColor];
    _versonLabel.textColor = LOGIN_LINE_COLOR;
    _versonLabel.numberOfLines = 0;
    _versonLabel.textAlignment=NSTextAlignmentCenter;
    [_bottomBg addSubview:_versonLabel];
    
    _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [_loadingView setLoadingShow:NO :@""];
    [self.view addSubview:_loadingView];
    
    //注册该页面可以执行滑动切换
//    SWRevealViewController *revealController = self.revealViewController;
//    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    _isExit=NO;
    _deviceScan = [[Scanner alloc] init];
    [self scanDevice];
    
    _collection_Items=[[NSMutableArray alloc]init];
    _local_Items=[[NSMutableArray alloc]init];
    _deviceData=[[DeviceData alloc]init];
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
    _isExit=YES;
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)_menuBtnClick{
    NSLog(@"_menuBtnClick");
//    if(self.revealViewController.frontViewPosition==FrontViewPositionLeft){
//        [self.revealViewController setFrontViewPosition:FrontViewPositionRight animated:YES];
//    }
//    else
//        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];

}

-(void)_refreshBtnClick{
    NSLog(@"_refreshBtnClick");
    [self scanDevice];
}


-(void)_addBtnClick{
    NSLog(@"_addBtnClick");
    ApAddStep1ViewController *v = [[ApAddStep1ViewController alloc] init];
    [self.navigationController pushViewController: v animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return device_list_row_height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([_collection_Items count]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame=CGRectMake(10, 0, viewW, device_list_row_height);
    DeviceInfo *_device=_collection_Items[indexPath.row];
    if ([_device.deviceStatus compare:_deviceOnline]==NSOrderedSame) {
        cell.imageView.image=[UIImage imageNamed:@"teal@3x.png"];
    }
    else{
        cell.imageView.image=[UIImage imageNamed:@"red@3x.png"];
    }
    cell.textLabel.text =[_deviceData getDeviceNameById: _device.deviceID];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, device_list_row_height-1, viewW, 1)];
    line.backgroundColor=MAIN_TEXT_BG_COLOR;
    [cell addSubview:line];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceInfo *_device= _collection_Items[indexPath.row];
    if ([_device.deviceStatus isEqualToString:_deviceOnline])
    {
        NSString *deviceName=[_deviceData getDeviceNameById:_device.deviceID];
        DeviceViewController *v = [[DeviceViewController alloc] init];
        v.deviceName=deviceName;
        v.deviceIp=_device.deviceIp;
        NSLog(@"v.deviceIp=%@",v.deviceIp);
        [self.navigationController pushViewController: v animated:true];
    }
    else{
        [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"main_device_offline", nil)];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//设置可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        _deleteRow=(int)indexPath.row;
        [self deleteViewInit];
        [_deviceListTableview reloadData];
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@" Edit " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了编辑");
        _editRow=(int)indexPath.row;
        [self editViewInit];
        [_deviceListTableview reloadData];
    }];
    editAction.backgroundColor = [UIColor grayColor];
    return @[deleteAction, editAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

//修改Delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"main_list_delete", nil);
}

/**
 * 删除弹窗
 */
-(void)deleteViewInit{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"delete_device_dialog_text", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"delete_device_dialog_text", nil)];
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:main_text_size] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[hogan string] length])];
    [alertController setValue:hogan forKey:@"attributedTitle"];
    //Yes
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete_device_dialog_ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Yes");
        DeviceData *_device=[[DeviceData alloc]init];
        DeviceInfo *_deviceInfo=_collection_Items[_deleteRow];
        [_device deleteDeviceId:_deviceInfo.deviceID];
        [_collection_Items removeObjectAtIndex:_deleteRow];
        if ([_collection_Items count]==0) {
            _noDeviceLabel.hidden=NO;
        }
        else{
            _noDeviceLabel.hidden=YES;
        }
        [_deviceListTableview reloadData];
    }];
    [defaultAction setValue:INFO_TEXT_COLOR forKey:@"_titleTextColor"];
    //Cancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete_device_dialog_cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Cancel");
    }];
    [cancelAction setValue:INFO_TEXT_COLOR forKey:@"_titleTextColor"];
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


/**
 * 编辑弹窗
 */
-(void)editViewInit{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    //修改标题的内容，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@""];
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:main_text_size] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[hogan string] length])];
    [alertController setValue:hogan forKey:@"attributedTitle"];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"edit_device_dialog_hint", nil);
    }];
    
    //Yes
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete_device_dialog_ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Yes");
        UITextField *name = alertController.textFields.firstObject;
        if ([name.text isEqualToString:@""]) {
            [CommanParameters showAllTextDialog:self.view :NSLocalizedString(@"edit_device_dialog_error", nil)];
        }
        else{
            DeviceData *_device=[[DeviceData alloc]init];
            DeviceInfo *_deviceInfo=_collection_Items[_editRow];
            [_device updateDeviceNameById:_deviceInfo.deviceID :name.text];
            [self scanDevice];
        }
    }];
    [defaultAction setValue:INFO_TEXT_COLOR forKey:@"_titleTextColor"];
    //Cancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete_device_dialog_cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Cancel");
    }];
    [cancelAction setValue:INFO_TEXT_COLOR forKey:@"_titleTextColor"];
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- scanDevice
- (void)scanDevice
{
    if (_isExit) {
        return;
    }
    
    [_loadingView setLoadingShow:YES :NSLocalizedString(@"main_scan_indicator", nil)];
    [_local_Items removeAllObjects];
    [_collection_Items removeAllObjects];
    [_deviceListTableview reloadData];
    [NSThread detachNewThreadSelector:@selector(scanDeviceTask) toTarget:self withObject:nil];
}

- (void)scanDeviceTask
{
    Scanner *result = [_deviceScan ScanDeviceWithTime:1.5f];
    [self performSelectorOnMainThread:@selector(scanDeviceOver:) withObject:result waitUntilDone:NO];
}

- (void)scanDeviceOver:(Scanner *)result;
{
    NSMutableArray *_deviceInfos=[_deviceData getDeviceIds];
    if (result.Device_ID_Arr.count > 0) {
        NSLog(@"Scan Over...");
        [result.Device_ID_Arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *deviceIp = [result.Device_IP_Arr objectAtIndex:idx];
            NSString *deviceId = [result.Device_ID_Arr objectAtIndex:idx];
            if ([deviceIp isEqualToString:@"192.168.230.1"]) {
                
            }
            else
            {
                
                bool tempsame=NO;
                for (int i=0;i<[_local_Items count]; i++) {
                    DeviceInfo *temp=_local_Items[i];
                    if ([deviceId compare:temp.deviceID]==NSOrderedSame){
                        tempsame=YES;
                        break;
                    }
                }
                if (!tempsame) {
                    DeviceInfo *localDevice=[[DeviceInfo alloc]init];
                    localDevice.deviceID=deviceId;
                    localDevice.deviceName=[_deviceData getDeviceNameById:deviceId];
                    localDevice.deviceIp=deviceIp;
                    localDevice.deviceStatus=_deviceOnline;
                    NSLog(@"Scan nothing1...");
                    [_local_Items addObject:localDevice];//本地设备
                    [_collection_Items addObject:localDevice];//添加已经扫描到的本地设备
                    NSLog(@"Scan nothing2...");
                }
            }
        }];
    }
    else
    {
        NSLog(@"Scan nothing...");
    }
    [_deviceInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //保存的所有设备都为offline
        DeviceInfo *_saveInfo=_deviceInfos[idx];
        NSString *_saveId=_saveInfo.deviceID;
        
        DeviceInfo *_localInfo;
        int index=0;
        bool same=NO;
        for(int i=0;i<[_local_Items count];i++)
        {
            _localInfo=_local_Items[i];
            NSString *_localId=_localInfo.deviceID;
            //相同，表示已经保存过，则更新设备名称和设备状态为online
            NSLog(@"%@",_saveId);
            NSLog(@"%@",_localId);
            if([_saveId compare:_localId]==NSOrderedSame ){
                index=i;
                NSLog(@"%d",i);
                same=YES;
                break;
            }
        }
        //不相同则直接添加
        if (!same) {
            NSLog(@"Scan nothing3...");
            [_collection_Items addObject:_saveInfo];
            NSLog(@"Scan nothing4...");
        }
        else{
            NSLog(@"Scan nothing5...");
            //_collection_Items和_local_Items是相同的
            DeviceInfo *newInfo=_localInfo;//ip id为扫描到的值
            newInfo.deviceName=_saveInfo.deviceName;//name 为保存值
            newInfo.deviceStatus=_deviceOnline;//status 为在线
            [_collection_Items replaceObjectAtIndex:index withObject:newInfo];//更新这个设备信息
            same=YES;
        }
    }];
    if ([_collection_Items count]==0) {
        _noDeviceLabel.hidden=NO;
    }
    else{
        _noDeviceLabel.hidden=YES;
    }
    [_deviceListTableview reloadData];
    [_loadingView setLoadingShow:NO :@""];
}


//Set StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
