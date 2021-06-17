//
//  AssetsDetalsTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AssetInfoModel.h"
#define KAssetsDetalsTableViewCellID     @"AssetsDetalsTableViewCell"
#define KAssetsDetalsTableViewCellHeight 300


NS_ASSUME_NONNULL_BEGIN

@interface AssetsDetalsTableViewCell : UITableViewCell


@property (nonatomic ,strong) AssetListResModel *assetModel;
@end

NS_ASSUME_NONNULL_END
