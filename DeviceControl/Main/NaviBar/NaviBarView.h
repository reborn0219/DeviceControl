//
//  NaviBarView.h
//  OneBAuction
//
//  Created by 刘帅 on 2019/4/7.
//  Copyright © 2019 刘帅. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NaviBarView : UIView
@property (weak, nonatomic) IBOutlet UILabel *subtitleLb;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic,copy) AlertBlock block;
@end

NS_ASSUME_NONNULL_END
