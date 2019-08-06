//
//  LeftPopController.m
//  DeviceControl
//
//  Created by yang on 2019/7/8.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LeftPopController.h"
#import "BluetoothManager.h"
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
    [_leftTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJWeakSelf
    [[BluetoothManager shareBluetoothManager] startScanPeripherals];
    [BluetoothManager shareBluetoothManager].blueToothBlock = ^(id  _Nullable data, BluetoothCode bluetoothCode) {
        if (bluetoothCode == SearchBluetooth) {
            weakSelf.blueArr = data;
            [weakSelf.leftTable reloadData];
        }
    };
    
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:NO completion:nil];
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
//    liglabel.text = @"我的设备";
    liglabel.text = NSLocalizedString(@"我的设备", nil);
    liglabel.textColor = [UIColor whiteColor];
    UIButton * refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(140,4,40,40)];
    [refreshBtn setImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:refreshBtn];

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
    BluetoothModel *model = [_blueArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [tableView visibleCells];
    
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.textColor=[UIColor blackColor];
    }
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor=[UIColor blueColor];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    BluetoothModel *model = [_blueArr objectAtIndex:indexPath.row];
    [[BluetoothManager shareBluetoothManager]linkBluetooth:model];
    
}
-(void)refreshAction{
    _blueArr = @[];
    [self.leftTable reloadData];
    [[BluetoothManager shareBluetoothManager] startScanPeripherals];
}
@end
