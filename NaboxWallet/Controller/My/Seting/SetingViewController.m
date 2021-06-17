//
//  SetingViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "SetingViewController.h"
#import "SettingCell.h"
#import "SetingChooseViewController.h"
#import "ManageLockViewController.h"
@interface SetingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = KLocalizedString(@"setting");
    self.tableView.backgroundColor = [UIColor whiteColor];
     [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingCell forIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.leftLabel.text = KLocalizedString(@"language_settings");
        cell.rightLabel.text = [[LanguageUtil userLanguage] isEqualToString:@"en"]?@"English":@"简体中文";
    }else if (indexPath.row == 1){
        cell.leftLabel.text = KLocalizedString(@"common_currency_unit");
        cell.rightLabel.text = [[UserDefaultsUtil getValueWithKey:KEY_CURRENCY] isEqualToString:@"USD"] ? KLocalizedString(@"usd") : KLocalizedString(@"cny");
    }else{
        cell.leftLabel.text = KLocalizedString(@"safety_protection");
        cell.rightLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        SetingChooseViewController *vc = [SetingChooseViewController new];
        vc.type = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        SetingChooseViewController *vc = [SetingChooseViewController new];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        ManageLockViewController* vc = [ManageLockViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//        
//}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kSettingHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        [_tableView registerNib:[UINib nibWithNibName:kSettingCell bundle:nil] forCellReuseIdentifier:kSettingCell];
        
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
