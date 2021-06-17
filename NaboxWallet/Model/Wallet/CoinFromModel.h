//
//  CoinFromModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinFromModel : BaseModel

/**byte[24] 账户地址 */
@property (nonatomic, strong) NSData *address;
/**uint16 资产发行链的id */
@property (nonatomic, strong) NSNumber *assetsChainId;
/**uint16 资产id */
@property (nonatomic, strong) NSNumber *assetsId;
/**uint128 数量 */
@property (nonatomic, strong) NSNumber *amount;
/**byte[8] */
@property (nonatomic, strong) NSData *nonce;
/**0普通交易，-1解锁金额交易（退出共识，退出委托） */
@property (nonatomic, strong) NSData *locked;

@end

NS_ASSUME_NONNULL_END
