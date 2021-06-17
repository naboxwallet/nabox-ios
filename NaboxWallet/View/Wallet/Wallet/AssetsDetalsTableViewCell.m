//
//  AssetsDetalsTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AssetsDetalsTableViewCell.h"

@interface AssetsDetalsTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *coclorView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *frozenLabel;
@property (strong, nonatomic) IBOutlet UILabel *frozenTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *availableLabel;
@property (strong, nonatomic) IBOutlet UILabel *availableTotalLabel;

@end

@implementation AssetsDetalsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView setCircleAndShadowWithRadius:6];
    self.frozenLabel.text = KLocalizedString(@"Frozen");
    self.availableLabel.text = KLocalizedString(@"available");
    self.coclorView.backgroundColor = KColorPrimary;
}

- (void)setAssetModel:(AssetListResModel *)assetModel{
    self.totalLabel.text = [Common formatValueWithValue:assetModel.total andDecimal:assetModel.decimals];
    self.frozenTotalLabel.text = [Common formatValueWithValue:assetModel.locked  andDecimal:assetModel.decimals];
    self.availableTotalLabel.text = [Common formatValueWithValue:assetModel.balance  andDecimal:assetModel.decimals];
    self.aboutTotalLabel.text = [NSString stringWithFormat:@"≈%@",[[GlobalVariable sharedInstance] getAssetsAmountWithNum:assetModel.usdPrice andDecimals:2]];
    self.nameLabel.text = assetModel.symbol;
//     [self.iconImageView sd_setImageWithURL:KURL(assetModel.icon)];
        [self.iconImageView sd_setImageWithURL:KURL(AliyunImageUrl(assetModel.symbol)) placeholderImage:ImageNamed(@"default_pic")];
}
@end
