//
//  NaboxPayWalletView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseAssetsListView;
//tag:0~返回，1~取消，2~选择钱包
typedef void(^ChooseAssetssListViewSelectBlock)(NSString * _Nullable chainName,NSString * _Nullable iconName);

NS_ASSUME_NONNULL_BEGIN

@interface ChooseAssetsListView : UIView
@property (nonatomic, copy) ChooseAssetssListViewSelectBlock selectBlock;//回调

@end

NS_ASSUME_NONNULL_END
