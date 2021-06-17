//
//  WalletAssetsTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "HomeAssetsTableViewCell.h"

@interface HomeAssetsTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *nulsImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *assetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *otherAssetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *registerChainLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconTopSpaceConstant;


@end

@implementation HomeAssetsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView setShadowWithOpacity:0.15];
    [self.registerChainLabel setborderWithBorderColor:KColorSkin1 Width:1];
    [self.registerChainLabel setCircleWithRadius:4];
}

- (CGRect)bgViewFrame
{
    return _bgView.frame;
}


- (void)setAssetModel:(AssetListResModel *)assetModel{
    [_nulsImageView sd_setImageWithURL:KURL(AliyunImageUrl(assetModel.symbol)) placeholderImage:ImageNamed(@"default_pic")];
    _nameLabel.text = assetModel.symbol;
    _assetsLabel.text = [Common formatValueWithValue:assetModel.total andDecimal:assetModel.decimals];
    _otherAssetsLabel.text = [NSString stringWithFormat:@"≈%@",[[GlobalVariable sharedInstance] getAssetsAmountWithNum:assetModel.usdPrice andDecimals:2]];
    if (assetModel.registerChain && assetModel.registerChain.length >0 && ![assetModel.registerChain isEqualToString:assetModel.chain]) {
        self.registerChainLabel.text = [NSString stringWithFormat:@" %@ ",assetModel.registerChain];
        self.iconTopSpaceConstant.constant = 24;
        self.registerChainLabel.hidden = NO;
    }else{
        self.iconTopSpaceConstant.constant = 35;
        self.registerChainLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
