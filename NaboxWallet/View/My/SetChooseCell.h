//
//  SetChooseCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define kSetChooseCell @"SetChooseCell"
#define kSetChooseCellHeight 78
@interface SetChooseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipImage;

@end

NS_ASSUME_NONNULL_END
