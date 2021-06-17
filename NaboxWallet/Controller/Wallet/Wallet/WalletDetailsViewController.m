//
//  WalletDetailsViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletDetailsViewController.h"
#import "WalletBackupsTableViewCell.h"
#import "WalletSetTableViewCell.h"
#import "WalletCardTableViewCell.h"
#import "BottomButtonView.h"
#import "WalletNamePopView.h"
#import "SelectSkinViewController.h"
#import "BackupsPrivateKeyViewController.h"
#import "CreateWalletTypeViewController.h"
#import "KeyStoreModel.h"
#import "CopyPrivateKeyViewController.h"
#import "AccountsAssetModel.h"
@interface WalletDetailsViewController ()
<UITableViewDelegate,
UITableViewDataSource,
BottomButtonViewDelegate,
WalletSetTableViewCellDelegate,
WalletBackupsTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BottomButtonView *bottomView;
@end

@implementation WalletDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KLocalizedString(@"wallet_edit");
    [self tableView];
    [self getAccountBalance];
}

/**
 查询钱包余额
 */
- (void)getNulsBalance
{
    WS(weakSelf);
    [[CommonHttp sharedInstance] getNulsBalanceWithAddress:self.walletModel.address isAll:NO balanceBlock:^(NulsBalanceModel * _Nullable balanceModel, NSArray * _Nullable walletArr) {
        SS(strongSelf);
        strongSelf.walletModel.totalBalance = balanceModel.totalBalance.doubleValue / pow(10, 8);
        [strongSelf.tableView reloadData];
    }];
}

//获取余额
- (void)getAccountBalance
{
    NSMutableArray *pubKeys = [NSMutableArray new];
    [pubKeys addObject:self.walletModel.publicKey];
    AccountsAssetModel *accountsAssetModel =  [AccountsAssetModel new];
    accountsAssetModel.pubKeyList = pubKeys;
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_PRICES dataModel:accountsAssetModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            if (dataObj) {
                DLog(@"当前账户余额信息:%@",dataObj);
                NSNumber *totalBalance = [dataObj objectForKey:self.walletModel.publicKey];
                SS(strongSelf);
                strongSelf.walletModel.totalBalance = [totalBalance doubleValue];
                [strongSelf.tableView reloadData];
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

/**
 type:0~钱包名称，1~钱包皮肤
 */
- (void)walletSetDidSelect:(NSInteger)type
{
    if (!type) {
        WalletNamePopView *nameView = [WalletNamePopView instanceView];
        nameView.popType = WalletPopTypeName;
        nameView.oldName = self.walletModel.alias;
        WS(weakSelf);
        nameView.nameBlock = ^(WalletNamePopView * _Nonnull nameView, NSString * _Nonnull name) {
            SS(strongSelf);
            if (!name.length) {
                [strongSelf.view showNormalToast:KLocalizedString(@"input_wallet_name")];
            }else {
                [nameView hideView];
                [strongSelf updateWalletName:name];
            }
        };
        [nameView showInController:self preferredStyle:TYAlertControllerStyleAlert];
    }else if (type == 1) {
        SelectSkinViewController *skinVC = [[SelectSkinViewController alloc] init];
        skinVC.skinType = SelectSkinTypeUpdate;
        WS(weakSelf);
        skinVC.selectBlock = ^(WalletModel *model) {
            SS(strongSelf);
            strongSelf.walletModel.colorIndex = model.colorIndex;
            [strongSelf.tableView reloadData];
        };
        skinVC.walletModel = [WalletModel mj_objectWithKeyValues:self.walletModel.mj_JSONString];
        [self.navigationController pushViewController:skinVC animated:YES];
    }
}

- (void)updateWalletName:(NSString *)name
{
    self.walletModel.alias = name;
    NSDictionary *newDict = [self.walletModel mj_keyValues];
    [UserDefaultsUtil saveNowWallet:newDict];
    [UserDefaultsUtil saveToAllWallet:newDict];
    [self.tableView reloadData];
}


/**
 type:0~备份助记词，1~备份私钥，2~备份keystore,3~删除
 */
- (void)walletBackupsDidSelect:(NSInteger)type
{
    WalletNamePopView *nameView = [WalletNamePopView instanceView];
    nameView.popType = WalletPopTypePassword;
    WS(weakSelf);
    nameView.nameBlock = ^(WalletNamePopView * _Nonnull nameView, NSString * _Nonnull name) {
        SS(strongSelf);
        [strongSelf walletBackupsWithType:type password:name popView:nameView];
    };
    [nameView showInController:self preferredStyle:TYAlertControllerStyleAlert];
}

//验证并进行事件处理
- (void)walletBackupsWithType:(NSInteger)type password:(NSString *)password popView:(WalletNamePopView *)popView
{
    if (!type) {
    }else if (type == 1) {
        NSString *privateKey = [WalletUtil decryptPrivateKey:self.walletModel.encryptPrivateKey password:password];
        if (![self.walletModel.password isEqualToString:password] || ![privateKey isHaveValue]) {
            [self.view showNormalToast:KLocalizedString(@"password_error")];
            [popView endEditing:YES];
            return;
        }
        [popView hideView];
        BackupsPrivateKeyViewController *backupsVC = [[BackupsPrivateKeyViewController alloc] init];
        backupsVC.backupsType = BackupsTypePrivateKey;
        backupsVC.privateKey = privateKey;
        [self.navigationController pushViewController:backupsVC animated:YES];
    }else if (type == 2) {
        NSString *privateKey = [WalletUtil decryptPrivateKey:self.walletModel.encryptPrivateKey password:password];
        if (![self.walletModel.password isEqualToString:password] || ![privateKey isHaveValue]) {
            [self.view showNormalToast:KLocalizedString(@"password_error")];
            [popView endEditing:YES];
            return;
        }
        [popView hideView];
        
        NSString *pubKey = [WalletUtil getPublicKeyWithPrivateKey:privateKey];
        KeyStoreModel *model = [[KeyStoreModel alloc] init];
        model.address = self.walletModel.address;
        model.alias = self.walletModel.alias;
        model.encryptedPrivateKey = self.walletModel.encryptPrivateKey;
        model.pubKey = pubKey;
        model.time = [NSDate stringWithDate:[NSDate date] format:@"yyyy-MM-dd hh:mm:ss"];
        
        CopyPrivateKeyViewController *vc = [CopyPrivateKeyViewController new];
        vc.keystoreModel = model;
        vc.isKeyStoreBackUp = YES;
        [self.navigationController pushViewController:vc animated:YES];
        

    }else if (type == 3) {
        NSString *privateKey = [WalletUtil decryptPrivateKey:self.walletModel.encryptPrivateKey password:password];
        NSString *address = [WalletUtil getAddressWithPrivateKe:privateKey];
        if (!address || ![address isEqualToString:self.walletModel.address]) {
            [self.view showNormalToast:KLocalizedString(@"password_error")];
            [popView endEditing:YES];
            return;
        }
        [popView hideView];
        WalletModel *currentWalletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
        BOOL deleteCurrentWallet = [self.walletModel.address isEqualToString:currentWalletModel.address];
        //删除
        [UserDefaultsUtil deleteWallet:self.walletModel.address];
        if ([[UserDefaultsUtil getAllWallet] count]) {
            if (deleteCurrentWallet) {
                [AppDelegateTableBar showMain];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            CreateWalletTypeViewController *creaateVC = [[CreateWalletTypeViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:creaateVC];
            KAppDelegate.window.rootViewController = nav;
        }
    }
}

//删除
- (void)bottomButtonDidSelect
{
    [self walletBackupsDidSelect:3];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        WalletCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KWalletCardTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isManageCard = YES;
        cell.hidenQRCode = YES;
        cell.walletModel = self.walletModel;
        return cell;
    }else if (indexPath.section == 1) {
        WalletSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KWalletSetTableViewCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.nameLabel.text = self.walletModel.alias;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2) {
        WalletBackupsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KWalletBackupsTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.showMnemonic = false;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        return KWalletCardTableViewCellHeight;
    }else if (indexPath.section == 1) {
        return KWalletSetTableViewCellHeight;
    }else if (indexPath.section == 2) {
        return KWalletBackupsTableViewCellHeight - 2 *KWalletBackupsTableViewItemHeight;
    }
    return FLT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return self.bottomView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!section) {
        return KLineHeight;
    }else if (section == 2) {
        return KBottomButtonViewHeight;
    }
    return 5;
}

- (BottomButtonView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [BottomButtonView instanceView];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kColorBackground;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:KWalletCardTableViewCellID bundle:nil] forCellReuseIdentifier:KWalletCardTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:KWalletSetTableViewCellID bundle:nil] forCellReuseIdentifier:KWalletSetTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:KWalletBackupsTableViewCellID bundle:nil] forCellReuseIdentifier:KWalletBackupsTableViewCellID];
        _tableView.tableFooterView = [UIView new];
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
