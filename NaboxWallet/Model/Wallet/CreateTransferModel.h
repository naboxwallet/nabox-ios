//
//  CreateTransferModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateTransferModel : BaseModel

@property (nonatomic, copy) NSString *txSerializeHex;
@property (nonatomic, copy) NSString *contractAddress;
@property (nonatomic, copy) NSString *partnerId;

@end

NS_ASSUME_NONNULL_END
