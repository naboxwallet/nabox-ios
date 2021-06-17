//
//  AccountChainListView.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/5.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AccountChainListView;
typedef void(^AccountChainListViewSelectBlock)(NSInteger tag, WalletModel * _Nullable walletModel);
@interface AccountChainListView : UIView
@property (nonatomic, copy) AccountChainListViewSelectBlock selectBlock;//回调
@property (nonatomic ,strong)WalletModel * walletModel;
@end

NS_ASSUME_NONNULL_END
