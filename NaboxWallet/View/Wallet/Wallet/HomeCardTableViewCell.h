//
//  WalletCardTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KHomeCardTableViewCellID     @"HomeCardTableViewCell"
#define KHomeCardTableViewCellHeight 210

NS_ASSUME_NONNULL_BEGIN

@protocol HomeCardTableViewCellDelegate <NSObject>
@optional
/**
 tag:0~收款二维码 1~本链转账 2~跨链转账 3钱包详情
 index:下标
 */
- (void)walletCardDidSelect:(NSInteger)tag index:(NSInteger)index;

@end

@interface HomeCardTableViewCell : UITableViewCell
@property (nonatomic, weak) id<HomeCardTableViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger selectIdex;
@property (nonatomic ,assign) BOOL hidenQRCode;
@property (nonatomic, strong) WalletModel *walletModel;

@property (nonatomic, strong) NSNumber* asset;
@end

NS_ASSUME_NONNULL_END
