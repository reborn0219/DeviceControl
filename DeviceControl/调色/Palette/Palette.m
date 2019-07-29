//
//  Palette.m
//  ChoicesColor
//
//  Created by 冷求慧 on 17/6/13.
//  Copyright © 2017年 冷求慧. All rights reserved.
//

#import "Palette.h"

#import "HSVWithNew.h"

@interface Palette (){
    
    HSVType currentHSVWithNew;
    CGPoint beganPoint;
    CGPoint movePoint;
    CGPoint endedPoint;
    UIColor * currentColor;
    NSInteger changetype;
    UIImageView * backImgV;
}

@property (nonatomic,strong)UIImageView *mainImageView;

@property (nonatomic,strong)UIView *centerView;

@property (nonatomic,strong)UIImageView *sliderImageView;

@end

@implementation Palette
#pragma mark xib关联
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSomeUI];
}
#pragma mark 初始化
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSomeUI];
    }
    return self;
}
-(void)setSliderCenter:(CGPoint)sliderCenter{
    _sliderCenter=sliderCenter;
    self.sliderImageView.center=sliderCenter;
    
}
#pragma mark 添加UI
-(void)addSomeUI{
    backImgV = [[UIImageView alloc]initWithFrame:CGRectMake(-5,-5,self.frame.size.width+10,self.frame.size.height+10)];
    [backImgV setImage:[UIImage imageNamed:@"paletteColor"]];
    [backImgV setHidden:YES];
    changetype = 1;
    currentColor = HexRGB(0x62c16f);
    self.mainImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
    self.mainImageView.image=[UIImage imageNamed:@"paletteColor"];
//    backImgV.transform = transform;
    [self addSubview:self.mainImageView];
    [self addSubview:backImgV];
    self.sliderImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self.sliderImageView setFrame:CGRectMake(0, 0,20, 20)];
    self.sliderImageView.layer.cornerRadius =10;
    self.sliderImageView.clipsToBounds = YES;
    [self.sliderImageView setBackgroundColor:Selected_Color];
    [self addSubview:self.sliderImageView];
    self.sliderImageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-20);
}
-(void)changeStatus:(NSInteger)type{
    changetype = type;
    if (type==1) {
        self.mainImageView.image=[UIImage imageNamed:@"paletteColor"];
        backImgV.image=[UIImage imageNamed:@"paletteColor"];
        CGAffineTransform transform= CGAffineTransformMakeRotation(-M_PI*0.2);
        self.mainImageView.transform = transform;
        
    }else if (type==2){
        self.mainImageView.image=[UIImage imageNamed:@"黄色"];
        backImgV.image=[UIImage imageNamed:@"黄色"];
        CGAffineTransform transform= CGAffineTransformMakeRotation(0);
        self.mainImageView.transform = transform;
    }else if (type==3)
    {
        self.mainImageView.image=[UIImage imageNamed:@"大黑白"];
        backImgV.image=[UIImage imageNamed:@"大黑白"];
        CGAffineTransform transform= CGAffineTransformMakeRotation(0);
        self.mainImageView.transform = transform;
    }
}
#pragma mark 开始触摸或者点击
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self calculateShowColor:touches :NO];

}
#pragma mark 滑动触摸
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self calculateShowColor:touches :YES];
}
#pragma mark 结束触摸
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self calculateShowColor:touches :NO];
}

//获取图片某一点的颜色
- (UIColor *)colorAtPixel:(CGPoint)point {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f,backImgV.size.width,backImgV.size.height), point)) {
        return currentColor;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = backImgV.image.CGImage;
    NSUInteger width = backImgV.image.size.width;
    NSUInteger height = backImgV.image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    currentColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
//
//    if (red<5&&green<5&&blue<5) {
//        self.sliderImageView.center = beganPoint;
//        return currentColor;
//    }else{
//        currentColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
//        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
//    }
}
#pragma mark 计算和传递选择的颜色
-(void)calculateShowColor:(NSSet<UITouch *> *)touches :(BOOL)ismove{
    UITouch *touchObj=touches.anyObject;
    CGPoint movePoint=[touchObj locationInView:self];                       // 得到滑动的点
    
//    [self calculateCenterPointInView:movePoint];
//    UIColor *color = [self colorAtPixel:movePoint];
    UIColor *color;
    if (changetype==1) {
      color = [self calculateCenterPointInView:movePoint];

    }else{
        [self calculateCenterPointInView:movePoint];
        color = [self colorAtPixel:_sliderImageView.center];
    }
    if (ismove) {
        if([self.delegate respondsToSelector:@selector(patette:choiceColor:)]){
            [self.delegate patette:self choiceColor:color];
        }
    }else{
        if([self.delegate respondsToSelector:@selector(patette:choiceColor:colorPoint:)]){
            [self.delegate patette:self choiceColor:color colorPoint:self.sliderImageView.center]; // 通过代理传递颜色
        }
    }
   
}

#pragma mark 计算中心点位置和获取颜色
-(UIColor *)calculateCenterPointInView:(CGPoint)point{
    
    CGPoint center=CGPointMake(self.frame.size.width/2,self.frame.size.height/2);  // 中心点
    double radius=self.frame.size.width/2;          // 半径
    double dx=ABS(point.x-center.x);    //  ABS函数: int类型 取绝对值
    double dy=ABS(point.y-center.y);   //   atan pow sqrt也是对应的数学函数
    double angle=atan(dy/dx);
    if (isnan(angle)) angle=0.0;
    double dist=sqrt(pow(dx,2)+pow(dy,2));
    double saturation=MIN(dist/radius,1.0);
    if (dist<10) saturation=0;
    if (point.x<center.x) angle=M_PI-angle;
    if (point.y>center.y) angle=2.0*M_PI-angle;
    HSVType currentHSV=HSVTypeMake(angle/(2.0*M_PI), saturation, 1.0);
    [self centerPointValue:currentHSV];    // 计算中心点位置
    UIColor *color = [UIColor colorWithHue:currentHSV.h saturation:currentHSV.s brightness:1.0 alpha:1.0];  // 得到对应的颜色
    return color;
}
#pragma mark 真正显示颜色的中心点
-(void)centerPointValue:(HSVType)currentHSV{
    
    currentHSVWithNew=currentHSV;
    currentHSVWithNew.v=1.0;
    double angle=currentHSVWithNew.h*2.0*M_PI;
    CGPoint center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    double radius=self.frame.size.width/2-self.sliderImageView.frame.size.width/2;
    radius *=currentHSVWithNew.s;
    
    CGFloat x=center.x+cosf(angle)*radius;
    CGFloat y=center.y-sinf(angle)*radius;
    
    x=roundf(x-self.sliderImageView.frame.size.width/2)+self.sliderImageView.frame.size.width/2;
    y=roundf(y-self.sliderImageView.frame.size.height/2)+self.sliderImageView.frame.size.height/2;
    
    self.sliderImageView.center=CGPointMake(x,y);    // 滑动图片的中心点位置
}
@end

