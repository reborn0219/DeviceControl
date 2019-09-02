//
//  RightPopController.m
//  DeviceControl
//
//  Created by yang on 2019/7/8.
//  Copyright © 2019 yang. All rights reserved.
//

#import "RightPopController.h"
#import "AboutViewController.h"

@interface RightPopController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_top;
@property (weak, nonatomic) IBOutlet UITextField *countTF;
@property (nonatomic,strong) UIViewController *currentVC;

@end

@implementation RightPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    _countTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:Lights_Number];
    _countTF.delegate = self;
    _countTF.layer.cornerRadius =2;
    _countTF.layer.borderWidth =1;
    _countTF.layer.borderColor = [UIColor whiteColor].CGColor;
    _backView_top.constant = k_Height_StatusBar;
}
- (IBAction)increaseAction:(id)sender {
    //增加
    NSInteger conunt = _countTF.text.integerValue;
    conunt ++;
    if (conunt>99) {
        conunt = 99;
    }
     _countTF.text = [NSString stringWithFormat:@"%ld",conunt];
    [self saveLightNumber];

}
- (IBAction)reduceAction:(id)sender {
//    减少
    NSInteger conunt = _countTF.text.integerValue;
    conunt --;
    if (conunt<1) {
        conunt = 1;
    }
    _countTF.text = [NSString stringWithFormat:@"%ld",conunt];
    [self saveLightNumber];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)saveLightNumber{
    [[NSUserDefaults standardUserDefaults]setObject:_countTF.text forKey:Lights_Number];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self saveLightNumber];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];

}
- (IBAction)aboutUsAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    AboutViewController * aboutVC = [[AboutViewController alloc]init];
    aboutVC.hidesBottomBarWhenPushed = YES;
    [_currentVC.navigationController pushViewController:aboutVC animated:YES];
}

-(void)showInVC:(UIViewController *)VC {
    _currentVC = VC;
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }else {
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [VC presentViewController:self animated:YES completion:nil];
}
- (UIViewController *)jsd_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}
- (UIViewController *)getCurrentViewController{
    
    UIViewController* currentViewController = [self jsd_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}
@end
