//
//  BluetoothManager.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/5/5.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BluetoothManager.h"


@implementation BluetoothManager{
    
    NSTimer * connectTimer;
    CBCharacteristic *_characteristicWrite;
    CBMutableCharacteristic * _charPeripheral;
    NSMutableString *mutableStr;
    NSArray * blueTooths;
    NSString * ls_openKey;
    NSArray *advArr_;
    NSNumber * rssi;
    int cycleNumber;
    NSMutableArray * instructionArr;
    BOOL istimer;
}
+ (instancetype)shareBluetoothManager{
    static BluetoothManager *_shareBluetooth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareBluetooth = [[super allocWithZone:NULL] init];
    });
    return _shareBluetooth;
}
#pragma mark - 初始化蓝牙主设中心


-(instancetype)init
{
    if (self = [super init]) {
        
        mutableStr = [[NSMutableString alloc]init];
        cycleNumber = 0;
        if (!_centralManager){
            _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
            [_centralManager setDelegate:self];
        }
        
    }
    return self;
}
-(NSTimer *)instructionTimer{
    if (!_instructionTimer) {
        instructionArr = [NSMutableArray array];
        _instructionTimer = [NSTimer timerWithTimeInterval:Time_Interval target:self selector:@selector(sendInstructionAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_instructionTimer forMode:NSRunLoopCommonModes];
    }
    return _instructionTimer;
}
-(void)startInstructionTimer{
    istimer = YES;
    [self.instructionTimer setFireDate:[NSDate distantPast]];
}
-(void)stopInstructionTimer{
    istimer = NO;
    [self.instructionTimer setFireDate:[NSDate distantFuture]];
}

-(void)sendInstructionAction{
    NSString * instructionStr = instructionArr.firstObject;
    NSLog(@"-----时间指令--%@---",instructionStr);
    if (instructionStr) {
        NSData *data =[self hexToBytes:instructionStr];
        if (_characteristicWrite) {
            [self.discoveredPeripheral writeValue:data forCharacteristic:_characteristicWrite type:CBCharacteristicWriteWithoutResponse];
        }else{
            NSLog(@"-----特征码未找到-----");
        }
        [instructionArr removeFirstObject];
    }
   
}
#pragma mark - 断开蓝牙连接
-(NSMutableArray *)scanBlueArr{
    if (!_scanBlueArr) {
        _scanBlueArr = [NSMutableArray array];
    }
    return _scanBlueArr;
}
-(void)discconnection {
    
    if (_discoveredPeripheral!=nil&&_centralManager!=nil) {
        [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
        NSLog(@"Disco=====discconnection");
    }
    
}

#pragma mark - 开始搜索蓝牙设备

- (void)scanForPeripherals {
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}
#pragma mark - ScanTimer
- (void)startScanPeripherals
{
    [self.scanBlueArr removeAllObjects];
    [self scanForPeripherals];
}

-(void)startScanPeripherals:(NSArray *)advArr{
    
    advArr_ = advArr;
    [self scanForPeripherals];
}

#pragma mark - 停止搜索
- (void)stopScan
{
    [_centralManager stopScan];
}

#pragma mark - CBCentralManager Delegate /// 蓝牙状态

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(self.blueToothBlock)
    {
        self.blueToothBlock(central,BluetoothState);
    }
    [_centralManager scanForPeripheralsWithServices:nil options:nil];
    
}

#pragma mark - 发现蓝牙设备

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"正在扫描蓝牙。。。");
    if (peripheral.name) {
//        NSLog(@"%@",peripheral.identifier);
        NSLog(@"扫描到有名字蓝牙。。。");
//        if ([peripheral.name isEqualToString:@"PARA-V002"]) {
        
          
            for (BluetoothModel *model in self.scanBlueArr) {
                if([model.name isEqualToString:peripheral.name]){
                    [self.scanBlueArr removeObject:model];
                    break;
                }
            }
            BluetoothModel *blueModel = [[BluetoothModel alloc]init];
            blueModel.discoveredPeripheral = peripheral;
            blueModel.name = peripheral.name;
            [_scanBlueArr addObject:blueModel];
            if(_blueToothBlock){
                _blueToothBlock(_scanBlueArr,SearchBluetooth);
            }
//        }
    }
}

#pragma mark - 链接需要匹配的蓝牙设备
-(void)linkBluetooth:(BluetoothModel *)model{
    [self discconnection];
    [_centralManager connectPeripheral:model.discoveredPeripheral options:nil];
    _discoveredPeripheral = model.discoveredPeripheral;
    NSLog(@"正在链接蓝牙。。。");

//    [_centralManager connectPeripheral:_discoveredPeripheral
//                               options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

#pragma mark - 蓝牙连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"蓝牙链接成功！");
    [self.discoveredPeripheral setDelegate:self];
    [self.discoveredPeripheral discoverServices:nil];
    [_centralManager stopScan];
    if (self.blueToothBlock) {
        self.blueToothBlock(nil,SendCommd);
    }
}
-(void)sendTimerInstructions:(NSString *)instructionStr{
    [instructionArr addObject:instructionStr];
    
    if (istimer) {
//        NSLog(@"--正在执行命令--");
    }else{
//        NSLog(@"--开启定时器--");
        [self startInstructionTimer];
    }
}
#pragma mark - 发送蓝牙指令
-(void)sendInstructions:(NSString *)instructionStr{
    [self stopInstructionTimer];
    [instructionArr removeAllObjects];
    NSData *data =[self hexToBytes:instructionStr];
    if (_characteristicWrite) {
        [self.discoveredPeripheral writeValue:data forCharacteristic:_characteristicWrite type:CBCharacteristicWriteWithoutResponse];
    }else{
        NSLog(@"-----特征码未找到-----");
    }
}
//hex -> NSData
-(NSData*) hexToBytes:(NSString *)str {
//    NSMutableData* data = [NSMutableData data];
//    int idx;
//    for (idx = 0; idx+2 <= str.length; idx+=2) {
//        NSRange range = NSMakeRange(idx, 2);
//        NSString* hexStr = [str substringWithRange:range].uppercaseString;
//        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
//        unsigned int intValue;
//        [scanner scanHexInt:&intValue];
//        [data appendBytes:&intValue length:1];
//    }
//    return data;
    
        NSMutableData* data = [NSMutableData data];
        int idx;
        for(idx = 0; idx + 2 <= str.length; idx += 2){
            NSRange range = NSMakeRange(idx, 2);
            NSString* hexStr = [str substringWithRange:range];
            NSScanner* scanner = [NSScanner scannerWithString:hexStr];
            unsigned int intValue;
            [scanner scanHexInt:&intValue];
            [data appendBytes:&intValue length:1];
        }
        return data;
}
#pragma mark - 连接蓝牙设备失败

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

#pragma mark - 断开连接

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - CBPeripheral Delegate

#pragma mark - 当连接外设成功后获取信号强度的方法后回调

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    NSLog(@"====didReadRSSI==%@  eerr=%@",RSSI,error.description);
    if (error!=nil) {
        
    }
}

#pragma mark - 发现服务的回调

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for(CBService* s in peripheral.services){
        [peripheral discoverCharacteristics:nil forService:s];
        NSLog(@"扫描Characteristics...");

    }
}

#pragma mark - 发现特征的回调

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    NSLog(@"\nservice's UUID :%@\nCharacteristics :%@",service.UUID,service.characteristics);
    
    for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-8841-43F4-A8D4-ECBE34729BB3"]]) {
                _characteristicWrite = characteristic;//保存写的特征
                if (self.blueToothBlock) {
                    self.blueToothBlock(nil,SendCommd);
                }

            }
    }
}

#pragma mark - 暂时未调用 --- 当外设启动或者停止指定特征值的通知时回调

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
}

#pragma mark - 蓝牙摇一摇开门成功返回回调 --- 当特征值发现变化时回调

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

@end
