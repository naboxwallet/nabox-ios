//
//  ZxingModel.h
//  NaboxWallet
//
//  Created by nuls on 2019/11/19.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZxingModel : BaseModel


@property(nonatomic,copy) NSString  *address;

@property(nonatomic,copy) NSString  *coinName;

@property(nonatomic,copy) NSString  *walletAddress;


@end

NS_ASSUME_NONNULL_END
