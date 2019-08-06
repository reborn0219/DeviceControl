//
//  ColorModel.h
//  DeviceControl
//
//  Created by 刘帅 on 2019/7/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorModel : NSObject
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,strong)UIColor *color;
@property(nonatomic,strong)NSData *colorData;

@end

NS_ASSUME_NONNULL_END
