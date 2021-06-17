//
//  AssetsDetalsBottomView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KAssetsDetalsBottomViewHeight 80

NS_ASSUME_NONNULL_BEGIN
/** type:0~收款，1~转账 */
typedef void(^TradingBlock)(NSInteger type);

@interface AssetsDetalsBottomView : UIView
@property (strong, nonatomic) IBOutlet UIButton *receivablesButton;
@property (strong, nonatomic) IBOutlet UIButton *transferButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;

@property (nonatomic, copy) TradingBlock tradingBlock;
@end

NS_ASSUME_NONNULL_END
