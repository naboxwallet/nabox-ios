//
//  CoinDataModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"
#import "CoinFromModel.h"
#import "CoinToModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinDataModel : BaseModel

@property (nonatomic, strong) NSArray *from;
@property (nonatomic, strong) NSArray *to;

@end

NS_ASSUME_NONNULL_END
