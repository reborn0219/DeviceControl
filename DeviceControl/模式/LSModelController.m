//
//  LSModelController.m
//  DeviceControl
//
//  Created by yang on 2019/6/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSModelController.h"
#import "BluetoothManager.h"
@interface LSModelController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
   NSDate* begainDate;
}
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *dataSouce;
@property(nonatomic,strong)UISlider *lightSlider;
@property(nonatomic,strong)UISlider *speedSlider;
@property(nonatomic,strong)NSMutableArray *instructionArr;
@property (nonatomic,copy) NSString *lightStr;
@property (nonatomic,copy) NSString *speedStr;
@property (nonatomic,copy) NSString *instruction;
@property(nonatomic,strong)UIImageView *backImgV;
@end

@implementation LSModelController

- (void)viewDidLoad {
    [super viewDidLoad];
    _speedStr = @"00";
    _lightStr = @"30";
    _instruction = @"01";
    [self.view addSubview:self.backImgV];

    [self.dataSouce addObjectsFromArray:@[NSLocalizedString(@"红色渐变",nil),
                                          NSLocalizedString(@"绿色渐变",nil),
                                          NSLocalizedString(@"蓝色渐变",nil),
                                          NSLocalizedString(@"黄色渐变",nil),
                                          NSLocalizedString(@"青色渐变",nil),
                                          NSLocalizedString(@"紫色渐变",nil),
                                          NSLocalizedString(@"白色渐变",nil),
                                          NSLocalizedString(@"红绿渐变",nil),
                                          NSLocalizedString(@"红蓝渐变",nil),
                                          NSLocalizedString(@"绿蓝渐变",nil),
                                          NSLocalizedString(@"七色渐变",nil),
                                          NSLocalizedString(@"红绿频闪",nil),
                                          NSLocalizedString(@"红蓝频闪",nil),
                                          NSLocalizedString(@"绿蓝频闪",nil),
                                          NSLocalizedString(@"黄青频闪",nil),
                                          NSLocalizedString(@"绿紫频闪",nil),
                                          NSLocalizedString(@"三色频闪",nil),
                                          NSLocalizedString(@"七色频闪",nil),
                                          NSLocalizedString(@"红色静态",nil),
                                          NSLocalizedString(@"绿色静态",nil),
                                          NSLocalizedString(@"蓝色静态",nil),
                                          NSLocalizedString(@"青色静态",nil),
                                          NSLocalizedString(@"黄色静态",nil),
                                          NSLocalizedString(@"紫色静态",nil),
                                          NSLocalizedString(@"白色静态",nil),
                                          NSLocalizedString(@"流星炫彩A",nil),
                                          NSLocalizedString(@"流星炫彩B",nil),
                                          NSLocalizedString(@"流星炫彩C",nil),
                                          ]];
    [self.instructionArr addObjectsFromArray:@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"0A",@"0B",@"0C",@"0D",@"0E",@"0F",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"1A",@"1B",@"1C"]];
    
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.lightSlider];
    [self.view addSubview:self.speedSlider];
    [self.pickerView selectRow:(self.dataSouce.count*500/2) inComponent:0 animated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self assemblyInstructions];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - lazy loading
-(UIImageView *)backImgV{
    if (!_backImgV) {
        _backImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavBar_H+6, SCREEN_WIDTH, SCREEN_HEIGHT-NavBar_H-k_Height_TabBar)];
        [_backImgV setImage:[UIImage imageNamed:@"背景"]];
        
    }
    return _backImgV;
}
-(NSMutableArray *)instructionArr{
    if (!_instructionArr) {
        _instructionArr = [NSMutableArray array];
    }
    return _instructionArr;
}
-(NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,NavBar_H,SCREEN_WIDTH,SCREEN_HEIGHT-250-NavBar_H)];
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0,(SCREEN_HEIGHT-250-NavBar_H)/2.0f+NavBar_H, SCREEN_WIDTH,1)];
        [lineV setBackgroundColor:HexRGB(0xD33BFF)];
        [self.view addSubview:lineV];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        //        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}
-(UISlider *)lightSlider{
    if (!_lightSlider) {
        _lightSlider = [[UISlider alloc]initWithFrame:CGRectMake(45, SCREEN_HEIGHT-120,SCREEN_WIDTH-90,20)];
        [_lightSlider setThumbTintColor:Selected_Color];
        [_lightSlider setTintColor:Selected_Color];
        _lightSlider.minimumValue = 0;
        _lightSlider.maximumValue =100;
        _lightSlider.value = 30;
        [_lightSlider addTarget:self action:@selector(lightsliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
        [_lightSlider addTarget:self action:@selector(lightSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_lightSlider addTarget:self action:@selector(lightsliderTouchOutSide:) forControlEvents:UIControlEventTouchUpOutside];
        UILabel * lightLb = [[UILabel alloc]initWithFrame:CGRectMake(45,_lightSlider.frame.origin.y-25,200,20)];
        lightLb.text = @"亮度：30";
        lightLb.font = [UIFont systemFontOfSize:14.0f];
        lightLb.tag = 100;
        lightLb.textColor = [UIColor whiteColor];
        [self.view addSubview:lightLb];
        UIImageView * leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15,_lightSlider.frame.origin.y, 20, 20)];
        [leftImgV setImage:[UIImage imageNamed:@"亮度-"]];
        [self.view addSubview:leftImgV];
        UIImageView * rightImgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35,_lightSlider.frame.origin.y, 20, 20)];
        [rightImgV setImage:[UIImage imageNamed:@"亮度+"]];
        [self.view addSubview:leftImgV];
        [self.view addSubview:rightImgV];
        
    }
    return  _lightSlider;
}
-(UISlider *)speedSlider{
    if (!_speedSlider) {
        _speedSlider = [[UISlider alloc]initWithFrame:CGRectMake(45, SCREEN_HEIGHT-180,SCREEN_WIDTH-90,20)];
        _speedSlider.minimumValue = 0;
        _speedSlider.maximumValue =100;
        [_speedSlider setThumbTintColor:Selected_Color];
        [_speedSlider setTintColor:Selected_Color];
        [_speedSlider addTarget:self action:@selector(speedSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_speedSlider addTarget:self action:@selector(speedsliderTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
        [_speedSlider addTarget:self action:@selector(speedsliderTouchOutSide:) forControlEvents:UIControlEventTouchUpOutside];
        UILabel * speedLb = [[UILabel alloc]initWithFrame:CGRectMake(45,_speedSlider.frame.origin.y-25,200,20)];
        speedLb.tag = 101;
        speedLb.text = @"速度：0";
        speedLb.font = [UIFont systemFontOfSize:14.0f];
        speedLb.textColor = [UIColor whiteColor];
        [self.view addSubview:speedLb];
        UIImageView * leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15,_speedSlider.frame.origin.y, 20, 20)];
        [leftImgV setImage:[UIImage imageNamed:@"速度-"]];
        [self.view addSubview:leftImgV];
        UIImageView * rightImgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35,_speedSlider.frame.origin.y, 20, 20)];
        [rightImgV setImage:[UIImage imageNamed:@"速度-"]];
        [self.view addSubview:leftImgV];
        [self.view addSubview:rightImgV];
        
    }
    return  _speedSlider;
}

-(void)lightSliderValueChanged:(UISlider *)slider
{
    NSLog(@"slider value%f",slider.value);
    UILabel * lightLb = (UILabel*)[self.view viewWithTag:100];
    lightLb.text = [NSString stringWithFormat:@"亮度：%.f",slider.value];
    _lightStr =  [NSString stringWithFormat:@"%.f",slider.value];
    
    
    NSLog(@"---速度%@",_speedStr);
    [self sendTimerInstructions];

}
-(void)lightsliderTouchOutSide:(UISlider *)slider{
    NSLog(@"slider value%f",slider.value);
    UILabel * lightLb = (UILabel*)[self.view viewWithTag:100];
    lightLb.text = [NSString stringWithFormat:@"亮度：%.f",slider.value];
    _lightStr =  [NSString stringWithFormat:@"%.f",slider.value];
    NSLog(@"---速度%@",_speedStr);

    [self assemblyInstructions];
}
-(void)lightsliderTouchUpInSide:(UISlider *)slider{
    NSLog(@"slider value%f",slider.value);
    UILabel * lightLb = (UILabel*)[self.view viewWithTag:100];
    lightLb.text = [NSString stringWithFormat:@"亮度：%.f",slider.value];
    _lightStr =  [NSString stringWithFormat:@"%.f",slider.value];
    NSLog(@"---速度%@",_speedStr);

    [self assemblyInstructions];
}

-(void)speedSliderValueChanged:(UISlider *)slider
{
    UILabel * speedLb = (UILabel*)[self.view viewWithTag:101];
    speedLb.text = [NSString stringWithFormat:@"速度：%.f",slider.value];
    NSLog(@"slider value%f",slider.value);
    _speedStr =  [NSString stringWithFormat:@"%.f",slider.value];
    [self sendTimerInstructions];

}
-(void)speedsliderTouchOutSide:(UISlider *)slider{
    UILabel * speedLb = (UILabel*)[self.view viewWithTag:101];
    speedLb.text = [NSString stringWithFormat:@"速度：%.f",slider.value];
    NSLog(@"slider value%f",slider.value);
    _speedStr =  [NSString stringWithFormat:@"%.f",slider.value];
    [self assemblyInstructions];
}
-(void)speedsliderTouchUpInSide:(UISlider *)slider{
    UILabel * speedLb = (UILabel*)[self.view viewWithTag:101];
    speedLb.text = [NSString stringWithFormat:@"速度：%.f",slider.value];
    NSLog(@"slider value%f",slider.value);
    _speedStr =  [NSString stringWithFormat:@"%.f",slider.value];
    [self assemblyInstructions];
}
#pragma mark - dataSouce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSouce count] * 500;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
//    return self.dataSouce[row];
     return [self.dataSouce objectAtIndex:(row%self.dataSouce.count)];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _instruction = [_instructionArr objectAtIndex:row%self.dataSouce.count];
    [self assemblyInstructions];
}
///发送蓝牙指令
-(void)assemblyInstructions{
    
    NSString * lightNumber = [[NSUserDefaults standardUserDefaults]objectForKey:Lights_Number];
    lightNumber = [self getHexByDecimal:lightNumber.integerValue];
    NSString * instructionstr = [NSString stringWithFormat:@"ABBA02%@00%@%@%@EF",_instruction,[self getHexByDecimal:_speedStr.integerValue],[self getHexByDecimal:_lightStr.integerValue],lightNumber];
    NSLog(@"蓝牙发送指令：%@",instructionstr);
    [[BluetoothManager shareBluetoothManager]sendInstructions:instructionstr];
    
}
-(void)sendTimerInstructions{
    NSString * lightNumber = [[NSUserDefaults standardUserDefaults]objectForKey:Lights_Number];
    lightNumber = [self getHexByDecimal:lightNumber.integerValue];
    NSString * instructionstr = [NSString stringWithFormat:@"ABBA02%@00%@%@%@EF",_instruction,[self getHexByDecimal:_speedStr.integerValue],[self getHexByDecimal:_lightStr.integerValue],lightNumber];
//    NSLog(@"蓝牙发送指令：%@",instructionstr);
//    [[BluetoothManager shareBluetoothManager]sendTimerInstructions:instructionstr];
    
    
    NSDate *currentDate = [NSDate date];
    if (begainDate==nil) {
        begainDate = [NSDate date];
    }else{
        NSTimeInterval time = [currentDate timeIntervalSinceDate:begainDate];
        if ((time-0.060)>0) {
            begainDate = [NSDate date];
            NSLog(@"指令间隔----%f+++指令:%@ 速度:%@ 亮度:%@",time,instructionstr,_speedStr,_lightStr);
            [[BluetoothManager shareBluetoothManager]sendInstructions:instructionstr];
            
        }else{
//            NSLog(@"丢失指令----%f",time);
            
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view{
    
    //普通状态的颜色
    UILabel* norLabel = (UILabel*)view;
    if (!norLabel){
        norLabel = [[UILabel alloc] init];
        norLabel.textColor = [UIColor whiteColor];
        norLabel.adjustsFontSizeToFitWidth = YES;
        [norLabel setTextAlignment:NSTextAlignmentCenter];
        [norLabel setFont:[UIFont systemFontOfSize:18]];
    }
    norLabel.text = [self pickerView:pickerView
                         titleForRow:row
                        forComponent:component];
    
    //当前选中的颜色
    UILabel *selLb = (UILabel*)[pickerView viewForRow:row forComponent:0];
    if (selLb) {
        selLb.textColor = HexRGB(0xD33BFF);
        selLb.adjustsFontSizeToFitWidth = YES;
        [selLb setTextAlignment:NSTextAlignmentCenter];
        [selLb setFont:[UIFont systemFontOfSize:20]];
    }
//    //下一个选中的颜色（为了选中状态不突兀，自己注释看看效果）
//    UILabel *selLb1 = (UILabel*)[pickerView viewForRow:row + 1 forComponent:0];
//    if (selLb1) {
//        selLb1.textColor = [UIColor redColor];
//        selLb1.adjustsFontSizeToFitWidth = YES;
//        [selLb1 setTextAlignment:NSTextAlignmentCenter];
//        [selLb1 setBackgroundColor:[UIColor greenColor]];
//        [selLb1 setFont:[UIFont systemFontOfSize:16]];
//    }
//    //设置分割线
//    for (UIView *line in pickerView.subviews) {
//        if (line.frame.size.height < 1) {//0.6667
//            line.backgroundColor = [UIColor blackColor];
//            CGRect tempRect = line.frame;
//            CGFloat lineW = 120;
//            line.frame = CGRectMake((pickerView.frame.size.width - lineW) * 0.5, tempRect.origin.y, lineW, 2);
//        }
//    }
    return norLabel;
    
}
@end
