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

@end

@implementation LSModelController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.dataSouce addObjectsFromArray:@[@"青色闪频",@"青色闪频",@"青色闪频",@"静态红色",@"静态蓝色",@"青色闪频",@"青色闪频"]];
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.lightSlider];
    [self.view addSubview:self.speedSlider];
    [self.pickerView selectRow:(self.dataSouce.count/2) inComponent:0 animated:NO];
}

#pragma mark - lazy loading
-(NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT/2.0f, SCREEN_WIDTH,1)];
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
        UILabel * lightLb = [[UILabel alloc]initWithFrame:CGRectMake(45,_lightSlider.frame.origin.y-40,200,20)];
        lightLb.text = @"亮度：0";
        lightLb.textColor = [UIColor whiteColor];
        [self.view addSubview:lightLb];
        ////        UIImage *imagea=[self OriginImage:[UIImage imageNamed:@"Icon-60"] scaleToSize:CGSizeMake(12, 12)];
        //        [_lightSlider  setThumbImage:[UIImage imageNamed:@"调色板-点击"] forState:UIControlStateNormal];
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
        [_speedSlider setThumbTintColor:Selected_Color];
        [_speedSlider setTintColor:Selected_Color];
        UILabel * speedLb = [[UILabel alloc]initWithFrame:CGRectMake(45,_speedSlider.frame.origin.y-40,200,20)];
        speedLb.text = @"速度：0";
        speedLb.textColor = [UIColor whiteColor];
        [self.view addSubview:speedLb];

        ////        UIImage *imagea=[self OriginImage:[UIImage imageNamed:@"Icon-60"] scaleToSize:CGSizeMake(12, 12)];
        //        [_lightSlider  setThumbImage:[UIImage imageNamed:@"调色板-点击"] forState:UIControlStateNormal];
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
