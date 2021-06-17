//
//  WalletManageViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletManageViewController.h"
#import "WalletCardTableViewCell.h"
#import "CreateWalletTypeViewController.h"
#import "WalletDetailsViewController.h"
#import "ReceivablesViewController.h"
#import "AccountsAssetModel.h"
@interface WalletManageViewController ()<UITableViewDelegate,UITableViewDataSource,WalletCardTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *walletArr;
@end

@implementation WalletManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KLocalizedString(@"wallet_manage");
    self.navigationItem.rightBarButtonItem = [self getBarButtonItemWithImage:ImageNamed(@"icon_add") action:@selector(addWalletScanAction:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.walletArr = [WalletModel mj_objectArrayWithKeyValuesArray:[UserDefaultsUtil getAllWallet]];
    [self getAccountBalance];
    [self.tableView reloadData];
}

//获取余额
- (void)getAccountBalance
{
    NSMutableArray *pubKeys = [NSMutableArray new];
    for (WalletModel *model in self.walletArr) {
        [pubKeys addObject:model.publicKey];
    }
    AccountsAssetModel *accountsAssetModel =  [AccountsAssetModel new];
    accountsAssetModel.pubKeyList = pubKeys;
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_PRICES dataModel:accountsAssetModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            if (dataObj) {
                DLog(@"所有账户余额信息:%@",dataObj);
                for (WalletModel *model in self.walletArr) {
                    NSNumber *totalBalance = [dataObj objectForKey:model.publicKey];
                    model.totalBalance = [totalBalance doubleValue];
                }
                [strongSelf.tableView reloadData];
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

/**
 tag:0~复制地址，1~收款二维码
 index:下标
 */
- (void)walletCardDidSelect:(NSInteger)tag index:(NSInteger)index
{
    if (tag) {
        WalletModel *walletModel = self.walletArr[index];
        ReceivablesViewController *receivablesVC = [[ReceivablesViewController alloc] init];
        [receivablesVC setHidesBottomBarWhenPushed:YES];
        receivablesVC.addressStr = walletModel.address;
        [self.navigationController pushViewController:receivablesVC animated:YES];
    }
}

- (void)addWalletScanAction:(UIBarButtonItem *)sender
{
    CreateWalletTypeViewController *createVC = [[CreateWalletTypeViewController alloc] init];
    
    [self.navigationController pushViewController:createVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.walletArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KWalletCardTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = KColorWhite;
    cell.delegate = self;
    cell.isManageCard = YES;
    cell.walletModel = self.walletArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KWalletCardTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletDetailsViewController *detailsVC = [[WalletDetailsViewController alloc] init];
    detailsVC.walletModel = self.walletArr[indexPath.row];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return iPhoneX ? KSafeAreaHeight : KLineHeight;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = KColorWhite;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:KWalletCardTableViewCellID bundle:nil] forCellReuseIdentifier:KWalletCardTableViewCellID];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 10)];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
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
