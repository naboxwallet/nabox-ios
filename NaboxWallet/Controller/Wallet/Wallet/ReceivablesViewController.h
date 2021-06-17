//
//  ReceivablesViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReceivablesViewController : BaseViewController
@property (nonatomic, copy) NSString *addressStr;
@property (nonatomic, copy) NSString *chain;
@end

NS_ASSUME_NONNULL_END
