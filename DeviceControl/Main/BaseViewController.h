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

@end

NS_ASSUME_NONNULL_END
