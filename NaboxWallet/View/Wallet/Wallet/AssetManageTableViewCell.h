//
//  AssetManageTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/4.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AssetManageTableViewCellDelegate <NSObject>
@optional

- (void)assetManageButtonClickIndex:(NSInteger)index;

@end

@interface AssetManageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *addressButton;
@property (strong, nonatomic) IBOutlet UIButton *handleButton;

@property (nonatomic, strong)AssetListResModel *assetModel;
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic, weak) id<AssetManageTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
