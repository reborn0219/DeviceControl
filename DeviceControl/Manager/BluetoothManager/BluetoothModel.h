//
//  UserAllHouseModel.h
//  YouLifeApp
//
//  Created by us on 15/11/26.
//  Copyright © 2015年 us. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothModel : NSObject
@property(nonatomic,strong)CBCharacteristic * characteristicWrite;
@property(nonatomic,strong)CBCharacteristic * charPeripheral;
@property (nonatomic ,copy)NSString * name;
@end
