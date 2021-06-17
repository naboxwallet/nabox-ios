//
//  TransferModel.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "TransferModel.h"

@implementation TransferModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};//前边的是你想用的key，后边的是返回的key
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"coinEntityList" : @"TransferCoinModel",
             @"coinFroms" : @"TransferCoinModel",
             @"coinTos" : @"TransferCoinModel"};//前边，是属性数组的名字，后边就是类名
}

- (NSInteger)itemType // 根据不同交易类型 区分界面显示
{
    //type 2 交易流水 type 16 合约资产交易流水 type 19  合约返回 100 token交易流水
//    if (self.type && self.type != 2 && self.type != 16 && self.type != 19) {
//        if(self.type==100){
//            return 2;//token交易类型
//        }
//        return 1;
//    }
//    return 0;
    
    if (self.type == 2) { // 转账交易
        return 0;
    }else if (self.type == 16 || self.type == 19 || self.type == 26){ // token和跨链
        return 1;
    }else{ // dapp
        return 2;
    }
}

@end

@implementation FeeModel

@end
