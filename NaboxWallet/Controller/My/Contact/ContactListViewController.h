//
//  ContactListViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectContractBlock)(ContactsModel *model);

@interface ContactListViewController : BaseViewController

@property (nonatomic, copy) SelectContractBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
