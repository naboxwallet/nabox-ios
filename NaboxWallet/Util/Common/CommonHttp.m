//
//  CommonHttp.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "CommonHttp.h"

@interface CommonHttp ()
@property (nonatomic, strong) WalletModel *walletModel;
@property (nonatomic, strong) NSArray *walletArr;
@end

@implementation CommonHttp

+ (instancetype)sharedInstance
{
    static CommonHttp *_globalHttp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _globalHttp = [[CommonHttp alloc] init];
    });
    return _globalHttp;
}

/**
 查询钱包余额
 isAll:YES(查询所有钱包余额)，NO（查询当前选择钱包余额）
 balanceBlock:回调
 */
- (void)getNulsBalanceWithIsAll:(BOOL)isAll balanceBlock:(NulsBalanceBlock)balanceBlock
{
    NSString *address = [NSString string];
    if (isAll) {
        self.walletArr = [WalletModel mj_objectArrayWithKeyValuesArray:[UserDefaultsUtil getAllWallet]];
        if (!self.walletArr.count) {
            return;
        }
        for (WalletModel *model in self.walletArr) {
            if (!address.length) {
                address = model.address;
                continue;
            }
            address = [NSString stringWithFormat:@"%@,%@",address,model.address];
        }
    }else {
        self.walletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
        address = self.walletModel.address;
    }
    [self getNulsBalanceWithAddress:address isAll:isAll balanceBlock:balanceBlock];
}

/**
 查询自定义钱包余额
 address:自定义钱包余额
 isAll:对外默认都传NO
 balanceBlock:回调
 */
- (void)getNulsBalanceWithAddress:(NSString *)address isAll:(BOOL)isAll balanceBlock:(NulsBalanceBlock)balanceBlock
{
    BasePublicModel *dataModel = [BasePublicModel new];
    dataModel.params = @[@(CHAINID),@(ASSETID),address];
    if (isAll) {
        [NetUtil requestWithMethod:PUBLIC_API_WALLETS_INFO dataModel:dataModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
            if (success) {
                [self updateWalletDataWithDataObj:dataObj address:address isAll:isAll balanceBlock:balanceBlock];
            }else{
                [KAppDelegate.window showNormalToast:message];
            }
        }];
    }else{
         dataModel.params = @[@(CHAINID),@(ASSETID),address];
        [NetUtil requestWithMethod:PUBLIC_API_WALLET_INFO dataModel:dataModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
            if (success) {
                [self updateWalletDataWithDataObj:dataObj address:address isAll:isAll balanceBlock:balanceBlock];
            }else{
                [KAppDelegate.window showNormalToast:message];
            }
        }];
    }
}



- (void)updateWalletDataWithDataObj:(NSDictionary *)dataObj address:(NSString *)address isAll:(BOOL)isAll balanceBlock:(NulsBalanceBlock)balanceBlock
{
    if (isAll) {
        for (WalletModel *model in self.walletArr) {
            NulsBalanceModel *balanceModel = [NulsBalanceModel mj_objectWithKeyValues:dataObj[model.address]];
            model.balanceModel = balanceModel;
            model.totalBalance = balanceModel.totalBalance.doubleValue / pow(10, 8);
            model.balance = balanceModel.balance.doubleValue / pow(10, 8);
            if (![GlobalVariable sharedInstance].cnyRate) {
                [GlobalVariable sharedInstance].cnyRate = @(1);
                [GlobalVariable sharedInstance].usdRate = @(1);
            }
        }
        if (balanceBlock) {
            balanceBlock(nil,self.walletArr);
        }
    }else {
        NulsBalanceModel *balanceModel = [NulsBalanceModel mj_objectWithKeyValues:dataObj];
        if (![GlobalVariable sharedInstance].cnyRate) {
                    [GlobalVariable sharedInstance].cnyRate = @(1);
                    [GlobalVariable sharedInstance].usdRate = @(1);
        }
        if (balanceBlock) {
            balanceBlock(balanceModel,nil);
        }
    }
}


/**
 获取账户信息
 address: 地址
 accountBlock:回调
 */
- (void)getNulsAccountWithAddress:(NSString *)address accountBlock:(ResponseDataBlock)accountBlock
{
    WalletModel *postModel = [[WalletModel alloc] init];
    postModel.isAdd = YES;
    postModel.address = address;
    [NetUtil requestWithType:RequestTypePost path:API_NULS_ACCOUNT dataModel:postModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        accountBlock(dataObj,success,message);
    }];
}


@end
