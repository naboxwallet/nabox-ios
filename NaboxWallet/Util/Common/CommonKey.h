//
//  CommonKey.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const KEY_CURRENCY;//货币类型
extern NSString *const KEY_WALLET;//钱包
extern NSString *const KEY_NOW_WALLET;//选择的钱包
extern NSString *const KEY_ALL_WALLET;//所有钱包
extern NSString *const KEY_KEYSTORE;//keystore
extern NSString *const KEY_ALL_KEYSTORE;//所有keystore
extern NSString *const KEY_ISJOINED;//指导记录

@interface CommonKey : NSObject

@end

NS_ASSUME_NONNULL_END
