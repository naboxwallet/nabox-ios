//
//  ReadSysMsgModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadSysMsgModel : BaseModel
@property (nonatomic ,strong) NSString *terminal;
//@property (nonatomic ,strong) NSString *msgId;
@property (nonatomic ,strong) NSArray *addressList;
@end

NS_ASSUME_NONNULL_END
