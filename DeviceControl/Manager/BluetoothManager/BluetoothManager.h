//
//  BluetoothManager.h
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/5/5.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PABlockDefinition.h"
#import "BluetoothModel.h"

@interface BluetoothManager : NSObject
<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic,strong) NSMutableArray<BluetoothModel*> *scanBlueArr;
@property (nonatomic,strong) NSTimer *instructionTimer;

+ (instancetype)shareBluetoothManager;
///主设中心
@property (strong, nonatomic) CBCentralManager      * centralManager;
///从设中心
@property (strong, nonatomic) CBPeripheralManager   * peripheralManager;
///发现的设备
@property (strong, nonatomic) CBPeripheral          * discoveredPeripheral;
///发送指令二进制
@property (strong, nonatomic) NSData *wirteData;
///蓝牙处理回调
@property(nonatomic,copy)BluetoothEventBlock blueToothBlock;
-(void)linkBluetooth:(BluetoothModel *)model;
///开始扫描
- (void)startScanPeripherals;
///广播之后开始扫描
- (void)startScanPeripherals:(NSArray *)arr;
///断开连接
-(void)discconnection;
///发送蓝牙指令
-(void)sendInstructions:(NSString *)instructionStr;
//-(void)sendTimerInstructions:(NSString *)instructionStr;

-(void)startInstructionTimer;
-(void)stopInstructionTimer;

@end
