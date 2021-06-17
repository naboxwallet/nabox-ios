//
//  GlobalVariable.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "GlobalVariable.h"

@implementation GlobalVariable

//单例
+ (instancetype)sharedInstance
{
    static GlobalVariable *_globalVar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _globalVar = [[GlobalVariable alloc] init];
    });
    return _globalVar;
}

/** 传入资产余额根据货币类型及汇率得出相应结果 目前废弃*/
- (NSString *)getAssetsNumWithNum:(double)num
{
    if (num < 0 || num > FLT_MAX) {
        num = 0.f;
    }
    NSString *assetsNumStr = @"0.00";
    NSString *currency = [UserDefaultsUtil getValueWithKey:KEY_CURRENCY];
    if ([currency isEqualToString:@"USD"]) {
        double rate = [GlobalVariable sharedInstance].usdRate.doubleValue;
        assetsNumStr = [NSString stringWithFormat:@"$%.2lf",num * rate];
    }else if ([currency isEqualToString:@"RMB"]){
        double rate = [GlobalVariable sharedInstance].cnyRate.doubleValue;
        assetsNumStr = [NSString stringWithFormat:@"¥%.2lf",num * rate];
    }
    return assetsNumStr;
}

/** 传入美元根据货币类型及汇率得出相应结果 */
- (NSString *)getAssetsAmountWithNum:(NSNumber *)num
{
    NSString *assetsNumStr = @"0.00";
    NSString *currency = [UserDefaultsUtil getValueWithKey:KEY_CURRENCY];
    if ([currency isEqualToString:@"USD"]) {
        assetsNumStr = [NSString stringWithFormat:@"$%@",num];
    }else if ([currency isEqualToString:@"RMB"]){
        double rate = [GlobalVariable sharedInstance].cnyRate.doubleValue;
        assetsNumStr = [NSString stringWithFormat:@"¥%.2lf",[num doubleValue]  / rate];
    }
    return assetsNumStr;
}


/** 传入美元根据货币类型及汇率 包含小数点得出相应结果 */
- (NSString *)getAssetsAmountWithNum:(NSNumber *)num andDecimals:(int)decimals
{
    NSDecimalNumber * inputNumber = [[NSDecimalNumber alloc]initWithString:[NSString stringWithFormat:@"%@",num]];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:decimals
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber * number = [inputNumber decimalNumberByRoundingAccordingToBehavior: roundUp];
    NSString *assetsNumStr = @"0.00";
    NSString *currency = [UserDefaultsUtil getValueWithKey:KEY_CURRENCY];
    if ([currency isEqualToString:@"USD"]) {
        assetsNumStr = [NSString stringWithFormat:@"$%@",number];
    }else if ([currency isEqualToString:@"RMB"]){
        double rate = [GlobalVariable sharedInstance].cnyRate.doubleValue || 6; //没有则默认6
        assetsNumStr = [NSString stringWithFormat:@"¥%.2lf",[num doubleValue]  / rate];
    }
    return assetsNumStr;
}

- (ConfigInfoModel *)getChainConfigWithChain:(NSString *)chain{
    ConfigInfoModel *model = [ConfigInfoModel new];
    for (int i = 0; i < self.configList.count; i++) {
        ConfigInfoModel * temp = self.configList[i];
        if ([temp.chain isEqualToString:chain]) {
            model = temp;
            break;
        }
    }
    return model;
}

- (ConfigMainAssetModel *)getMainAssetWithChain:(NSString *)chain{
    ConfigMainAssetModel *resModel;
    for (int i = 0; i < self.configList.count; i++) {
        ConfigInfoModel *model = self.configList[i];
        if ([model.chain isEqualToString:chain]) {
            resModel = model.mainAsset;
            break;
        }
    }
    return resModel;
}
@end
