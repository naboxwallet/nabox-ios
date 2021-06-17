//
//  NaboxPayWalletView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommonListView;
//tag:0~返回，1~取消，2~选择钱包
typedef void(^CommonListViewSelectBlock)(NSString * _Nullable name,NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface CommonListView : UIView
@property (nonatomic, copy) CommonListViewSelectBlock selectBlock;//回调
@property (nonatomic, strong) NSArray *dataSource;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
