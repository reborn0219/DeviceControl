//
//  LSPaletteController.m
//  DeviceControl
//
//  Created by yang on 2019/6/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSPaletteController.h"
#import "Palette.h"
#define  palette_R (SCREEN_WIDTH-140)/2.0f
#define  slider_bottom (IS_PhoneXAll?320:210)
@interface LSPaletteController ()
@property (nonatomic,strong) Palette *paletteView;
@property (nonatomic,strong) UIImageView *backImgV;
@property (nonatomic,strong) UIImageView *leftImgV;
@property (nonatomic,strong) UISwitch *rightSwitch;
@property (nonatomic,strong) UISlider *lightSlider;
@property (nonatomic,strong) UIView *rgbView;

@end

@implementation LSPaletteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backImgV];
    [self.view addSubview:self.leftImgV];
    [self.view addSubview:self.rightSwitch];
    [self.view addSubview:self.paletteView];
    [self.view addSubview:self.lightSlider];
    [self.view addSubview:self.rgbView];
}

#pragma mark - lazy loading
-(UIView *)rgbView{
    if (!_rgbView) {
        _rgbView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-palette_R*2)/2.0f-50, 70+NavBar_H+palette_R*2-60, 60,90)];
        for (int i =0; i<3; i++) {
            UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0+i*30, 20,25)];
            lb.textColor = [UIColor whiteColor];
            lb.text = @"R";
            if (i==1) {
                lb.text = @"G";
            }else if(i == 2){
                lb.text = @"B";
            }
            lb.font = [UIFont systemFontOfSize:18];
            
            UILabel * numberLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0+i*30,35,25)];
            numberLb.tag = i+100;
            numberLb.textAlignment = NSTextAlignmentCenter;
            numberLb.backgroundColor = [UIColor blackColor];
            numberLb.font = [UIFont systemFontOfSize:16];
            numberLb.textColor = [UIColor whiteColor];
            numberLb.text = @"255";
            [_rgbView addSubview:lb];
            [_rgbView addSubview:numberLb];

        }
    }
    return _rgbView;
}
-(UISlider *)lightSlider{
    if (!_lightSlider) {
        _lightSlider = [[UISlider alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-palette_R*2)/2.0f, SCREEN_HEIGHT-slider_bottom, palette_R*2, 2)];
        [_lightSlider setThumbTintColor:Selected_Color];
        [_lightSlider setTintColor:Selected_Color];
        UIImageView * leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-palette_R*2)/2.0f-30,_lightSlider.frame.origin.y-10, 20, 20)];
        [leftImgV setImage:[UIImage imageNamed:@"亮度-"]];
        [self.view addSubview:leftImgV];
        
        UIImageView * rightImgV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-palette_R*2)/2.0f+10+palette_R*2,_lightSlider.frame.origin.y-10, 20, 20)];
        [rightImgV setImage:[UIImage imageNamed:@"亮度+"]];
        [self.view addSubview:leftImgV];
        [self.view addSubview:rightImgV];

    }
   return  _lightSlider;
}
-(Palette *)paletteView{
    if (!_paletteView) {
        _paletteView = [[Palette alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-palette_R*2)/2.0f, 50+NavBar_H,palette_R*2, palette_R*2)];
    }
    return _paletteView;
}
-(UIImageView *)leftImgV{
    if (!_leftImgV) {
        _leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15,NavBar_H+20,44,44)];
        [_leftImgV setImage:[UIImage imageNamed:@"小色彩盘"]];
    }
    return _leftImgV;
}
-(UIImageView *)backImgV{
    if (!_backImgV) {
         _backImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavBar_H+6, SCREEN_WIDTH, SCREEN_HEIGHT-NavBar_H)];
        [_backImgV setImage:[UIImage imageNamed:@"背景"]];

    }
    return _backImgV;
}
-(UISwitch *)rightSwitch{
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-65,NavBar_H+6+20,50,50)];
        [_rightSwitch setOn:YES];
    }
    return _rightSwitch;
}
@end
