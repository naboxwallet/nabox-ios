//
//  ChooseAssetsListViewCell.h
//  NaboxWallet
//
//  Created by Admin on 2021/2/27.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define kChooseAssetsListViewCell @"ChooseAssetsListViewCell"
#define kChooseAssetsListViewCellHeight 58
@interface ChooseAssetsListViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *iconNameLabel;

@end

NS_ASSUME_NONNULL_END
