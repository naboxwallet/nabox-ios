//
//  AssetManageViewController.m
//  NaboxWallet  资产管理
//
//  Created by Admin on 2021/3/27.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AssetManageViewController.h"
#import "AssetManageTableViewCell.h"
#import "AssetManageSearchHeadView.h"
#import "AssetFocusModel.h"
#import "SearchAssetModel.h"

@interface AssetManageViewController ()<UITableViewDelegate,UITableViewDataSource,AssetManageTableViewCellDelegate,AssetManageSearchHeadViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AssetManageSearchHeadView *searchView;
@property (nonatomic, strong) NSMutableArray *assetList; // 资产列表

@property (nonatomic ,strong) NSString *keyword;
@property (nonatomic ,strong) NSMutableArray *searchArray; // 搜索资产列表
@end

@implementation AssetManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchView;
    [self tableView];
    self.assetList = [NSMutableArray new];
    [self getFollowedAssetList]; // 获取已关注资产列表
}

#pragma 查询当前链资产列表
- (void)getFollowedAssetList{
    AssetListModel *assetModel =  [AssetListModel new];
    assetModel.address = [self.walletModel.addressDict objectForKey:self.walletModel.chain];
    assetModel.chain = self.walletModel.chain;
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_ADRESS_ASEETS dataModel:assetModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            DLog(@"链-资产列表%@",dataObj);
            NSArray *followedAssetList = [AssetListResModel mj_objectArrayWithKeyValuesArray:dataObj];
            [strongSelf composeAssetsWithFollowedAssetList:followedAssetList];
            [strongSelf.tableView reloadData];
        } else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

/*** 组合资产列表 由首页资产列表 和config里面assets 去重得到 **/
- (void)composeAssetsWithFollowedAssetList:(NSArray *)array{
    self.assetList = [NSMutableArray arrayWithArray:array];
//    ConfigInfoModel *configModel =  [[GlobalVariable sharedInstance] getChainConfigWithChain:self.walletModel.chain];
//    NSMutableArray *configAssetList = [AssetListResModel mj_objectArrayWithKeyValuesArray:configModel.assets];
//    for (int i = 0; i < configAssetList.count; i++) {
//        AssetListResModel *configAssetModel = configAssetList[i];
//        BOOL haveFollowed = false;
//        for (int j = 0; j< self.assetList.count; j++) {
//            AssetListResModel *followedAssetModel = self.assetList[j];
//            haveFollowed = (configAssetModel.chainId == followedAssetModel.chainId && configAssetModel.assetId == followedAssetModel.assetId);
//            if (haveFollowed) break;
//        }
//        if (!haveFollowed) {
//            configAssetModel.noFollowed = YES;
//            [self.assetList addObject:configAssetModel];
//        }
//    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.keyword.length) {
        return self.searchArray.count;
    }
    return self.assetList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(AssetManageTableViewCell.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.assetModel = self.keyword.length ?self.searchArray[indexPath.row]:self.assetList[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

- (void)assetManageSearchChange:(NSString *)keyword{
    self.keyword = keyword;
    [self searchAssetsWithKeyword:keyword];
}

/*** 点击cell操作按钮代理事件 */
- (void)assetManageButtonClickIndex:(NSInteger)index{
    AssetListResModel *assetModel = self.keyword.length ?self.searchArray[index]:self.assetList[index];
    if (assetModel.configType == 1 || assetModel.configType == 2) return;
    AssetFocusModel *focusModel = [AssetFocusModel new];
    focusModel.focus = assetModel.noFollowed ? true :false;
    focusModel.contractAddress = assetModel.contractAddress;
    focusModel.assetId = assetModel.assetId;
    focusModel.chain = assetModel.chain;
    focusModel.chainId = assetModel.chainId;
    focusModel.address = [self.walletModel.addressDict objectForKey:self.walletModel.chain];
    focusModel.symbol = assetModel.symbol;
    [self handleAssetFocusWithModel:focusModel];
}

/** 处理关注和取消关注 **/
- (void)handleAssetFocusWithModel:(AssetFocusModel *)model{
    KShowHUD;
    WS(weakSelf);
    DLog(@"关注资产入参%@", [model mj_keyValues]);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_ADDRESS_ASSET_FOCUS dataModel:model responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        KHideHUD;
        if (success) {
            if (strongSelf.keyword.length) {
                AssetListModel *assetModel =  [AssetListModel new];
                assetModel.address = [self.walletModel.addressDict objectForKey:self.walletModel.chain];
                assetModel.chain = self.walletModel.chain;
                [NetUtil requestWithType:RequestTypePost path:API_WALLET_ADRESS_ASEETS dataModel:assetModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
                    SS(strongSelf);
                    if (success) {
                        DLog(@"链-资产列表%@",dataObj);
                        NSArray *followedAssetList = [AssetListResModel mj_objectArrayWithKeyValuesArray:dataObj];
                        [strongSelf composeAssetsWithFollowedAssetList:followedAssetList];
                        [strongSelf searchAssetsWithKeyword:self.searchView.textField.text];
                    } else {
                        [KAppDelegate.window showNormalToast:message];
                    }
                }];
               
            }else{
//                [strongSelf getFollowedAssetList];
                for (int j = 0; j< self.assetList.count; j++) {
                    AssetListResModel *followedAssetModel = self.assetList[j];
                    if(model.chainId == followedAssetModel.chainId && model.assetId == followedAssetModel.assetId  &&[model.symbol isEqualToString:followedAssetModel.symbol]){
                        followedAssetModel.noFollowed = !followedAssetModel.noFollowed;
                    }
                }
                [strongSelf.tableView reloadData];
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

/** 根据输入搜索资产 **/
- (void)searchAssetsWithKeyword:(NSString *)keyword{
    if (keyword.length == 0) {
        [self getFollowedAssetList];
        return;
    }
    KShowHUD;
    WS(weakSelf);
    SearchAssetModel *searchModel = [SearchAssetModel new];
    searchModel.chain = self.walletModel.chain;
    searchModel.searchKey = keyword;
    [NetUtil requestWithType:RequestTypePost path:API_ASSET_QUERY dataModel:searchModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        KHideHUD;
        if (success) {
            self.searchArray = [AssetListResModel mj_objectArrayWithKeyValuesArray:dataObj];
            for (int i  = 0; i < self.searchArray.count; i++) {
                AssetListResModel *model = self.searchArray[i];
                model.noFollowed = YES;
                // 这里对搜索出来的资产处理
                for (int j = 0; j< self.assetList.count; j++) {
                    AssetListResModel *followedAssetModel = self.assetList[j];
                    BOOL haveFollowed = (model.chainId == followedAssetModel.chainId && model.assetId == followedAssetModel.assetId  &&[model.symbol isEqualToString:followedAssetModel.symbol]&& !followedAssetModel.noFollowed);
                    if (haveFollowed) {
                        model.noFollowed = NO;
                        break;
                    }
                }
            }
            [strongSelf.tableView reloadData];
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

- (AssetManageSearchHeadView *)searchView
{
    if (!_searchView) {
        _searchView = [AssetManageSearchHeadView instanceView];
        [_searchView setCircleWithRadius:6];
        if (iOS11) {
            _searchView.intrinsicContentSize = CGSizeMake(KSCREEN_WIDTH - 80, 35);
        } else{
            _searchView.frame = CGRectMake(0, 0, KSCREEN_WIDTH - 80, 35);
        }
        _searchView.delegate = self;
    }
    return _searchView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.backgroundColor = KColorWhite;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = kColorLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(AssetManageTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(AssetManageTableViewCell.class)];
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
