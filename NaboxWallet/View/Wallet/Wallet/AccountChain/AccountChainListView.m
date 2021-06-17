//
//  AccountChainListView.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/5.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AccountChainListView.h"
#import "AccountChainListViewAccountCell.h"
#import "AccountChainListViewChainCell.h"
#import "AccountsAssetModel.h"
#import "WalletPriceModel.h"
#import "WalletChainModel.h"
@interface AccountChainListView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UITableView *accountTableView;
@property (strong, nonatomic) IBOutlet UILabel *chooseNetworkTitleLabel;
@property (strong, nonatomic) IBOutlet UITableView *networkTableView;


@property (nonatomic, strong) NSArray *accountArr;
@property (nonatomic, strong) NSArray *chainsList;

@property (nonatomic ,strong) WalletModel *selectedWalletModel; // 当前选择的账户
@end

@implementation AccountChainListView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.text = KLocalizedString(@"changeAccount");
    self.chooseNetworkTitleLabel.text = KLocalizedString(@"chooseNetwork");
    [self initUI];
}

- (IBAction)closeButtonAction:(UIButton *)sender {
    [self hideView];
    
}
- (IBAction)addAccountButtonAction:(UIButton *)sender {
    if (self.selectBlock) {
        self.selectBlock(1, nil);
        [self hideView];
    }
}

- (void)initUI{
    self.accountTableView.rowHeight = KAccountChainListViewAccountCellHeight;
    self.accountTableView.delegate = self;
    self.accountTableView.dataSource = self;
    self.accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     [self.accountTableView registerNib:[UINib nibWithNibName:KAccountChainListViewAccountCellID bundle:nil] forCellReuseIdentifier:KAccountChainListViewAccountCellID];
    
    self.networkTableView.rowHeight = KAccountChainListViewChainCellHeight;
    self.networkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.networkTableView registerNib:[UINib nibWithNibName:KAccountChainListViewChainCellID bundle:nil] forCellReuseIdentifier:KAccountChainListViewChainCellID];
    self.networkTableView.delegate = self;
    self.networkTableView.dataSource = self;
    [self.accountTableView reloadData];
    [self.networkTableView reloadData];
}

- (void)setWalletModel:(WalletModel *)walletModel{
    _walletModel = walletModel;
    self.selectedWalletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
    self.selectedWalletModel.chain = walletModel.chain; // 因为未同步chain则这里需要重新赋值
    [self getAccountsBalance];
    [self getAssetsInfo];
    
}

- (void)getAccountsBalance
{
    NSArray *accountArr =  [WalletModel mj_objectArrayWithKeyValuesArray:[UserDefaultsUtil getAllWallet]];
    self.accountArr = accountArr;
    NSMutableArray *pubKeys = [NSMutableArray new];
    for (WalletModel *model in self.accountArr) {
        if ([model.publicKey isEqualToString:self.selectedWalletModel.publicKey]) {
            model.selected = YES;
        }
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
                for (WalletModel *model in self.accountArr) {
                    NSNumber *totalBalance = [dataObj objectForKey:model.publicKey];
                    model.totalBalance = [totalBalance doubleValue];
                }
                [strongSelf.accountTableView  reloadData];
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}


- (void)getAssetsInfo{
    WalletPriceModel *walletPriceModel =  [WalletPriceModel new];
    walletPriceModel.pubKey = self.selectedWalletModel.publicKey;
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_CHAIN_PRICE dataModel:walletPriceModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            if (dataObj) {
                DLog(@"当前账户所有链资产信息:%@",dataObj);
//                sortedArrayUsingComparator
                NSArray *list = [WalletChainModel mj_objectArrayWithKeyValuesArray:dataObj];
                strongSelf.chainsList  = [list sortedArrayUsingComparator:^NSComparisonResult(  WalletChainModel* obj1, WalletChainModel* obj2) {
                    return [obj2.price compare:obj1.price];
                }];
               
                for (int i = 0; i<strongSelf.chainsList.count; i++) {
                    WalletChainModel *model = strongSelf.chainsList[i];
                    model.address = [strongSelf.selectedWalletModel.addressDict objectForKey:model.chain];
                }
                [strongSelf.networkTableView reloadData];
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual: self.accountTableView]) {
        return self.accountArr.count;
    }else{
        return self.chainsList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *_cell;
    if ([tableView isEqual: self.accountTableView]) {
        AccountChainListViewAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:KAccountChainListViewAccountCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WalletModel *model = self.accountArr[indexPath.row];
        model.selected = [model.address isEqualToString:self.selectedWalletModel.address]? YES :NO;
        cell.walletModel = model;
        _cell = cell;
    }else{
        AccountChainListViewChainCell *cell = [tableView dequeueReusableCellWithIdentifier:KAccountChainListViewChainCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WalletChainModel *model = self.chainsList[indexPath.row];
        cell.walletChainModel = model;
        if ([model.chain isEqualToString:self.selectedWalletModel.chain]) {
            cell.selectedView.hidden = NO;
        }else{
            cell.selectedView.hidden = YES;
        }
        _cell = cell;
    }
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.accountTableView) {
         WalletModel *model = self.accountArr[indexPath.row];
        model.chain = @""; // 这里重置默认链
        self.selectedWalletModel = model;
        [self.accountTableView reloadData];
        [self getAssetsInfo];
    }else{
        WalletChainModel *model = self.chainsList[indexPath.row];
        self.selectedWalletModel.chain = model.chain;
        if (self.selectBlock) {
            self.selectBlock(2,self.selectedWalletModel);
            NSMutableDictionary *walletDict = [self.selectedWalletModel mj_keyValues];
            [UserDefaultsUtil saveNowWallet:walletDict];
            [self hideView];
        }
    }
}

@end
