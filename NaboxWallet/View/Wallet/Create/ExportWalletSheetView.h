//
//  ImportWalletSheetView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 tag: 1~keystore,2~助记词，3~私钥
 */
typedef void(^ImportWalletBlock)(NSInteger tag);

@interface ExportWalletSheetView : UIView
@property (nonatomic, copy) ImportWalletBlock importBlock;
@end

NS_ASSUME_NONNULL_END
