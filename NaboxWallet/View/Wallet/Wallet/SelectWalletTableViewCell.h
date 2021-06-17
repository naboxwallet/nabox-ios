//
//  SelectWalletTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KSelectWalletTableViewCellID     @"SelectWalletTableViewCell"
#define KSelectWalletTableViewCellHeight 150

NS_ASSUME_NONNULL_BEGIN

@interface SelectWalletTableViewCell : UITableViewCell
@property (nonatomic, strong) WalletModel *walletModel;
@end

NS_ASSUME_NONNULL_END
