//
//  GasPriceModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/3/11.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GasPriceModel : BaseModel
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong) NSString *chain;

@end

NS_ASSUME_NONNULL_END
