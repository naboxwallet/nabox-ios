//
//  AccountChainListViewAccountCell.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/5.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define KAccountChainListViewAccountCellID     @"AccountChainListViewAccountCell"
#define KAccountChainListViewAccountCellHeight 88
@interface AccountChainListViewAccountCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountBalanceLable;

@property (nonatomic ,strong)WalletModel *walletModel;
@end

NS_ASSUME_NONNULL_END
