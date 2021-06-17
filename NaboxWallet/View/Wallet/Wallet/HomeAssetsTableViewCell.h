//
//  WalletAssetsTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "AssetListModel.h"

#define KHomeAssetsTableViewCellID     @"HomeAssetsTableViewCell"
#define KHomeAssetsTableViewCellHeight 100

NS_ASSUME_NONNULL_BEGIN
@class AssetListResModel;
@interface HomeAssetsTableViewCell : MGSwipeTableCell

@property (nonatomic, assign) CGRect bgViewFrame;
@property (nonatomic ,strong) AssetListResModel *assetModel;

@end

NS_ASSUME_NONNULL_END
