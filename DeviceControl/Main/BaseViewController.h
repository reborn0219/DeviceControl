//
//  BaseViewController.h
//  OneBAuction
//
//  Created by 刘帅 on 2019/4/6.
//  Copyright © 2019 刘帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
@property (nonatomic, retain) NaviBarView * navibarView;

-(void)backAction;
-(void)rightAction;
-(void)setCustomerTitle:(NSString *)title;

-(void)setNaviBar:(NSInteger)type;
/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
-(NSString *)getHexByDecimal:(NSInteger)decimal;
@end

NS_ASSUME_NONNULL_END
