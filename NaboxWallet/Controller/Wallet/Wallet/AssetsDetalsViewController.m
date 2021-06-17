//
//  AssetsDetalsViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AssetsDetalsViewController.h"
#import "AssetsDetalsTableViewCell.h"
#import "AssetsRecordTableViewCell.h"
#import "AssetsDetalsBottomView.h"
#import "TransferViewControllers.h"
#import "ReceivablesViewController.h"
#import "TradingRecordViewController.h"
#import "TradingRecordFilterView.h"
#import "QueryTxListModel.h"
#import "CoinDetailModel.h"
#import "AddAddressPopView.h"
#import "ContactViewController.h"
#import "CrossChainTransferViewController.h"
@interface AssetsDetalsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AssetsDetalsBottomView *bottomView;
@property (nonatomic, strong) UIView *topTempView;

@property (nonatomic, strong) QueryTxListModel *tradeListModel; // 筛选条件

@property (nonatomic, strong) WalletModel *walletModel;
@property (nonatomic, strong) NSMutableArray *tradeList;
@property (nonatomic ,strong) AssetListResModel *assetModel;
@end

@implementation AssetsDetalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshWhite = YES;
    self.tableView.mj_header.backgroundColor = KColorPrimary;
     [self topTempView];
    self.navigationItem.title = KLocalizedString(@"assetDetail");
    self.walletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
    
    self.tradeListModel = [QueryTxListModel new];
    self.tradeListModel.chain = self.assetInfoModel.chain;
    self.tradeListModel.address =  self.assetInfoModel.address;
   
    if ([self.assetInfoModel.contractAddress isHaveValue]) {
         self.tradeListModel.contractAddress = self.assetInfoModel.contractAddress;
        
    }else{
        self.tradeListModel.assetId = self.assetInfoModel.assetId;
        self.tradeListModel.chainId = self.assetInfoModel.chainId;
    }
    [self getAssetInfo];
    // 查询数据
    [self headerRefresh];
}

// 查询资产
- (void)getAssetInfo{
    self.assetInfoModel.refresh = false;
    self.assetInfoModel.resClassStr = NSStringFromClass([AssetListResModel class]); ;
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_ADRESS_ASEET dataModel:self.assetInfoModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            DLog(@"资产详情%@",dataObj);
            strongSelf.assetModel = dataObj;
            [strongSelf.tableView reloadData];
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:KColorPrimary] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:KColorPrimary];
    self.showTitleIsWhite = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.showTitleIsWhite = NO;
}
//下拉刷新
- (void)headerRefresh
{
    self.tradeListModel.pageNumber = 1;
    [self getAssetInfo];
    [self getTradeList];
}

//上拉加载
- (void)footerRefresh
{
    self.tradeListModel.pageNumber ++;
    [self getTradeList];
}

#pragma 获取当前链交易记录
- (void)getTradeList{
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_TX_COIN_LIST dataModel:self.tradeListModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            if (dataObj && [dataObj objectForKey:@"records"]) {
                NSArray *list =  [dataObj objectForKey:@"records"];
                DLog(@"交易记录%@",dataObj);
                if (self.tradeListModel.pageNumber > 1) {
                    NSArray *array = [TradeListModel mj_objectArrayWithKeyValuesArray:list];
                    [strongSelf.tradeList addObjectsFromArray:array];
                }else{
                    strongSelf.tradeList = [TradeListModel mj_objectArrayWithKeyValuesArray:list];
                }
            }
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView.mj_footer endRefreshing];
            
            if (!self.tradeList.count) {
                self.placeholderView.coverImageView.image = ImageNamed(@"png_Blank pages3");
                self.placeholderView.coverLabel.text = KLocalizedString(@"no_trade_list");
                self.tableView.tableFooterView = self.placeholderView;
            }
             [strongSelf.tableView reloadData];
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

/** type:0~跨链划转，1~转账 */
- (void)assetsTradingSelectWithType:(NSInteger)type
{
    AssetListModel *asssetModel = [AssetListModel new];
    asssetModel.chain = self.assetInfoModel.chain;
    asssetModel.address = self.assetInfoModel.address;
    if (!type) {
        CrossChainTransferViewController *crossChainTransferVC = [[CrossChainTransferViewController alloc] init];
        crossChainTransferVC.assetListModel = asssetModel;
        [self.navigationController pushViewController:crossChainTransferVC animated:YES];
    }else if (type == 1) {
        TransferViewControllers *transferVC = [[TransferViewControllers alloc] init];
        
        transferVC.assetListModel = asssetModel;
        [self.navigationController pushViewController:transferVC animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 1;
    }
    return self.tradeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        AssetsDetalsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KAssetsDetalsTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.assetModel = self.assetModel;
        return cell;
    }
    AssetsRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KAssetsRecordTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TradeListModel *tradeModel = self.tradeList[indexPath.row];
    cell.transModel = tradeModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        return KAssetsDetalsTableViewCellHeight;
    }
    return KAssetsRecordTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section!=0){//点击顶部不跳转
        if (self.tradeList.count > indexPath.row) {
            TradeListModel *tradeModel = self.tradeList[indexPath.row];
            TradingRecordViewController *vc = [TradingRecordViewController new];
            vc.chain = self.assetInfoModel.chain;
            vc.txHash = tradeModel.txHash;
            vc.transCoinId = tradeModel.id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
    return FLT_MIN;
}

/** 其他逻辑 **/
- (void)goBack
{
    if (self.backRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (UIView *)topTempView
{
    if (!_topTempView) {
        _topTempView = [[UIView alloc] init];
        _topTempView.backgroundColor = KColorPrimary;
        [self.tableView.mj_header addSubview:_topTempView];
        [self.tableView.mj_header sendSubviewToBack:self.topTempView];
        [_topTempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.tableView.mj_header);
            make.height.mas_equalTo(KSCREEN_HEIGHT / 2);
        }];
    }
    return _topTempView;
}

- (QueryTxListModel *)tradeListModel
{
    if (!_tradeListModel) {
        _tradeListModel = [[QueryTxListModel alloc] init];
        _tradeListModel.address = self.walletModel.address;
        _tradeListModel.current = 1;
        _tradeListModel.size = 20;
    }
    return _tradeListModel;
}

- (AssetsDetalsBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [AssetsDetalsBottomView instanceView];
//        _bottomView.backgroundColor = kColorBackground;
        _bottomView.backgroundColor = [UIColor clearColor];
        WS(weakSelf);
        _bottomView.tradingBlock = ^(NSInteger type) {
            [weakSelf assetsTradingSelectWithType:type];
        };
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom);
            make.height.mas_equalTo(KAssetsDetalsBottomViewHeight);
        }];
    }
    return _bottomView;
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
        [_tableView registerNib:[UINib nibWithNibName:KAssetsDetalsTableViewCellID bundle:nil] forCellReuseIdentifier:KAssetsDetalsTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:KAssetsRecordTableViewCellID bundle:nil] forCellReuseIdentifier:KAssetsRecordTableViewCellID];
//        CGFloat height = KAssetsDetalsBottomViewHeight + (iPhoneX ? KSafeAreaHeight : 0);
        _tableView.tableFooterView = [[UIView alloc] init];
        [self setupRefreshFortableView:_tableView headerReresh:YES footderReResh:YES];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
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
