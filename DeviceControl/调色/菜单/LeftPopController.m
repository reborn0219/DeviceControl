//
//  LeftPopController.m
//  DeviceControl
//
//  Created by yang on 2019/7/8.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LeftPopController.h"

@interface LeftPopController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_top;

@end

@implementation LeftPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    _backView_top.constant = k_Height_StatusBar;
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _blueArr = @[@"wodeeeee",@"e999999"];
    [_leftTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (IBAction)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.leftTable reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


-(void)showInVC:(UIViewController *)VC {
    
    if (self.isBeingPresented) {
        return;
    }
    self.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    /**
     *  根据系统版本设置显示样式
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle=UIModalPresentationOverFullScreen;
    }else {
        self.modalPresentationStyle=UIModalPresentationCustom;
    }
    [VC presentViewController:self animated:YES completion:nil];
}
#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, 49,170, 1)];
    [sectionView addSubview:lineV];
    [lineV setBackgroundColor:HexRGB(0x839694)];
    UIButton * ligimgV = [[UIButton alloc]initWithFrame:CGRectMake(10, 10,20, 20)];
    [ligimgV setImage:[UIImage imageNamed:@"灯1"] forState:UIControlStateNormal];
    [sectionView addSubview:ligimgV];
    UILabel * liglabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 80, 40)];
    liglabel.text = @"我的设备";
    liglabel.textColor = [UIColor whiteColor];
    
    [sectionView addSubview:liglabel];
    
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _blueArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.imageView setImage:[UIImage imageNamed:@"灯2"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor  =[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_blueArr objectAtIndex:indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end
