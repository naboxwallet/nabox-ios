//
//  SearchAssetModel.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/16.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchAssetModel : BaseModel
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong)NSString *chain;
@property (nonatomic ,strong)NSString *searchKey;
@end

NS_ASSUME_NONNULL_END
