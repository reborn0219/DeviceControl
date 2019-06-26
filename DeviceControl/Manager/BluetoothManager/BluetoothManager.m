//
//  BluetoothManager.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/5/5.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "BluetoothManager.h"
#import "UserUnitKeyModel.h"


@implementation BluetoothManager{
    
    NSTimer * connectTimer;
    int count;
    
    CBCharacteristic *_characteristicWrite;
    CBCharacteristic *_characteristic;
    
    CBMutableService *_customerService;
    CBMutableCharacteristic * _charPeripheral;
    
    NSMutableString *mutableStr;
    NSString * Cmmd;
    NSArray * blueTooths;
    UserUnitKeyModel * uukm;
    UserUnitKeyModel * timeOutUUKM;
    NSString * ls_openKey;
    NSArray *advArr_;
    NSNumber * rssi;
    int blueCount;
    
    ///蓝牙类型：1 社区大门 2 单元门 3 电梯
    NSInteger LeiXing;
    int tagValue;
    int cycleNumber;
    int advTAG;
}
#pragma mark - 初始化蓝牙主设中心
-(instancetype)init
{
    if (self = [super init]) {
        
        mutableStr = [[NSMutableString alloc]init];
        count = 0;
        tagValue = 0;
        advTAG = 0;
        cycleNumber = 0;
        if (!_centralManager){
            _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
            [_centralManager setDelegate:self];
        }
        
        [self startPeripheralAdvertising];
        
        
    }
    return self;
}

#pragma mark - 断开蓝牙连接

-(void)discconnection {
    
    if (_discoveredPeripheral!=nil&&_centralManager!=nil) {
        [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
        NSLog(@"Disco=====discconnection");
    }
    
}

#pragma mark - 开始搜索蓝牙设备

- (void)scanForPeripherals {
    
    if (IOS10_OR_LATER){
        
        if (_centralManager.state == CBManagerStateUnsupported) {//设备不支持蓝牙
            
        }else {//设备支持蓝牙连接
            
            if (_centralManager.state == CBManagerStatePoweredOn) {//蓝牙开启状态
                
                [self discconnection];
                _discoveredPeripheral=nil;
                rssi=[[NSNumber alloc]initWithInt:-100];
                
                if (blueTooths==nil) {
//                    blueTooths=(NSArray *)[UserDefaultsStorage getDataforKey:@"UserUnitKeyArray"];
                }
                if (blueTooths==nil||blueTooths.count==0) {
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(@"您所在单元还未安装智能开门设备",NOAuthorize);
                    }
                    return;
                }
                
                blueCount=0;
                [_centralManager scanForPeripheralsWithServices:nil options:nil];
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(@"正在搜索设备...",SearchBluetooth);
                }
                
                count=0;
                //开一个定时器监控连接超时的情况
                if (connectTimer) {
                    [connectTimer invalidate];//停止时钟
                    connectTimer=nil;
                }
                connectTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(connectTimeout) userInfo:nil repeats:YES];
            }
            else
            {
                alert(@"蓝牙设备未打开,请先打开蓝牙!",@"确认");
            }
            
            
        }
    }else
    {
        if (_centralManager.state == CBCentralManagerStateUnsupported) {//设备不支持蓝牙
            
        }else {//设备支持蓝牙连接
            
            if (_centralManager.state == CBCentralManagerStatePoweredOn) {//蓝牙开启状态
                [self discconnection];
                _discoveredPeripheral=nil;
                
                rssi=[[NSNumber alloc]initWithInt:-100];
                if (blueTooths==nil) {
//                    blueTooths=(NSArray *)[UserDefaultsStorage getDataforKey:@"UserUnitKeyArray"];
                }
                if (blueTooths==nil||blueTooths.count==0) {
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(@"您所在单元还未安装智能开门设备",NOAuthorize);
                    }
                    return;
                }
                
                blueCount=0;
                [_centralManager scanForPeripheralsWithServices:nil options:nil];
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(@"正在搜索设备...",SearchBluetooth);
                }
                
                count=0;
                ///开一个定时器监控连接超时的情况
                if (connectTimer) {
                    [connectTimer invalidate];///停止时钟
                    connectTimer=nil;
                }
                connectTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(connectTimeout) userInfo:nil repeats:YES];
            }
            else
            {
                alert(@"蓝牙设备未打开,请先打开蓝牙!",@"确认");
            }
            
            
        }
    }
}

#pragma mark - ScanTimer
- (void)startScanPeripherals
{
    
    [self scanForPeripherals];
    advTAG = 0;
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
    
}

#pragma mark - 发现蓝牙设备

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"-----扫描到的蓝牙名称------%@---蓝牙详情%@----advertisementData:----%@",peripheral.name==nil?@"0":peripheral.name,peripheral,advertisementData);
    
    [self findStrongBlueth:peripheral RSSI:RSSI andAdverDataName:[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    
}
#pragma mark - 查找用户是否有该蓝牙使用权限
-(void) findStrongBlueth:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI andAdverDataName:(NSString *)advStr {
    
    
    NSMutableArray *arr = [blueTooths mutableCopy];
    
    if (advArr_.count > 0) {
        for (int i = 0; i < advArr_.count; i++) {
            
            [arr insertObject:advArr_[i] atIndex:0];
        }
    }
    NSLog(@"-----扫描到的蓝牙名称------%@---蓝牙详情%@",peripheral.name==nil?@"------":peripheral.name,peripheral);
    NSString * scanBlueName = peripheral.name;
    
    if ([advStr isNotBlank]) {
        scanBlueName = advStr;
    }
    
    NSInteger counts=arr.count;
    
    for (int i=0; i<counts; i++) {
        
        uukm=[arr objectAtIndex:i];
        
        if (![scanBlueName isNotBlank]) {
            break;
        }
        //        if(1){
        if([scanBlueName isEqualToString:uukm.bluename]){
            
            ///搜索到蓝牙设备以后 发送广播
            if([uukm.version isEqualToString:@"3.0"])
            {
                
                ls_openKey =  uukm.openkey;
                
                if (![ls_openKey isEqualToString:@""]) {
                    
                    LeiXing= uukm.type.integerValue;
                    [_centralManager stopScan];
                    count=0;
                    ///开一个定时器监控连接超时的情况
                    if (connectTimer) {
                        [connectTimer invalidate];///停止时钟
                        connectTimer=nil;
                    }
                  
                    
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(@{@"name":scanBlueName,
                                              @"RSSI":rssi,@"uukm":uukm},DevInfo);
                    }
                    [self setUp];
                    break;
                }
            }
            
            /// type 蓝牙类型：1 社区大门 2 单元门 3 电梯
            if (uukm.type.intValue== 1) {
                
                LeiXing=1;
                rssi=RSSI;
                _discoveredPeripheral=peripheral;
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(@{@"name":scanBlueName,
                                          @"RSSI":rssi,@"uukm":uukm},DevInfo);
                }
                timeOutUUKM = uukm;
                
                _discoveredPeripheral=peripheral;
                [_centralManager stopScan];
                [connectTimer invalidate];//停止时钟
                connectTimer=nil;
                count=0;
                [self connect:_discoveredPeripheral];
                [_discoveredPeripheral setDelegate:self];
                
            }else if (uukm.type.integerValue==2) {
                
                LeiXing=2;
                if (rssi==nil) {
                    rssi=RSSI;
                    _discoveredPeripheral=peripheral;
                }
                
                if (rssi.integerValue<RSSI.integerValue) {
                    rssi=RSSI;
                    _discoveredPeripheral=peripheral;
                }
                
                [_centralManager stopScan];
                [connectTimer invalidate];//停止时钟
                connectTimer=nil;
                count=0;
                [self connect:_discoveredPeripheral];
                [_discoveredPeripheral setDelegate:self];
                timeOutUUKM = uukm;
                
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(@{@"name":scanBlueName,
                                          @"RSSI":rssi,@"uukm":uukm},DevInfo);
                }
                
            }else if(uukm.type.integerValue == 3) {
                
              
                
                timeOutUUKM = uukm;
                LeiXing=3;
                rssi=RSSI;
                _discoveredPeripheral=peripheral;
                if(self.blueToothBlock)
                {
                    self.blueToothBlock(@{@"name":scanBlueName,
                                          @"RSSI":rssi,@"uukm":uukm},DevInfo);
                }
                _discoveredPeripheral=peripheral;
                [_centralManager stopScan];
                [connectTimer invalidate];//停止时钟
                connectTimer=nil;
                count=0;
                [self connect:_discoveredPeripheral];
                [_discoveredPeripheral setDelegate:self];
                
            }
            
            break;
        }
    }
    
}

#pragma mark - 链接需要匹配的蓝牙设备

- (void)connect:(CBPeripheral *)peripheral{
    
    if (_centralManager.state == CBCentralManagerStateUnsupported) {//设备不支持蓝牙
        
    }else {//设备支持蓝牙连接
        
        if (_centralManager.state == CBCentralManagerStatePoweredOn) {//蓝牙开启状态
            
            //连接设备
            [_discoveredPeripheral setDelegate:self];
            [_centralManager connectPeripheral:_discoveredPeripheral
                                       options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
            
            if(self.blueToothBlock)
            {
                self.blueToothBlock(@"正在连接...",ConntectBluetooth);
            }
            
        }
        
    }
    
}

#pragma mark - 蓝牙连接超时

- (void)connectTimeout {
    
    count++;
    if(count>2) {
        
        [_centralManager stopScan];
        [connectTimer invalidate];//停止时钟
        connectTimer=nil;
        count=0;
        if(_discoveredPeripheral==nil){
            
            if(self.blueToothBlock)
            {
                self.blueToothBlock(@"未搜索到蓝牙设备~",NoFindDev);
            }
            
        }else {
          
            [self connect:_discoveredPeripheral];
            
        }
        
    }
    NSLog(@"count==%d",count);
}

#pragma mark - 蓝牙连接超时

-(void)connectTimeout2
{
    count++;
    if(count>2)
    {
        [_centralManager stopScan];
        [connectTimer invalidate];//停止时钟
        connectTimer=nil;
        count=0;
        [_peripheralManager stopAdvertising];
        if(_discoveredPeripheral==nil)
        {
            self.blueToothBlock(@"未搜索到蓝牙设备~",NoFindDev);
        }
        else
        {
            [self connect:_discoveredPeripheral];
        }
        
    }
    NSLog(@"count==%d",count);
}


#pragma mark - 蓝牙连接成功

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    _discoveredPeripheral = peripheral;
    [connectTimer invalidate];//停止时钟
    _discoveredPeripheral.delegate = self;
    [peripheral discoverServices:nil];
    [_discoveredPeripheral readRSSI];
    
}

#pragma mark - 发送蓝牙指令

- (BOOL)writeChar:(NSData *)data {
    
    NSLog(@"====writeChar=%@",data);
    NSLog(@"====writeChar===lenth==%ld",(unsigned long)data.length);
    if (data==nil||data.length==0) {
        
        if(self.blueToothBlock)
        {
            self.blueToothBlock(@"打开失败!",OpenError);
        }
        
        return NO;
    }
    
    if ([uukm.version isEqualToString:@"2.0"]) {
        
        if (data.length > 20) {
            
            for (int i = 0; i < data.length / 20 + 1; i++) {
                
                NSData *dataCut;
                
                if (i == data.length / 20) {
                    
                    dataCut = [data subdataWithRange:NSMakeRange(0 + i*20, data.length - i * 20)];
                    
                }else{
                    
                    dataCut = [data subdataWithRange:NSMakeRange(0 + i*20, 20)];
                }
                
                [_discoveredPeripheral writeValue:dataCut forCharacteristic:_characteristicWrite type:CBCharacteristicWriteWithResponse];
                
                sleep(0.1);
                
            }
            
        }else{
            
            [_discoveredPeripheral writeValue:data forCharacteristic:_characteristicWrite type:CBCharacteristicWriteWithResponse];
            
        }
        
    }else{
        
        [_discoveredPeripheral writeValue:data forCharacteristic:_characteristic type:CBCharacteristicWriteWithoutResponse];
        
    }
    
    return YES;
    
}

#pragma mark - 连接蓝牙设备失败

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if(self.blueToothBlock)
    {
        self.blueToothBlock(@"打开失败!",OpenError);
    }
    NSLog(@"%s",__FUNCTION__);
    
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
    
    for (CBService *service in peripheral.services) {
        
        //发现服务
        if ([uukm.version isEqualToString:@"2.0"]) {
            
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FEE7"]]) {
        
                NSLog(@"Service found with UUID: %@", service.UUID);//查找特征
                [peripheral discoverCharacteristics:nil forService:service];
                break;
            }
            
        }else {
            
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]]) {
                
                NSLog(@"Service found with UUID: %@", service.UUID);//查找特征
                [peripheral discoverCharacteristics:nil forService:service];
                break;
            }
            
        }
        
    }
    
}

#pragma mark - 发现特征的回调

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    NSLog(@"\nservice's UUID :%@\nCharacteristics :%@",service.UUID,service.characteristics);
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        if ([uukm.version isEqualToString:@"2.0"]) {
            
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FEC7"]]) {
                
                _characteristicWrite = characteristic;//保存写的特征
                //[self writeChar:_wirteData];
                
            }
            
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FEC8"]]) {
                
                NSLog(@"Discovered write characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
                
                _characteristic = characteristic;//保存接收的特征
                
                //订阅特征值
                [_discoveredPeripheral setNotifyValue:YES forCharacteristic:_characteristic];
                
                NSLog(@"发送指令:%f",[[NSDate date] timeIntervalSince1970]);
                
                if(self.blueToothBlock) {
                    self.blueToothBlock(@"发送指令...",DevNew);
                }
                
            }
            
        }else{
            
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
                
                NSLog(@"Discovered write characteristics:%@ for service: %@", characteristic.UUID, service.UUID);
                _characteristic = characteristic;//保存写的特征
                Cmmd=uukm.openkey;
                [_discoveredPeripheral setNotifyValue:YES forCharacteristic:_characteristic];
                
                NSLog(@"发送指令:%f",[[NSDate date] timeIntervalSince1970]);
                
                if(self.blueToothBlock) {
                    self.blueToothBlock(@"发送指令...",SendCommd);
                }
                
                if ([self writeChar:[Cmmd dataUsingEncoding:NSUTF8StringEncoding]]) {
                    
                }
                
                break;
                
            }
            
        }
        
    }
    
}

#pragma mark - 暂时未调用 --- 当外设启动或者停止指定特征值的通知时回调

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if(error==nil) {
        
        if(characteristic.value.length>0) {
            
            NSString *msg = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            
            NSLog(@"====didUpdateNotificationStateForCharacteristic==%@  eerr=%@ length=%ld",msg,error,characteristic.value.length);
            
            if ([msg isNotBlank]) {
                
                NSLog(@"发送指令成功:%f",[[NSDate date] timeIntervalSince1970]);
                
                msg=@"";
                
                if(LeiXing==1) {
                    
                    msg=@"社区大门已打开";
                    
                }else if(LeiXing==2) {
                    
                    msg=@"单元门已打开";
                    
                }else if(LeiXing==3) {
                    
                    msg=@"已授权,请按电梯楼层!";
                    
                }
                
                if(self.blueToothBlock) {
                    self.blueToothBlock(msg,OpenOk);
                }
                
            }else {
                
                if(self.blueToothBlock) {
                    self.blueToothBlock(@"打开失败!",OpenError);
                }
                
            }
            
            [self discconnection];
            
        }
        
    }else {
        [self discconnection];
    }
    
}

#pragma mark - 蓝牙摇一摇开门成功返回回调 --- 当特征值发现变化时回调

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if(error==nil) {
        
        if(characteristic.value.length>0) {
            
            if ([uukm.version isEqualToString:@"2.0"]) {
                
                Byte *bytes=(Byte*)[characteristic.value bytes];
                
                NSString *msg=@"";
                
                for(int i=0;i<[characteristic.value length];i++) {
                    
                    NSString *newHexStr=[NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
                    
                    if([newHexStr length]==1)
                        
                        msg=[NSString stringWithFormat:@"%@0%@",msg,newHexStr];
                    
                    else
                        
                        msg=[NSString stringWithFormat:@"%@%@",msg,newHexStr];
                    
                }
                
                NSString *showMsg;
                
                if (tagValue == 0) {
                    
                    NSString *result = [msg substringWithRange:NSMakeRange(4, 4)];
                    
                    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([result UTF8String],0,16)];
                    NSLog(@"心跳数字 10进制 %@",temp10);
                    //转成数字
                    cycleNumber = [temp10 intValue];
                    tagValue ++;
                    
                }
                
                [mutableStr appendString:msg];
                
                NSLog(@"%ld       %d",mutableStr.length,cycleNumber);
                
                if ([mutableStr isEqualToString:@"fe01001b271200030a00120ffecf0001000f0001000300004f4b00"]) {
                    
                    [mutableStr deleteCharactersInRange:NSMakeRange(0, mutableStr.length)];
                    showMsg = @"大门已打开";
                    [self discconnection];
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(showMsg,OpenOk);
                    }
                    tagValue = 0;
                    
                }else if ([mutableStr isEqualToString:@"fe010010271300020a001a0411223344"]){
                    
                    [self writeChar:_wirteData];
                    [mutableStr deleteCharactersInRange:NSMakeRange(0, mutableStr.length)];
                    showMsg = @"开始创建";
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(showMsg,initOk);
                    }
                }else if (mutableStr.length == cycleNumber * 2) {
                    
                    [self writeChar:_wirteData];
                    showMsg = @"开始注册";
                    [mutableStr deleteCharactersInRange:NSMakeRange(0, mutableStr.length)];
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(showMsg,autoOk);
                    }
                    
                }else if ([mutableStr isEqualToString:@"fe010027271200030a00121bfecf0001001b00010003000048656c6c6f2c205765436861742100"]){
                    [mutableStr deleteCharactersInRange:NSMakeRange(0, mutableStr.length)];
                    showMsg = @"收到消息！！！！！";
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(showMsg,backOk);
                    }
                }
                
                
                
            }else{
                
                NSString *msg = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
                NSLog(@"====didUpdateValueForCharacteristic==%@  eerr=%@ length=%ld",msg,error,characteristic.value.length);
                
                if ([msg isNotBlank]) {
                    
                    NSLog(@"发送指令成功:%f",[[NSDate date] timeIntervalSince1970]);
                    NSString * msg=@"";
                    if(LeiXing==1)
                    {
                        msg=@"社区大门已打开";
                    }
                    else if(LeiXing==2)
                    {
                        msg=@"单元门已打开";
                    }
                    else if(LeiXing==3)
                    {
                        msg=@"已授权,请按电梯楼层!";
                    }
                    if(self.blueToothBlock)
                    {
                        self.blueToothBlock(msg,OpenOk);
                    }
                }
                
                [self discconnection];
                
            }
        }
    }else {
        
        [self discconnection];
    }
    
}

#pragma  mark -- 遍历权限数组返回openKey

- (NSString *)searchOpenKey:(NSNumber *)type :(NSString *)openkey {
    
    /// type    蓝牙类型：1 社区大门 2 单元门 3 电梯
    switch (type.integerValue) {
        case 1:
        {
            return [NSString stringWithFormat:@"sq%@",openkey];
            
        }
            break;
        case 2:
        {
            return [NSString stringWithFormat:@"dm%@",openkey];
            
        }
            break;
        case 3:
        {
            return [NSString stringWithFormat:@"ys%@",openkey];
            
        }
            break;
        default:
        {
            return @"";
        }
            break;
    }
    
    return @"";
    
}
#pragma mark - 蓝牙广播初始化设置

-(void)setUp{
    
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:@"FEC8"];
    _charPeripheral = [[CBMutableCharacteristic alloc]initWithType:characteristicUUID properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    CBUUID *serviceUUID = [CBUUID UUIDWithString:@"FEC8"];
    _customerService = [[CBMutableService alloc]initWithType:serviceUUID primary:YES];
    [_peripheralManager addService:_customerService];
    
}
#pragma  mark -- CBPeripheralManagerDelegate 蓝牙广播代理方法

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    switch (peripheral.state) {
            
        case CBPeripheralManagerStatePoweredOn:
            
            break;
        case CBPeripheralManagerStatePoweredOff:
            
            break;
            
        default:
            break;
    }
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    
    
    if (error == nil) {
        
        if ([ls_openKey isEqualToString:@""]||ls_openKey==nil) {
            
            return;
            
        }
        [_peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey : ls_openKey}];
        NSString * msg=@"";
        if(LeiXing==1)
        {
            msg=@"社区大门已打开";
        }
        else if(LeiXing==2)
        {
            msg=@"单元门已打开";
        }
        else if(LeiXing==3)
        {
            msg=@"已授权,请按电梯楼层!";
        }
        if(self.blueToothBlock)
        {
            self.blueToothBlock(msg,OpenOk);
        }
        
    }
    
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    
    NSLog(@"in peripheralManagerDidStartAdvertisiong:error");
    
    if (error==nil) {
        
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:7.0];
        
    }
    
}
#pragma mark - 蓝牙广播7秒后结束
-(void)delayMethod {
    
    [_peripheralManager stopAdvertising];
    [_peripheralManager removeAllServices];
    
}

#pragma mark - 初始化广播

-(void)startPeripheralAdvertising {
    
    if (_peripheralManager==nil) {
        
        _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    }
    
}

@end
