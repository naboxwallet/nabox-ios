//
//  ReadUserMsgModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadUserMsgModel : BaseModel
@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,strong) NSString *txHex;
@end

NS_ASSUME_NONNULL_END
