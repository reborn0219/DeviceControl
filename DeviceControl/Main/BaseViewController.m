//
//  BaseViewController.m
//  OneBAuction
//
//  Created by 刘帅 on 2019/4/6.
//  Copyright © 2019 刘帅. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftPopController.h"
#import "RightPopController.h"
@interface BaseViewController ()
@property (nonatomic, retain) UIView* overlayView;
@property (nonatomic, retain) UIView* bgview;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) UIImageView *loadingImageView;
@end

@implementation BaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    if (iOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.navibarView];
    MJWeakSelf
    _navibarView.block = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf backAction];
        }else if(index == 1){
            [weakSelf rightAction];
        }
    };
    self.view.backgroundColor = SHADOW_COLOR;
 
}
-(void)setNaviBar:(NSInteger)type{
    [self.navibarView.backBtn setHidden:NO];
    [self.navibarView.searchBtn setHidden:NO];

    if (type==0) {
        [self.navibarView.backBtn setHidden:YES];
    }else if (type==1) {
        [self.navibarView.searchBtn setHidden:YES];
        [self.navibarView.backBtn setHidden:NO];
        self.navibarView.titleLb.text = NSLocalizedString(@"关于",nil);
        [self.navibarView.backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.navibarView.backBtn setTitle:@"返回" forState:UIControlStateNormal];
        
    }else if (type==2) {
        [self.navibarView.searchBtn setHidden:YES];
        [self.navibarView.backBtn setHidden:NO];
        [self.navibarView.subtitleLb setHidden:NO];
    }else if (type==3) {
        [self.navibarView.searchBtn setHidden:YES];
        [self.navibarView.backBtn setHidden:YES];
        [self.navibarView.subtitleLb setHidden:YES];
    }else if (type==4) {
        [self.navibarView.searchBtn setHidden:NO];
        [self.navibarView.backBtn setHidden:NO];
        [self.navibarView.searchBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.navibarView.backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.navibarView.backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.navibarView.searchBtn setTitle:@"发布" forState:UIControlStateNormal];

        [self.navibarView.subtitleLb setHidden:YES];
    }

}

- (void)backSweepGesture:(UISwipeGestureRecognizer*)gesture{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Lazy loading
-(NaviBarView *)navibarView{
    if (!_navibarView) {
        _navibarView = [[[NSBundle mainBundle]loadNibNamed:@"NaviBarView" owner:self options:nil] lastObject];
        [_navibarView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, k_Height_StatusBar+50)];
        [_navibarView setBackgroundColor:SHADOW_COLOR];
    }
    return _navibarView;
}
#pragma mark Action
-(void)backAction{
    LeftPopController *leftVC = [[LeftPopController alloc]init];
    [leftVC showInVC:self];
}
-(void)rightAction{
    RightPopController *rightVC = [[RightPopController alloc]init];
    [rightVC showInVC:self];
}
-(void)setCustomerTitle:(NSString *)title{
    
    _navibarView.titleLb.text = title;
   
    
}
/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    if (hex.length==1) {
        hex = [NSString stringWithFormat:@"0%@",hex];
    }
    return hex;
}
@end
