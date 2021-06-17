//
//  WalletCardTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "WalletCardTableViewCell.h"

@interface WalletCardTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *skinImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalAssetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *assetsNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *addressButton;
@property (strong, nonatomic) IBOutlet UIButton *qrcodeButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIImageView *bottomImageView;

@end

@implementation WalletCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.moreButton.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(12, self.moreButton.frame.size.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.moreButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.moreButton.layer.mask = maskLayer;
    
    self.bgView.layer.cornerRadius = 6.f;
    self.bgView.layer.masksToBounds = NO;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0.f, -0.5f);
    self.bgView.layer.shadowOpacity = 0.4f;
    self.bgView.layer.shadowRadius = 1.0f;
    
    self.totalAssetsLabel.text = KLocalizedString(@"total_assets");
    self.backgroundColor = kColorBackground;
}

- (void)setIsManageCard:(BOOL)isManageCard
{
    _isManageCard = isManageCard;
    if (isManageCard) {
        self.moreButton.hidden = YES;
        self.bottomImageView.hidden = YES;
    }
}

- (void)setHidenQRCode:(BOOL)hidenQRCode
{
    _hidenQRCode = hidenQRCode;
    self.qrcodeButton.hidden = hidenQRCode;
}

- (void)setWalletModel:(WalletModel *)walletModel
{
    _walletModel = walletModel;
    NSString *imageName = [Common getWalletDataWithType:1 index:walletModel.colorIndex.integerValue];
    self.skinImageView.image = ImageNamed(imageName);
    
    self.titleLabel.attributedText = [self addCharShadoWith:walletModel.alias];

    
    [self.addressButton setTitle:walletModel.address forState:UIControlStateNormal];
    self.addressButton.titleLabel.layer.shadowColor = KSetHEXColorWithAlpha(0x000000,0.1).CGColor;
    self.addressButton.titleLabel.layer.shadowRadius = 5;
    self.addressButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 2);
    
    
//    self.assetsNumLabel.text = [NSString stringWithFormat:@"$%f",walletModel.totalBalance];
    self.assetsNumLabel.attributedText = [self addCharShadoWith:[[GlobalVariable sharedInstance] getAssetsAmountWithNum:@(walletModel.totalBalance) andDecimals:2]];
}

- (IBAction)moreButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMoreWalletAction)]) {
        [self.delegate showMoreWalletAction];
    }
}

- (IBAction)qrcodeButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(walletCardDidSelect:index:)]) {
        [self.delegate walletCardDidSelect:1 index:self.selectIdex];
    }
}


- (IBAction)addressButtonClick:(id)sender {
    [KAppDelegate.window showNormalToast:KLocalizedString(@"copy_to_clipboard")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.walletModel.address;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(walletCardDidSelect:)]) {
//        [self.delegate walletCardDidSelect:0];
//    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSAttributedString *)addCharShadoWith:(NSString *)title{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 5;//阴影半径，默认值3
    shadow.shadowColor = KSetHEXColorWithAlpha(0x000000,0.1);
    shadow.shadowOffset = CGSizeMake(0, 2);
    NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:title attributes:@{NSShadowAttributeName:shadow}];
    return attributedText;
}

@end
