//
//  AssetManageTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/4.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "AssetManageTableViewCell.h"

@implementation AssetManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.logoImageView setCircle];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAssetModel:(AssetListResModel *)assetModel{
    [self.logoImageView sd_setImageWithURL:KURL(AliyunImageUrl(assetModel.symbol)) placeholderImage:ImageNamed(@"default_pic")];
    NSString *appendRegisterChain = [NSString stringWithFormat:@"(%@)",assetModel.registerChain];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",assetModel.symbol,assetModel.registerChain ? appendRegisterChain : @""];
    [self.addressButton setTitle:assetModel.contractAddress? assetModel.contractAddress :@"- -" forState:UIControlStateNormal];
    NSString *handleImageName;
    if (assetModel.configType == 1 || assetModel.configType == 2) {
        handleImageName = @"disabled_asset";
    }else if(assetModel.noFollowed){
        handleImageName = @"add_asset";
    }else{
         handleImageName = @"delete_asset";
    }
    [self.handleButton setImage:ImageNamed(handleImageName) forState:UIControlStateNormal];
}

- (IBAction)handleButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetManageButtonClickIndex:)]) {
        [self.delegate assetManageButtonClickIndex:self.index];
    }
}

@end
