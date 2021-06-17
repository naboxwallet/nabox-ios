//
//  PartnerModel.h
//  NaboxWallet
//
//  Created by Admin on 2019/11/23.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PartnerModel : BaseModel

/**钱包地址 */
@property (nonatomic, copy) NSString *address;
/** 地址 */
@property (nonatomic, copy) NSString *contractAddress;
/**创建时间 */
@property (nonatomic, copy) NSString *createTime;
/**  */
@property (nonatomic, copy) NSString *decimals;
/**头像地址 */
@property (nonatomic, copy) NSString *iconUrl;
/**名字 */
@property (nonatomic, copy) NSString *name;
/**名字英文 */
@property (nonatomic, copy) NSString *nameEn;
/**  */
@property (nonatomic, copy) NSString *nrcContractAddress;
/**商户id */
@property (nonatomic, copy) NSString *partnerId;
/**  */
@property (nonatomic, copy) NSString *refContractAddress;
/**币种 */
@property (nonatomic, copy) NSString *symbol;
/**修改时间 */
@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
