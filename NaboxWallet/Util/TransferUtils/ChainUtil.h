//
//  ChainUtil.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/18.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChainUtil : NSObject

/** NULS链 */
+(BOOL)isNuls:(NSString *)chain;
/** NERVE链*/
+(BOOL)isNerve:(NSString *)chain;
/** NULS系生态链 NULS NERVE*/
+(BOOL)isNulsSeries:(NSString *)chain;
/** 异构链 */
+(BOOL)isHeterChain:(NSString *)chain;

/** 根据地址获取网络链 NULS NERVE HETER */
+(NSString *)ChainFromAddress:(NSString *)address;
/** NULS地址 */
+(BOOL)isNulsAddress:(NSString *)address;
/** NERVE地址*/
+(BOOL)isNerveAddress:(NSString *)address;
/** 异构链地址 */
+(BOOL)isHeterAddress:(NSString *)address;

/** 划转时候 根据fromChain和toChain判断是否存在2次交易 */
+(BOOL)needComposeHashFromChain:(NSString *)fromChain andToChain:(NSString *)toChain;

/** 交易时验证地址合法性 **/
+(BOOL)isCorrectAddress:(NSString *)address withChain:(NSString *)chain;
@end

NS_ASSUME_NONNULL_END
