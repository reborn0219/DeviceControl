//
//  AboutViewController.m
//  DeviceControl
//
//  Created by yang on 2019/7/16.
//  Copyright © 2019 yang. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (nonatomic,strong) UIImageView *imgV;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBar:1];
    [self.view addSubview:self.imgV];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2,200,100, 100)];
        [_imgV setImage:[UIImage imageNamed:@"关于logo"]];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(0,320,SCREEN_WIDTH,30)];
        lb.textColor = HexRGB(0x4a509b);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:20];
        lb.text = @"V 1.0";
        [self.view addSubview:lb];
    }
    return _imgV;
}
@end
