//
//  WalletCardTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWalletCardTableViewCellID     @"WalletCardTableViewCell"
#define KWalletCardTableViewCellHeight 215

NS_ASSUME_NONNULL_BEGIN

@protocol WalletCardTableViewCellDelegate <NSObject>
@optional
//查看更多钱包
- (void)showMoreWalletAction;
/**
 tag:0~复制地址，1~收款二维码
 index:下标
 */
- (void)walletCardDidSelect:(NSInteger)tag index:(NSInteger)index;

@end

@interface WalletCardTableViewCell : UITableViewCell
@property (nonatomic, weak) id<WalletCardTableViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger selectIdex;
@property (nonatomic, assign) BOOL isManageCard;
@property (nonatomic ,assign) BOOL hidenQRCode;
@property (nonatomic, strong) WalletModel *walletModel;
@end

NS_ASSUME_NONNULL_END
