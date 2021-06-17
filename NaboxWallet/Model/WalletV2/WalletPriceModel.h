//
//  WalletPriceModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/1/30.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletPriceModel : BaseModel
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong) NSString *pubKey;
@end

NS_ASSUME_NONNULL_END
