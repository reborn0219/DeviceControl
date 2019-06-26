//
//  UserAllHouseModel.h
//  YouLifeApp
//
//  Created by us on 15/11/26.
//  Copyright © 2015年 us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserUnitKeyModel : NSObject

///蓝牙类型：1 社区大门 2 单元门 3 电梯
@property (nonatomic ,copy)NSNumber * type;
@property (nonatomic ,copy)NSString * name;
///蓝牙名字
@property (nonatomic ,copy)NSString * bluename;
///蓝牙UUID
@property (nonatomic ,copy)NSString * UUID;
///开门密码
@property (nonatomic ,copy)NSString * openkey;
///蓝牙版本  2.0点对点连接  3.0蓝牙广播
@property (nonatomic ,copy)NSString * version;
///社区ID
@property (nonatomic ,copy)NSString * communityid;


@end
