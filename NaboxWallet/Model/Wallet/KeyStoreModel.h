//
//  KeyStoreModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeyStoreModel : BaseModel
/* 地址 */
@property (nonatomic, copy) NSString *address;
/* 加密私钥 */
@property (nonatomic, copy) NSString *encryptedPrivateKey;
/* 钱包别名 */
@property (nonatomic, copy) NSString *alias;
/* 公钥 */
@property (nonatomic, copy) NSString *pubKey;
/* 时间 */
@property (nonatomic, copy) NSString *time;
@end

NS_ASSUME_NONNULL_END
