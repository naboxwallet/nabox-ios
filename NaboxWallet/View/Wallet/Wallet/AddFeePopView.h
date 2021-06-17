//
//  WalletNamePopView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddFeePopView;

NS_ASSUME_NONNULL_BEGIN

/** type:0~取消，1~确定 */
typedef void(^AddFeeBlock)(AddFeePopView *nameView, NSString *name);

@interface AddFeePopView : UIView
@property (nonatomic, copy) NSString *oldName;
@property (nonatomic, copy) AddFeeBlock nameBlock;
@end

NS_ASSUME_NONNULL_END
