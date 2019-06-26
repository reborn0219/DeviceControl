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
@interface LSPaletteController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) Palette *paletteView;
@property (nonatomic,strong) UIImageView *backImgV;
@property (nonatomic,strong) UIImageView *leftImgV;
@property (nonatomic,strong) UISwitch *rightSwitch;
@property (nonatomic,strong) UISlider *lightSlider;
@property (nonatomic,strong) UIView *rgbView;
@property (nonatomic,strong) UIView *bottomColorView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) BluetoothManager * blueManager;
@property (nonatomic,assign) CBManagerState CBmanagerState;
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
    [self.view addSubview:self.bottomColorView];
    self.blueManager = [[BluetoothManager alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.blueManager startScanPeripherals];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_blueManager!=nil) {
        [_blueManager discconnection];
    }
}
-(void)changeColor{
    
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
        _lightSlider = [[UISlider alloc]initWithFrame:CGRectMake(45, SCREEN_HEIGHT-slider_bottom-20,SCREEN_WIDTH-90, 2)];
        [_lightSlider setThumbTintColor:Selected_Color];
        [_lightSlider setTintColor:Selected_Color];
        UIImageView * leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15,_lightSlider.frame.origin.y-10, 20, 20)];
        [leftImgV setImage:[UIImage imageNamed:@"亮度-"]];
        [self.view addSubview:leftImgV];
        UIImageView * rightImgV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35,_lightSlider.frame.origin.y-10, 20, 20)];
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(50,bottom_color_view_h-120,SCREEN_WIDTH-90,120) collectionViewLayout: flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ColorCell class]) bundle:nil] forCellWithReuseIdentifier:@"ColorCell"];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(50, bottom_color_view_h-64.5, SCREEN_WIDTH-90, 1)];
        [lineV setBackgroundColor:HexRGB(0x939393)];
        [self.bottomColorView addSubview:lineV];
    }
    return _collectionView;
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
    return CGSizeMake(50,50);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
}
@end
