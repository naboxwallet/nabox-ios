//
//  WalletNamePopView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WalletNamePopView;

typedef enum : NSUInteger {
    WalletPopTypeName,
    WalletPopTypePassword,
} WalletPopType;

NS_ASSUME_NONNULL_BEGIN

/** type:0~取消，1~确定 */
typedef void(^WalletNameBlock)(WalletNamePopView *nameView, NSString *name);

@interface WalletNamePopView : UIView
@property (nonatomic, copy) NSString *oldName;
@property (nonatomic, assign) WalletPopType popType;//弹出类型
@property (nonatomic, copy) WalletNameBlock nameBlock;
@end

NS_ASSUME_NONNULL_END
