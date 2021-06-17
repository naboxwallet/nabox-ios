//
//  SelectWalletView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ManageBlock)(void);
typedef void(^SelectWalletBlock)(WalletModel *selectModel);

@interface SelectWalletView : UIView

@property (nonatomic, copy) ManageBlock manageBlock;
@property (nonatomic, copy) SelectWalletBlock selectBlock;

- (void)showInView;
- (void)hideInView;
@end

NS_ASSUME_NONNULL_END
