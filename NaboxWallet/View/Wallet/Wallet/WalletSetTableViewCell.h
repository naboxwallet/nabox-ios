//
//  WalletSetTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWalletSetTableViewCellID     @"WalletSetTableViewCell"
#define KWalletSetTableViewCellHeight 125

NS_ASSUME_NONNULL_BEGIN

@protocol WalletSetTableViewCellDelegate <NSObject>

/**
 type:0~钱包名称，1~钱包皮肤
 */
- (void)walletSetDidSelect:(NSInteger)type;

@end

@interface WalletSetTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *nameButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *skinButton;

@property (nonatomic, weak) id<WalletSetTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
