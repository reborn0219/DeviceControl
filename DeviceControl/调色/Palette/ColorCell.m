//
//  ColorCell.m
//  DeviceControl
//
//  Created by 刘帅 on 2019/6/19.
//  Copyright © 2019 yang. All rights reserved.
//

#import "ColorCell.h"
@interface ColorCell()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageV;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property(nonatomic,strong)ColorModel *cellModel;
@end

@implementation ColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _backView.layer.cornerRadius = 5;
}
-(void)assignmentData:(ColorModel *)model{
    [_selectImageV setHidden:!model.selected];
    [_backView setBackgroundColor:model.color];
}
@end
