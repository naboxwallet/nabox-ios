//
//  AccountChainListViewChainCell.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/5.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletChainModel.h"
NS_ASSUME_NONNULL_BEGIN
#define KAccountChainListViewChainCellID     @"AccountChainListViewChainCell"
#define KAccountChainListViewChainCellHeight 63
@interface AccountChainListViewChainCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *chainLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UIView *selectedView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *shadowView;

@property (nonatomic ,strong)WalletChainModel *walletChainModel;

@end

NS_ASSUME_NONNULL_END
