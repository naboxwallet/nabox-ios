//
//  CoinToModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinToModel : BaseModel

/**byte[24] 账户地址 */
@property (nonatomic, strong) NSData *address;
/**uint16 资产发行链的id */
@property (nonatomic, strong) NSNumber *assetsChainId;
/**uint16 资产id */
@property (nonatomic, strong) NSNumber *assetsId;
/**uint128 数量 */
@property (nonatomic, strong) NSNumber *amount;
/**默认0 */
@property (nonatomic, strong) NSNumber *lockTime;

@end

NS_ASSUME_NONNULL_END
