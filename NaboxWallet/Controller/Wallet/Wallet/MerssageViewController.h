//
//  MerssageViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MerssageViewController : BaseViewController
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *txHex;
@property (nonatomic) NSString *contractAddress;
@property (nonatomic) NSString *coinType;
@end

NS_ASSUME_NONNULL_END
