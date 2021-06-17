//
//  TransferFeeUtil.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/15.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "TransferFeeUtil.h"
#import "GasLimitModel.h"
#import "GasPriceModel.h"

@implementation TransferFeeUtil


/**
 快捷获取交易手续费
 @param type               类型
 @param transferModel      交易对象
 */
- (void)getTransferFeeWithType:(TransferFeeType)type
                 transferModel:(TransferTempModel *)transferModel
{
    [self getTransferFeeWithType:type transferModel:transferModel toAddress:nil amount:nil transferFeeBlock:nil];
}

- (void)getTransferFeeWithType:(TransferFeeType)type
                 transferModel:(TransferTempModel *)transferModel
              transferFeeBlock:(TransferFeeBlock)transferFeeBlock
{
    [self getTransferFeeWithType:type transferModel:transferModel toAddress:nil amount:nil transferFeeBlock:transferFeeBlock];
}

/**
 获取交易手续费
 @param type               类型
 @param transferModel      交易对象
 @param toAddress          接收地址
 @param amount             金额
 */
- (void)getTransferFeeWithType:(TransferFeeType)type
                 transferModel:(TransferTempModel *)transferModel
                     toAddress:(NSString * _Nullable)toAddress
                        amount:(NSString * _Nullable)amount
{
    [self getTransferFeeWithType:type transferModel:transferModel toAddress:toAddress amount:amount transferFeeBlock:nil];
}

- (void)getTransferFeeWithType:(TransferFeeType)type
                 transferModel:(TransferTempModel *)transferModel
                     toAddress:(NSString * _Nullable)toAddress
                        amount:(NSString * _Nullable)amount
              transferFeeBlock:(TransferFeeBlock _Nullable)transferFeeBlock
{
    KShowHUD;
    if (type == TransferFeeTypeIsContractAddress) {
        GasLimitModel *gasLimitModel = [GasLimitModel new];
        gasLimitModel.chain = transferModel.fromChain;
        gasLimitModel.address = transferModel.fromAddress;
        gasLimitModel.contractAddress = transferModel.assetModel.contractAddress;
        NSArray *args = @[toAddress,amount];
        gasLimitModel.args = args;
        if (![ChainUtil isNuls:transferModel.toChain]) {
            gasLimitModel.methodName = @"transferCrossChain";
            gasLimitModel.value = [NSString stringWithFormat:@"%.0f",0.1 * pow(10, 8)];
        }
        [NetUtil requestWithType:RequestTypePost path:API_CONTRACT_IMPUTED_CALL_GAS dataModel:gasLimitModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
            KHideHUD;
            if (success) {
                DLog(@"gasLimit%@",dataObj);
                if (dataObj) {
                    NSNumber *gasLimit = [dataObj objectForKey:@"gasLimit"];
                    double dFee = 0.001;
                    if ([gasLimitModel.value intValue]>0) {
                        dFee = 0.101;
                    }
                    NSNumber *feeNum = @([gasLimit intValue] * 25 + dFee * pow(10, 8));
                    transferModel.fee = [[Common formatValueWithValue:feeNum andDecimal:8] doubleValue];
                    transferModel.gasLimit = gasLimit;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(transferFeeDidReceiveType:transferModel:)]) {
                        [self.delegate transferFeeDidReceiveType:type transferModel:transferModel];
                    }
                    if (transferFeeBlock) {
                        transferFeeBlock(type,transferModel);
                    }
                }
            } else {
                [KAppDelegate.window showNormalToast:message];
            }
        }];
    } else {
        GasPriceModel *gasPirceModel = [GasPriceModel new];
        
        NSString *urlPath;
        if (type == TransferFeeTypeIsNVTCroee) {
            urlPath = API_ASSET_NVT_CROSS_PRICE;
            gasPirceModel.chain = transferModel.toChain;
        } else if (type == TransferFeeTypeIsFromIsomerism) {
            urlPath = API_ASSET_GAS_PRICE;
            gasPirceModel.chain = transferModel.fromChain;
        }
        [NetUtil requestWithType:RequestTypePost path:urlPath dataModel:gasPirceModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
             KHideHUD;
            if (success) {
                DLog(@"查询异构链gasprice%@",dataObj);
                NSNumber *price = dataObj;
                if (type == TransferFeeTypeIsNVTCroee) {
                    transferModel.fee = [price doubleValue] / pow(10, 8);
                } else if (type == TransferFeeTypeIsFromIsomerism) {
                    BOOL isContractAddress = transferModel.assetModel.contractAddress &&  transferModel.assetModel.contractAddress.length > 0;
                    NSInteger gasLimit = isContractAddress ? 100000 : 35000;
                    // 这里因为取回来的是异构链的价格 小数点固定18位
                    transferModel.fee = [[Common formatValueWithValue:@([price doubleValue] * gasLimit) andDecimal:18] doubleValue];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(transferFeeDidReceiveType:transferModel:)]) {
                    [self.delegate transferFeeDidReceiveType:type transferModel:transferModel];
                }
                if (transferFeeBlock) {
                    transferFeeBlock(type,transferModel);
                }
            } else {
                [KAppDelegate.window showNormalToast:message];
            }
        }];
    }
}

@end
