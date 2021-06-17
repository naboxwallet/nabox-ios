//
//  HomeChainsViewCell.h
//  NaboxWallet
//
//  Created by Admin on 2020/11/28.
//  Copyright © 2020 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KHomeChainsViewCellID     @"HomeChainsViewCell"
#define KHomeChainsViewCellHeight 60
NS_ASSUME_NONNULL_BEGIN
@protocol HomeChainsViewCellDelegate <NSObject>
- (void)homeChainsViewCellDidSelected:(NSString *)chain;
@end
@interface HomeChainsViewCell : UITableViewCell
@property (nonatomic,assign) id<HomeChainsViewCellDelegate> delegate;
@property (nonatomic ,strong)WalletModel *walletModel;
@end

NS_ASSUME_NONNULL_END
