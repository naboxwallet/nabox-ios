//
//  WalletChainModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/2/28.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletChainModel : NSObject
@property (nonatomic,strong) NSString *chain;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSNumber *price;
@property (nonatomic ,strong) NSNumber *rate;
@property (nonatomic,strong) NSString *address;
@end

NS_ASSUME_NONNULL_END
