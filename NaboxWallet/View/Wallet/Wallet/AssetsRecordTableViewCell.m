//
//  AssetsRecordTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "AssetsRecordTableViewCell.h"

@interface AssetsRecordTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *modeButton;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modeButtonWithConstant;
@property (strong, nonatomic) IBOutlet UILabel *fromAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *toAddressLabel;

@end

@implementation AssetsRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if([[LanguageUtil getUserLanguageStr] isEqualToString:@"EN"]){
        self.modeButtonWithConstant.constant = 68;
        self.modeButton.width = 68;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.modeButton.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(12, self.modeButton.frame.size.height)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.modeButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.modeButton.layer.mask = maskLayer;
    [self.bgView setCircleAndShadowWithRadius:6];
}
//0: "跨链交易本链未确认",
//1: "跨链交易本链已确认",
//2: "跨链交易NERVE链已广播交易待确认",
//3: "跨链交易NERVE链广播失败",
//4: "跨链交易目标链已确认",
//5: "跨链交易失败",
- (void)setTransModel:(TradeListModel *)transModel
{
    self.statusLabel.hidden = YES;
    
    NSString *change = @"";
    if (transModel.transType  > 0 ) { // 收入
        self.totalLabel.textColor = KColorSkin1;
        change = @"+";
    }else { // 支出
         self.totalLabel.textColor = KColorOrange;
         change = @"-";
    }
    
    if ([transModel.status isEqualToString:@"1"]) {
         self.modeButton.backgroundColor = KColorSkin1;
    }else {
        self.modeButton.backgroundColor = KColorOrange;
    }
    NSString *statusType = [NSString stringWithFormat:@"statusType_%@",transModel.status];
    [self.modeButton setTitle:KLocalizedString(statusType) forState:UIControlStateNormal];
    self.totalLabel.text = [Common formatValueWithValue:transModel.amount andDecimal:transModel.decimals];
    self.fromAddressLabel.text = transModel.froms ? transModel.froms :@"--";
    self.toAddressLabel.text = transModel.tos ? transModel.tos :@"--";
    self.timeLabel.text = transModel.createTime;
    self.infoLabel.text = transModel.symbol;
}

- (void)setRecordType:(AssetsRecordType)recordType
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
