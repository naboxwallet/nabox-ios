//
//  SyncWalletWithDeviceModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SyncWalletWithDeviceModel : BaseModel
@property (nonatomic ,strong) NSMutableArray *addressList;
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong) NSString *terminal;
@property (nonatomic ,strong) NSString *timeZone;
@property (nonatomic ,strong) NSString *type;

@property (nonatomic ,strong) NSString *pubKey;

@end

NS_ASSUME_NONNULL_END
