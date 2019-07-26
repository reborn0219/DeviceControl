//
//  LSPaletteController.m
//  DeviceControl
//
//  Created by yang on 2019/6/12.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LSPaletteController.h"
#import "Palette.h"
#import "ColorCell.h"
#import "BluetoothManager.h"


#define  palette_R (SCREEN_WIDTH-140)/2.0f
#define  bottom_color_view_h (IS_PhoneXAll?200:120)
#define  slider_bottom (bottom_color_view_h+k_Height_TabBar+15)
@interface LSPaletteController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PaletteDelegate>
@property (nonatomic,strong) Palette *paletteView;
@property (nonatomic,strong) UIImageView *backImgV;
@property (nonatomic,strong) UIImageView *leftImgV;
@property (nonatomic,strong) UISwitch *rightSwitch;
@property (nonatomic,strong) UISlider *lightSlider;
@property (nonatomic,strong) UIView *rgbView;
@property (nonatomic,strong) UIView *bottomColorView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) CBManagerState CBmanagerState;
@property (nonatomic,strong) NSMutableArray *colorArr;
@property (nonatomic,strong) BluetoothManager *blueManager;
@property (nonatomic,strong) UIView *centerView;
@property (nonatomic,strong) UIView *paletteBackView;
@property (nonatomic,strong) NSIndexPath *seletedIndex;
@property (nonatomic,strong) UIColor *currentColor;
@property (nonatomic,copy) NSString *brightness;


@end

@implementation LSPaletteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backImgV];
    [self.view addSubview:self.leftImgV];
    [self.view addSubview:self.rightSwitch];
    [self.view addSubview:self.paletteBackView];
    [self.view addSubview:self.paletteView];
    [self.view addSubview:self.lightSlider];
    [self.view addSubview:self.rgbView];
    [self.view addSubview:self.bottomColorView];
    [self.view addSubview:self.centerView];
    _seletedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    self.blueManager = [BluetoothManager shareBluetoothManager];
    [self creatData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.blueManager startScanPeripherals];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_blueManager!=nil) {
        [_blueManager discconnection];
    }
}
-(void)creatData{
    
    NSArray *defaultArr = @[
                            HexRGB(0x62c16f),
                            HexRGB(0xee00f5),
                            HexRGB(0x54a8f1),
                            HexRGB(0x7848fd),
                            HexRGB(0xffff00),
                            HexRGB(0x999999),
                            HexRGB(0xffff00),
                            HexRGB(0xffffff),
                            HexRGB(0x00ffff),
                            HexRGB(0xff0000),
                            HexRGB(0x00ff00),
                            HexRGB(0x0000ff),
                            //                            HexRGB(0xA449F6),
                            //                            HexRGB(0xE14E73),
                            //                            HexRGB(0x75FBCF),
                            //                            HexRGB(0xF7D252),
                            //                            HexRGB(0xE832E1),
                            //                            HexRGB(0xB7E9B0),
                            ];
    _currentColor = HexRGB(0x62c16f);
    _brightness = @"00";
    for (UIColor *color in defaultArr) {
        ColorModel * model = [[ColorModel alloc]init];
        model.color = color;
        model.selected = NO;
        [self.colorArr addObject:model];
    }
    ColorModel * model = self.colorArr.firstObject;
    model.selected = YES;
}
-(void)patette:(Palette *)patette choiceColor:(UIColor *)color colorPoint:(CGPoint)colorPoint{
    [self setColorLabelCount:color];
    [self assemblyInstructions];
  
}
-(void)patette:(Palette *)patette choiceColor:(UIColor *)color{
    [self setColorLabelCount:color];
    static NSInteger i = 0;
    if (i%Time_Interval.integerValue==0) {
        [self assemblyInstructions];
    }
    i++;
    if (i>1000) {
        i=0;
    }
}
-(void)setColorLabelCount:(UIColor *)color{
    if(!color){return;}
    _currentColor = color;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSLog(@"Red: %.f", components[0]*255);
    NSLog(@"Green: %.f", components[1]*255);
    NSLog(@"Blue: %.f", components[2]*255);
    UILabel * tempLab = [_rgbView viewWithTag:100];
    tempLab.text = [NSString stringWithFormat:@"%.f", components[0]*255];
    UILabel * tempLab1 = [_rgbView viewWithTag:101];
    tempLab1.text = [NSString stringWithFormat:@"%.f", components[1]*255];
    UILabel * tempLab2 = [_rgbView viewWithTag:102];
    tempLab2.text = [NSString stringWithFormat:@"%.f", components[2]*255];
    [self.centerView setBackgroundColor:color];
    self.centerView.layer.shadowColor = color.CGColor;
    self.centerView.layer.shadowOffset = CGSizeMake(1,1);
    self.centerView.layer.shadowOpacity = 1;
    self.centerView.layer.shadowRadius = 15;
    if(_seletedIndex.row==0||_seletedIndex.row==1||_seletedIndex.row==2||_seletedIndex.row==3) {
        ColorModel *model  =   [_colorArr objectAtIndex:_seletedIndex.row];
        model.color = color;
        
        [_collectionView reloadData];
        
    }
    
    [self.paletteBackView setBackgroundColor:color];
}

#pragma mark - lazy loading
-(UIView *)paletteBackView{
    if(!_paletteBackView){
        _paletteBackView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-palette_R*2)/2.0f-2, 50+NavBar_H-2,palette_R*2+4, palette_R*2+4)];
        _paletteBackView.backgroundColor =  HexRGB(0x62c16f);
        _paletteBackView.layer.cornerRadius = (palette_R*2+4)/2;
        UIView * centerV = [[UIView alloc]initWithFrame:CGRectMake(2,2, palette_R*2, palette_R*2)];
        centerV.layer.cornerRadius = palette_R;
        centerV.backgroundColor = [UIColor blackColor];
        [_paletteBackView addSubview:centerV];
    }
    return _paletteBackView;
}
-(NSMutableArray *)colorArr{
    if (!_colorArr) {
        _colorArr = [NSMutableArray array];
    }
    return _colorArr;
}
-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc]initWithFrame:CGRectMake(_paletteView.centerX-30, _paletteView.centerY-30, 60, 60)];
        _centerView.backgroundColor =  HexRGB(0x62c16f);
        _centerView.layer.cornerRadius = 30;
        
    }
    return _centerView;
}
-(UIView *)rgbView{
    if (!_rgbView) {
        _rgbView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-palette_R*2)/2.0f-50, 70+NavBar_H+palette_R*2-60, 60,90)];
        for (int i =0; i<3; i++) {
            UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0+i*30,14,25)];
            lb.textColor = [UIColor whiteColor];
            lb.text = @"R";
            lb.textAlignment = NSTextAlignmentCenter;
            //            lb.backgroundColor = [UIColor redColor];
            if (i==1) {
                lb.text = @"G";
                //                lb.backgroundColor = [UIColor greenColor];
                
            }else if(i == 2){
                lb.text = @"B";
                //                lb.backgroundColor = [UIColor blueColor];
                
            }
            lb.font = [UIFont systemFontOfSize:18];
            UILabel * numberLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0+i*30,35,25)];
            numberLb.tag = i+100;
            numberLb.textAlignment = NSTextAlignmentLeft;
            numberLb.backgroundColor = [UIColor redColor];
            
            if (i==1) {
                numberLb.backgroundColor = [UIColor greenColor];
                
            }else if(i == 2){
                numberLb.backgroundColor = [UIColor blueColor];
                
            }
            numberLb.backgroundColor = HexRGB(0x2B324E);
            
            
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
        _lightSlider = [[UISlider alloc]initWithFrame:CGRectMake(45, SCREEN_HEIGHT-slider_bottom-30,SCREEN_WIDTH-90,20)];
        [_lightSlider setThumbTintColor:Selected_Color];
        [_lightSlider setTintColor:Selected_Color];
        [_lightSlider addTarget:self action:@selector(lightSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _lightSlider.minimumValue = 0;
        _lightSlider.maximumValue =100;
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
-(Palette *)paletteView{
    if (!_paletteView) {
        _paletteView = [[Palette alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-palette_R*2)/2.0f, 50+NavBar_H,palette_R*2, palette_R*2)];
        _paletteView.delegate = self;
        [_paletteView changeStatus:1];
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
-(UIView *)bottomColorView{
    if (!_bottomColorView) {
        _bottomColorView = [[UIView alloc]initWithFrame:CGRectMake(20,SCREEN_HEIGHT-k_Height_TabBar-15-bottom_color_view_h,
                                                                   SCREEN_WIDTH-40,bottom_color_view_h)];
        [_bottomColorView addSubview:self.collectionView];
        UILabel *topLb = [[UILabel alloc]initWithFrame:CGRectMake(0,bottom_color_view_h-120,50,60)];
        topLb.text = @"常用";
        topLb.font = [UIFont systemFontOfSize:20];
        topLb.textColor = [UIColor whiteColor];
        [_bottomColorView addSubview:topLb];
        UILabel *bottomLb = [[UILabel alloc]initWithFrame:CGRectMake(0,bottom_color_view_h-60,50,60)];
        bottomLb.text = @"经典";
        bottomLb.font = [UIFont systemFontOfSize:20];
        bottomLb.textColor = [UIColor whiteColor];
        [_bottomColorView addSubview:bottomLb];
    }
    return _bottomColorView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(50,bottom_color_view_h-115,SCREEN_WIDTH-90,120) collectionViewLayout: flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ColorCell class]) bundle:nil] forCellWithReuseIdentifier:@"ColorCell"];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, (SCREEN_WIDTH-90)/6.0f+5, SCREEN_WIDTH-90, 1)];
        [lineV setBackgroundColor:HexRGB(0x939393)];
        [_collectionView addSubview:lineV];
    }
    return _collectionView;
}
-(void)lightSliderValueChanged:(UISlider *)slider
{
    NSLog(@"slider value%f",slider.value);
    _brightness = [NSString stringWithFormat:@"%.f",slider.value];
    static NSInteger i=0;
    if (i%Time_Interval.integerValue==0) {
        [self assemblyInstructions];
    }
    i++;
    if (i>1000) {
        i=0;
    }
}
#pragma mark - UICollectionViewDataSource
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-90)/6.0f-5,(SCREEN_WIDTH-90)/6.0f-5);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.colorArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ColorModel * model = [_colorArr objectAtIndex:indexPath.item];
    ColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
    [cell assignmentData:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _seletedIndex = indexPath;
    for (ColorModel *model in _colorArr) {
        model.selected = NO;
    }
    ColorModel * cellModel = [_colorArr objectAtIndex:indexPath.item];
    _currentColor = cellModel.color;
    cellModel.selected = YES;
    [collectionView reloadData];
    if (indexPath.row==4) {
        [_paletteView changeStatus:2];
        [_centerView setHidden:YES];
        [_leftImgV setImage:[UIImage imageNamed:@"黄色"]];
        
    }else if(indexPath.row==5) {
        [_paletteView changeStatus:3];
        [_centerView setHidden:YES];
        [_leftImgV setImage:[UIImage imageNamed:@"小黑白"]];
        
    }else{
        [_paletteView changeStatus:1];
        [_leftImgV setImage:[UIImage imageNamed:@"小色彩盘"]];
        [self setColorLabelCount:cellModel.color];
        
        [_centerView setHidden:NO];
    }
    [self assemblyInstructions];

}
///发送蓝牙指令
-(void)assemblyInstructions{
   
    if (!_currentColor) {
        NSLog(@"%@",_currentColor);
        return;
    }else{
        NSLog(@"啥也不是");

    }
    NSString * rgbStr = _currentColor.hexString.uppercaseString;
    NSString * lightNumber = [[NSUserDefaults standardUserDefaults]objectForKey:Lights_Number];
    lightNumber = [self getHexByDecimal:lightNumber.integerValue];
    NSString * brightness = [self getHexByDecimal:_brightness.integerValue];
    NSString * instructionstr = [NSString stringWithFormat:@"ABBA01%@%@%@EF",rgbStr,brightness,lightNumber];
    NSLog(@"蓝牙发送指令：%@",instructionstr);
    [[BluetoothManager shareBluetoothManager]sendInstructions:instructionstr];
    
}

@end
