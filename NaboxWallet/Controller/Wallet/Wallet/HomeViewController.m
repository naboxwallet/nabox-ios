//
//  HomeViewController.m
//  NaboxWallet
//
//  Created by Admin on 2020/11/28.
//  Copyright © 2020 NaboxWallet. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeChainsViewCell.h"
#import "HomeCardTableViewCell.h"
#import "HomeAssetsTableViewCell.h"
#import "AssetsRecordTableViewCell.h"
#import "TransferViewControllers.h"
#import "CreateWalletTypeViewController.h"
#import "TradingRecordViewController.h"
#import "AssetsDetalsViewController.h"
#import "CrossChainTransferViewController.h"
#import "AssetManageViewController.h"
#import "ReceivablesViewController.h"
#import "WalletDetailsViewController.h"
#import "WalletPriceModel.h"
#import "QueryTxListModel.h"
#import "ConfigModel.h"
#import "AssetListModel.h"
#import "WalletChainModel.h"
#import "TradeListModel.h"

#import "AccountChainListView.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,HomeCardTableViewCellDelegate>
//用户可添加多个钱包,一个私钥对应一个钱包 一个钱包下有N(5)条链 一个链下面可能存在多个资产
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) WalletModel *walletModel; // 当前钱包数据model
@property (nonatomic, strong) NSArray *chainAssetList; // 链资产列表
@property (nonatomic ,assign) BOOL showAsset; // 显示资产/交易记录
@property (nonatomic ,strong) NSMutableArray *tradeRecordArray; // 交易记录
@property (nonatomic ,strong) NSMutableArray *assetArray; // 资产列表
@property (nonatomic ,strong) QueryTxListModel *tradeListModel;

@property (nonatomic ,strong) UILabel *leftBarLabel; // 左侧导航栏文本
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackground;
//    self.navigationItem.rightBarButtonItem = [self getBarButtonItemWithImage:ImageNamed(@"icon_screen") action:@selector(richScanAction:)];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.tableView.backgroundColor = KColorBg;
    self.showAsset = YES; // 默认显示资产
    self.walletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
    DLog(@"当前钱包%@",[self.walletModel mj_keyValues]);
   
    self.tradeListModel = [QueryTxListModel new];
    [self getExchangeRate]; // 汇率 目前返回btc 和rmb汇率
    [self getChainConfig]; // 链配置
    
}
- (void)viewWillAppear:(BOOL)animated
{
//   self.navigationItem.title = KLocalizedString(@"wallet");
     [self setLeftBarButtonItem];
    [self refreshData];
}

// 每次进入 切换账户 重新请求本账户个条链信息 当前选择链资产列表和交易记录
- (void)refreshData{
    [self getAllChainInfo]; // 获取当前账户全部链信息和资产信息
    [self getAssetList]; // 当前链资产列表 默认NULS资产
    [self getTradeList]; // 当前链交易记录 // 当前链当前资产交易记录
}

#pragma 获取费率
- (void)getExchangeRate{
    WalletModel *exchangeRateModel =  [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
    [NetUtil requestWithType:RequestTypeGet path:API_USDT_EXCHANGE dataModel:exchangeRateModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        if (success) {
            if (dataObj) {
                DLog(@"汇率%@",dataObj);
                NSArray *array = dataObj;
                for (int i = 0; i<array.count; i++) {
                    NSDictionary *ob = array[i];
                    NSString *code = [ob objectForKey:@"code"];
                    NSNumber *price = [ob objectForKey:@"price"];
                    if ([code isEqualToString:@"BTC"]) {
                        [GlobalVariable sharedInstance].btcRate = price;
                    }else if ([code isEqualToString:@"CNY"]){
                        [GlobalVariable sharedInstance].cnyRate = price;
                    }
                }
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}
#pragma 获取链配置
- (void)getChainConfig{
    ConfigModel *configModel =  [ConfigModel new];
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypeGet path:API_CHAIN_CONFIG dataModel:configModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            if (dataObj) {
                DLog(@"链配置%@",dataObj);
                NSArray *configList = dataObj;
                NSMutableArray *chainConfig = [NSMutableArray new];
                for (int i = 0; i <configList.count; i++) {
                    ConfigInfoModel *config = [ConfigInfoModel mj_objectWithKeyValues:configList[i]];
                    [chainConfig addObject:config];
                }
//                strongSelf.walletModel.chainConfig = chainConfig;
                [GlobalVariable sharedInstance].configList = chainConfig;
                //                // 把链配置保存在WallctModel上 方便其他页面使用
                //                NSDictionary *walletDict = [strongSelf.walletModel mj_keyValues];
                //                [UserDefaultsUtil saveNowWallet:walletDict];
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

#pragma 查询当前账户个条链资产信息
- (void)getAllChainInfo{
    WalletPriceModel *walletPriceModel =  [WalletPriceModel new];
    walletPriceModel.pubKey = self.walletModel.publicKey;
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_CHAIN_PRICE dataModel:walletPriceModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            if (dataObj) {
                DLog(@"当前账户所有链资产信息:%@",dataObj);
                strongSelf.chainAssetList = [WalletChainModel mj_objectArrayWithKeyValuesArray:dataObj];
                [strongSelf.tableView reloadData];
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

#pragma 查询当前链资产列表
- (void)getAssetList{
    AssetListModel *assetModel =  [AssetListModel new];
    assetModel.address = [self.walletModel.addressDict objectForKey:self.walletModel.chain];
    assetModel.chain = self.walletModel.chain;
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_ADRESS_ASEETS dataModel:assetModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            DLog(@"链-资产列表%@",dataObj);
            strongSelf.assetArray = [NSMutableArray arrayWithArray:[AssetListResModel mj_objectArrayWithKeyValuesArray:dataObj]];
            [strongSelf.tableView reloadData];
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

#pragma 获取当前链交易记录
- (void)getTradeList{
    self.tradeListModel.chain = self.walletModel.chain;
    self.tradeListModel.address = [self.walletModel.addressDict objectForKey:self.walletModel.chain];
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_TX_COIN_LIST dataModel:self.tradeListModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            if (dataObj && [dataObj objectForKey:@"records"]) {
                NSArray *list =  [dataObj objectForKey:@"records"];
                DLog(@"交易记录%@",dataObj);
                if (self.tradeListModel.pageNumber > 1) {
                    NSArray *array = [TradeListModel mj_objectArrayWithKeyValuesArray:list];
                    [strongSelf.tradeRecordArray addObjectsFromArray:array];
                }else{
                    strongSelf.tradeRecordArray = [TradeListModel mj_objectArrayWithKeyValuesArray:list];
                }
                [strongSelf.tableView.mj_header endRefreshing];
                [strongSelf.tableView.mj_footer endRefreshing];
                
                if (!self.tradeRecordArray.count && !self.showAsset) {
                    self.placeholderView.coverImageView.image = ImageNamed(@"png_Blank pages3");
                    self.placeholderView.coverLabel.text = KLocalizedString(@"no_trade_list");
                    self.tableView.tableFooterView = self.placeholderView;
                }else{
                    self.tableView.tableFooterView = nil;
                }
                [strongSelf.tableView reloadData];
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}


#pragma 切换账户
- (void)changeAccountAction:(UIBarButtonItem *)sender{
    AccountChainListView *accountView = [AccountChainListView instanceView];
    accountView.walletModel = self.walletModel;
    [accountView showInController:self preferredStyle:TYAlertControllerStyleActionSheet];
    WS(weakSelf);
    accountView.selectBlock = ^(NSInteger tag, WalletModel * _Nullable walletModel) {
        SS(strongSelf);
        if (tag == 2) {
            strongSelf.tradeListModel.pageNumber = 1;
            strongSelf.walletModel = walletModel;
//            strongSelf.leftBarLabel.text = strongSelf.walletModel.chain;
            [strongSelf setLeftBarButtonItem];
            [strongSelf refreshData];
        }
        else if (tag == 1) {
            CreateWalletTypeViewController *createVC = [[CreateWalletTypeViewController alloc] init];
            [createVC setHidesBottomBarWhenPushed:YES];
            [strongSelf.navigationController pushViewController:createVC animated:YES];
        }
    };
}

#pragma ================== tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        if (self.showAsset) {
            return self.assetArray.count;
        }else{
            return self.tradeRecordArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HomeCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHomeCardTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.walletModel = self.walletModel;
        for (int i = 0;i< self.chainAssetList.count; i++) {
            WalletChainModel *model = self.chainAssetList[i];
            if ([model.chain isEqualToString:self.walletModel.chain]) {
                cell.asset = model.price;
            }
        }
        return cell;
    }else{
        if (self.showAsset) {
            HomeAssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHomeAssetsTableViewCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            AssetListResModel *assetModel = self.assetArray[indexPath.row];
            cell.assetModel = assetModel;
            return cell;
        }else{
            AssetsRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KAssetsRecordTableViewCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            TradeListModel *tradeModel = self.tradeRecordArray[indexPath.row];
            cell.transModel = tradeModel;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return KHomeCardTableViewCellHeight;
    }else{
        if (self.showAsset) {
            return KHomeAssetsTableViewCellHeight;
        }else{
            return KAssetsRecordTableViewCellHeight;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section) {
        return self.headView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 50;
    }
    return FLT_MIN;
}

- (void)addAssetAction{
    AssetManageViewController *vc = [AssetManageViewController new];
    vc.walletModel = self.walletModel;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

// 点击资产 和交易记录
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        if (self.showAsset) {
            AssetListResModel *assetModel = self.assetArray[indexPath.row];
            AssetsDetalsViewController *vc = [AssetsDetalsViewController new];
            AssetInfoModel *assetInfoModel = [AssetInfoModel new];
            assetInfoModel.address = [self.walletModel.addressDict objectForKey:self.walletModel.chain];
            assetInfoModel.chain = assetModel.chain;
            assetInfoModel.chainId = assetModel.chainId;
            assetInfoModel.assetId = assetModel.assetId;
            assetInfoModel.contractAddress = assetModel.contractAddress;
            vc.assetInfoModel = assetInfoModel;
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            TradeListModel *tradeModel = self.tradeRecordArray[indexPath.row];
            TradingRecordViewController *vc = [TradingRecordViewController new];
            vc.chain = self.walletModel.chain;
            vc.txHash = tradeModel.txHash;
            vc.transCoinId = tradeModel.id;
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma HomeCardTableViewCellDelegate 转账和跨链转账
-(void)walletCardDidSelect:(NSInteger)tag index:(NSInteger)index{
    if (tag == 0) { // 点击收款码
        ReceivablesViewController *vc = [ReceivablesViewController new];
        vc.chain = self.walletModel.chain;
        vc.addressStr = [self.walletModel.addressDict objectForKey:self.walletModel.chain];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag == 1) { // 跨链转账
        CrossChainTransferViewController *crossChainTransferVC = [[CrossChainTransferViewController alloc] init];
        AssetListModel *asssetModel = [AssetListModel new];
        asssetModel.chain = self.walletModel.chain;
        asssetModel.address = [self.walletModel.addressDict objectForKey:self.walletModel.chain];
        crossChainTransferVC.assetListModel = asssetModel;
        [crossChainTransferVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:crossChainTransferVC animated:YES];
    }else if(tag == 2) { // 转账
        TransferViewControllers *vc = [TransferViewControllers new];
        AssetListModel *asssetModel = [AssetListModel new];
        asssetModel.chain = self.walletModel.chain;
        asssetModel.address = [self.walletModel.addressDict objectForKey:self.walletModel.chain];
        vc.assetListModel = asssetModel;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag == 3){ // 详情
        WalletDetailsViewController *vc = [WalletDetailsViewController new];
        vc.walletModel = self.walletModel;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



//下拉刷新
- (void)headerRefresh
{
    self.tradeListModel.pageNumber  = 1;
    
    [self getAllChainInfo]; // 获取全部链信息
    [self getAssetList]; // 当前链资产列表 默认ETH资产
    [self getTradeList]; // 当前链交易记录 // 当前链当前资产交易记录
}

//上拉刷新
- (void)footerRefresh
{
    if (self.tradeRecordArray.count % self.tradeListModel.pageSize == 0) {
        self.tradeListModel.pageNumber ++;
        [self getTradeList];
    }else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}


- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 70)];
        self.headLabel = [[UILabel alloc] init];
        self.headLabel.textAlignment = NSTextAlignmentLeft;
        self.headLabel.textColor = KColorDarkGray;
        [self.headLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        self.headLabel.userInteractionEnabled = YES;
        [_headView addSubview:self.headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headLabel.superview);
            make.left.equalTo(self.headLabel.superview).offset(15);
        }];
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetListAndRecordLabelClick)];
        [self.headLabel addGestureRecognizer:labelTapGestureRecognizer];
        [self updateTableViewHeadLabel];
        
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setBackgroundImage:ImageNamed(@"icon_add") forState:UIControlStateNormal];
        [_headView addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headLabel.superview);
            make.right.equalTo(self.headLabel.superview).offset(-15);
        }];
        [addButton addTarget:self action:@selector(addAssetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}

- (void)updateTableViewHeadLabel{
    NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ / %@",KLocalizedString(@"Assets"),KLocalizedString(@"transaction_record")]];
    NSInteger sLength = attrs.length;
    NSString *assetsAndSpace = [NSString stringWithFormat:@"%@ ",KLocalizedString(@"Assets")];
    NSInteger assetsLength = assetsAndSpace.length;
    [attrs addAttribute:NSForegroundColorAttributeName value:self.showAsset?KColorBlack:KColorGray2 range:NSMakeRange(0, self.showAsset?assetsLength:assetsLength +1)];
    [attrs addAttribute:NSFontAttributeName value:self.showAsset?kSetSystemBoldFontOfSize(16):kSetSystemFontOfSize(12) range:NSMakeRange(0, self.showAsset?assetsLength:assetsLength +1)];
    [attrs addAttribute:NSForegroundColorAttributeName value:self.showAsset?KColorGray2:KColorBlack range:NSMakeRange(self.showAsset?assetsLength:assetsLength+1, self.showAsset?sLength-assetsLength:sLength-assetsLength-1)];
    [attrs addAttribute:NSFontAttributeName value:!self.showAsset?kSetSystemBoldFontOfSize(16):kSetSystemFontOfSize(12) range:NSMakeRange(self.showAsset?assetsLength:assetsLength+1, self.showAsset?sLength-assetsLength:sLength-assetsLength-1)];
    self.headLabel.attributedText = attrs;
}

- (void)assetListAndRecordLabelClick{
    self.showAsset = !self.showAsset;
    [self updateTableViewHeadLabel];
    if (!self.tradeRecordArray.count && !self.showAsset) {
        self.placeholderView.coverImageView.image = ImageNamed(@"png_Blank pages3");
        self.placeholderView.coverLabel.text = KLocalizedString(@"no_trade_list");
        self.tableView.tableFooterView = self.placeholderView;
    }else{
        self.tableView.tableFooterView = nil;
    }
    [self.tableView reloadData];
}

- (void)setLeftBarButtonItem{
    CGFloat height = 28;
    CGFloat aliseWidth = [Common getTextWidthWithText:self.walletModel.alias font:kSetSystemBoldFontOfSize(14) hight:28] + 14;
    if (aliseWidth < 40) {
        aliseWidth = 40;
    }
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBarButton setFrame:CGRectMake(0, 0, 40 + aliseWidth, height)];
    leftBarButton.layer.backgroundColor = [UIColor colorWithRed:237/255.0 green:246/255.0 blue:244/255.0 alpha:1.0].CGColor;
    leftBarButton.layer.cornerRadius = height/2;
    [leftBarButton addTarget:self action:@selector(changeAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(4,0,28,28);
    NSString *iconName = [NSString stringWithFormat:@"logo_%@",self.walletModel.chain];
    imageView.image = ImageNamed(iconName);
    [leftBarButton addSubview:imageView];
    
    self.leftBarLabel = [[UILabel alloc] init];
    
    self.leftBarLabel.frame = CGRectMake(40,0,aliseWidth,height);
    self.leftBarLabel.layer.backgroundColor = [UIColor colorWithRed:83/255.0 green:184/255.0 blue:169/255.0 alpha:1.0].CGColor;
    self.leftBarLabel.layer.cornerRadius = height/2;
    self.leftBarLabel.textColor = KColorWhite;
    self.leftBarLabel.font = kSetSystemBoldFontOfSize(14);
    self.leftBarLabel.text = self.walletModel.alias;
    self.leftBarLabel.textAlignment = NSTextAlignmentCenter;
    [leftBarButton addSubview:self.leftBarLabel];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.navigationItem.leftBarButtonItems =@[leftItem];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kColorBackground;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:KHomeCardTableViewCellID bundle:nil] forCellReuseIdentifier:KHomeCardTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:KHomeAssetsTableViewCellID bundle:nil] forCellReuseIdentifier:KHomeAssetsTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:KAssetsRecordTableViewCellID bundle:nil] forCellReuseIdentifier:KAssetsRecordTableViewCellID];
        _tableView.tableFooterView = [UIView new];
        [self setupRefreshFortableView:_tableView headerReresh:YES footderReResh:YES];
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
