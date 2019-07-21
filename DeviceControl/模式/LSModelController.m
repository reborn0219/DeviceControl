//
//  LSModelController.m
//  DeviceControl
//
//  Created by yang on 2019/6/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSModelController.h"

@interface LSModelController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *dataSouce;
@property(nonatomic,strong)UISlider *lightSlider;
@property(nonatomic,strong)UISlider *speedSlider;
@property(nonatomic,strong)NSMutableArray *instructionArr;

@end

@implementation LSModelController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataSouce addObjectsFromArray:@[@"红色渐变",
                                          @"绿色渐变",
                                          @"蓝色渐变",
                                          @"黄色渐变",
                                          @"青色渐变",
                                          @"紫色渐变",
                                          @"白色渐变",
                                          @"红绿渐变",
                                          @"红蓝渐变",
                                          @"绿蓝渐变",
                                          @"七色渐变",
                                          @"红绿频闪",
                                          @"红蓝频闪",
                                          @"绿蓝频闪",
                                          @"黄青频闪",
                                          @"绿紫频闪",
                                          @"三色频闪",
                                          @"七色频闪",
                                          @"静态红色",
                                          @"静态绿色",
                                          @"静态蓝色",
                                          @"静态青色",
                                          @"静态黄色",
                                          @"静态紫色",
                                          @"静态白色",
                                          @"流星炫彩A",
                                          @"流星炫彩B",
                                          @"流星炫彩C",
                                          ]];
    [self.instructionArr addObjectsFromArray:@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"0A",@"0B",@"0C",@"0D",@"0E",@"0F",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"1A",@"1B",@"1C"]];
    
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.lightSlider];
    [self.view addSubview:self.speedSlider];
    [self.pickerView selectRow:(self.dataSouce.count/2) inComponent:0 animated:NO];
}

#pragma mark - lazy loading
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
        _lightSlider = [[UISlider alloc]initWithFrame:CGRectMake(45, SCREEN_HEIGHT-160,SCREEN_WIDTH-90,20)];
        [_lightSlider setThumbTintColor:Selected_Color];
        [_lightSlider setTintColor:Selected_Color];
        _lightSlider.minimumValue = 0;
        _lightSlider.maximumValue =100;
        [_lightSlider addTarget:self action:@selector(lightSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        UILabel * lightLb = [[UILabel alloc]initWithFrame:CGRectMake(45,_lightSlider.frame.origin.y-40,200,20)];
        lightLb.text = @"亮度：0";
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
        _speedSlider = [[UISlider alloc]initWithFrame:CGRectMake(45, SCREEN_HEIGHT-250,SCREEN_WIDTH-90,20)];
        _speedSlider.minimumValue = 0;
        _speedSlider.maximumValue =100;
        [_speedSlider setThumbTintColor:Selected_Color];
        [_speedSlider setTintColor:Selected_Color];
        [_speedSlider addTarget:self action:@selector(speedSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

        UILabel * speedLb = [[UILabel alloc]initWithFrame:CGRectMake(45,_speedSlider.frame.origin.y-40,200,20)];
        speedLb.tag = 101;
        speedLb.text = @"速度：0";
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

}
-(void)speedSliderValueChanged:(UISlider *)slider
{
    UILabel * speedLb = (UILabel*)[self.view viewWithTag:101];
    speedLb.text = [NSString stringWithFormat:@"速度：%.f",slider.value];
    NSLog(@"slider value%f",slider.value);
}

#pragma mark - dataSouce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSouce count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    return self.dataSouce[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
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
//
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
