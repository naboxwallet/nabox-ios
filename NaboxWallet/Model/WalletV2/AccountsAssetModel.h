//
//  AccountsAssetModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/3/27.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountsAssetModel : BaseModel
@property (nonatomic ,strong) NSArray *pubKeyList;
@property (nonatomic ,strong) NSString *language;

@end

@interface AccountAssetInfoModel : NSObject
@property (nonatomic ,strong) NSNumber *price;
@property (nonatomic ,strong) NSString *chain;
@end

NS_ASSUME_NONNULL_END
