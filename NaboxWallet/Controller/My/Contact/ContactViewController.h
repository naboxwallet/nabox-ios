//
//  ContactViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CompleteBlock)(void);
@interface ContactViewController : BaseViewController
@property (nonatomic, copy) CompleteBlock block;
@property (nonatomic, copy) NSString *toAddress;



@end

NS_ASSUME_NONNULL_END
