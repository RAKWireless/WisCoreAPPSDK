//
//  LoadingView.m
//  smartdrone
//
//  Created by liweixiang on 15-4-28.
//  Copyright (c) 2015年 rak. All rights reserved.
//

#import "LoadingView.h"
#import "CommanParameters.h"

@interface LoadingView ()
{
    UIImageView *gifImageView;
    UILabel *showText;
}
@end
@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = LOAD_SHADOW_COLOR;
    
    CGRect rectBuffer;
    
    rectBuffer.size.width = device_info_list_row_height;
    rectBuffer.size.height = device_info_list_row_height;
    rectBuffer.origin.x = self.frame.size.width / 3;
    rectBuffer.origin.y = self.frame.size.height / 2 - rectBuffer.size.height / 2;
    gifImageView = [[UIImageView alloc] initWithFrame:rectBuffer];
    gifImageView.center=self.center;
    NSArray *gifArray = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"00.png"],
                         [UIImage imageNamed:@"01.png"],
                         [UIImage imageNamed:@"02.png"],
                         [UIImage imageNamed:@"03.png"],
                         [UIImage imageNamed:@"04.png"],
                         [UIImage imageNamed:@"05.png"],
                         [UIImage imageNamed:@"06.png"],
                         [UIImage imageNamed:@"07.png"],
                         [UIImage imageNamed:@"08.png"],
                         [UIImage imageNamed:@"09.png"],
                         [UIImage imageNamed:@"10.png"],
                         [UIImage imageNamed:@"11.png"],
                         [UIImage imageNamed:@"12.png"],
                         [UIImage imageNamed:@"13.png"],
                         [UIImage imageNamed:@"14.png"],
                         [UIImage imageNamed:@"15.png"],
                         [UIImage imageNamed:@"16.png"],
                         [UIImage imageNamed:@"17.png"],
                         [UIImage imageNamed:@"18.png"],
                         [UIImage imageNamed:@"19.png"],
                         [UIImage imageNamed:@"20.png"],
                         [UIImage imageNamed:@"21.png"],
                         [UIImage imageNamed:@"22.png"],
                         [UIImage imageNamed:@"23.png"],
                         [UIImage imageNamed:@"24.png"],
                         [UIImage imageNamed:@"25.png"],
                         [UIImage imageNamed:@"26.png"],
                         [UIImage imageNamed:@"27.png"],
                         [UIImage imageNamed:@"28.png"],
                         [UIImage imageNamed:@"29.png"],
                         [UIImage imageNamed:@"30.png"],
                         [UIImage imageNamed:@"31.png"],
                         [UIImage imageNamed:@"32.png"],
                         [UIImage imageNamed:@"33.png"],
                         [UIImage imageNamed:@"34.png"],
                         [UIImage imageNamed:@"35.png"],
                         [UIImage imageNamed:@"36.png"],
                         [UIImage imageNamed:@"37.png"],
                         [UIImage imageNamed:@"38.png"],
                         [UIImage imageNamed:@"39.png"],
                         [UIImage imageNamed:@"40.png"],
                         [UIImage imageNamed:@"41.png"],
                         [UIImage imageNamed:@"42.png"],
                         [UIImage imageNamed:@"43.png"],
                         [UIImage imageNamed:@"44.png"],
                         [UIImage imageNamed:@"45.png"],
                         [UIImage imageNamed:@"46.png"],
                         [UIImage imageNamed:@"47.png"],nil];
    gifImageView.animationImages = gifArray; //动画图片数组
    gifImageView.animationRepeatCount = 0;  //动画重复次数
    [self addSubview:gifImageView];
    
    rectBuffer.size.width = self.frame.size.width;
    rectBuffer.size.height = viewH*20/view_fix_height;
    rectBuffer.origin.x = gifImageView.frame.origin.x + gifImageView.frame.size.width * 1.2;
    rectBuffer.origin.y = gifImageView.frame.origin.y+gifImageView.frame.size.height;

    showText = [[UILabel alloc] initWithFrame:rectBuffer];
    showText.center=CGPointMake(self.frame.size.width*0.5, showText.center.y);
    showText.text = @"";
    showText.textColor = [UIColor whiteColor];
    showText.textAlignment=NSTextAlignmentCenter;
    showText.font = [UIFont systemFontOfSize:contact_text_size];

    [self addSubview:showText];
    self.hidden = YES;
}

- (void)setLoadingShow:(BOOL)isShow :(NSString*)str
{
    showText.text = str;
    self.hidden = !isShow;
    isShow ? [gifImageView startAnimating] : [gifImageView stopAnimating];
}

- (void)setLoadingText:(NSString*)str
{
    showText.text = str;
}
@end
