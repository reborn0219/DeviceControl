//
//  NaviBarView.m
//  OneBAuction
//
//  Created by 刘帅 on 2019/4/7.
//  Copyright © 2019 刘帅. All rights reserved.
//

#import "NaviBarView.h"

@implementation NaviBarView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.subtitleLb setHidden:YES];
}

- (IBAction)searchAction:(id)sender {
    if (_block) {
        _block(1);
    }
}
- (IBAction)backAction:(id)sender {
    if (_block) {
        _block(2);
    }
}

@end
