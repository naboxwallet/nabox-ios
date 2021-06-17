//
//  SelectWalletTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "SelectWalletTableViewCell.h"

@interface SelectWalletTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLable;
@property (strong, nonatomic) IBOutlet UILabel *assetsNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *addressButton;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation SelectWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(6, self.bgView.frame.size.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
    self.totalLable.text = KLocalizedString(@"total_assets");
}

- (void)setWalletModel:(WalletModel *)walletModel
{
    _walletModel = walletModel;
    self.titleLabel.text = walletModel.alias;
    [self.addressButton setTitle:walletModel.address forState:UIControlStateNormal];
    self.bgView.backgroundColor = [Common getWalletDataWithType:3 index:walletModel.colorIndex.integerValue];
    NSString *address = [UserDefaultsUtil getNowWallet][@"address"];
    self.selectButton.hidden = ![address isEqualToString:walletModel.address];
    self.assetsNumLabel.text = [[GlobalVariable sharedInstance] getAssetsNumWithNum:walletModel.totalBalance];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
