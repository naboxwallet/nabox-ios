//
//  AccountRefreshModel.h
//  NaboxWallet
//
//  Created by 罗洋洋 on 2021/6/1.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountRefreshModel : BaseModel
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong)NSString *pubKey;
@end

NS_ASSUME_NONNULL_END
