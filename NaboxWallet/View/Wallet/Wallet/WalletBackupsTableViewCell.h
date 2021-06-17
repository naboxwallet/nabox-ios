//
//  WalletBackupsTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWalletBackupsTableViewCellID     @"WalletBackupsTableViewCell"
#define KWalletBackupsTableViewCellHeight 185
#define KWalletBackupsTableViewItemHeight 58

NS_ASSUME_NONNULL_BEGIN

@protocol WalletBackupsTableViewCellDelegate <NSObject>

/**
 type:0~备份助记词，1~备份私钥，2~备份keystore
 */
- (void)walletBackupsDidSelect:(NSInteger)type;

@end

@interface WalletBackupsTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL showMnemonic;//是否显示助记词
@property (nonatomic, weak) id<WalletBackupsTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
