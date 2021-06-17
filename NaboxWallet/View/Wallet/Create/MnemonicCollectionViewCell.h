//
//  MnemonicCollectionViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KMnemonicCollectionViewCellID      @"MnemonicCollectionViewCell"
#define KMnemonicCollectionViewCellHeight  32
#define KMnemonicCollectionViewCellWidth   80

NS_ASSUME_NONNULL_BEGIN

@interface MnemonicCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *mnemonicLabel;

@end

NS_ASSUME_NONNULL_END
