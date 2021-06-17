//
//  WalletSkinCollectionViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWalletSkinCollectionViewCellHeight 190
#define KWalletSkinCollectionViewCellID     @"WalletSkinCollectionViewCell"

NS_ASSUME_NONNULL_BEGIN

@interface WalletSkinCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *skinImageView;

@end

NS_ASSUME_NONNULL_END
