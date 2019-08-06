//
//  ColorModel.m
//  DeviceControl
//
//  Created by 刘帅 on 2019/7/14.
//  Copyright © 2019 yang. All rights reserved.
//

#import "ColorModel.h"

@implementation ColorModel
-(void)setColor:(UIColor *)color{
    _color = color;
    _colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
}
@end
