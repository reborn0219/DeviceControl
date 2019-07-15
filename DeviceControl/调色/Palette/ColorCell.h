//
//  ColorCell.h
//  DeviceControl
//
//  Created by 刘帅 on 2019/6/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ColorCell : UICollectionViewCell
-(void)assignmentData:(ColorModel *)model;
@end

NS_ASSUME_NONNULL_END
