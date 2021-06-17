//
//  HomeChainsViewCell.m
//  NaboxWallet
//
//  Created by Admin on 2020/11/28.
//  Copyright © 2020 NaboxWallet. All rights reserved.
//

#import "HomeChainsViewCell.h"
@interface HomeChainsViewCell()
@property (nonatomic,strong)NSMutableArray *buttonArray;
@end

@implementation HomeChainsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

- (void)creatView
{
    self.contentView.backgroundColor = KColorBg;
    self.buttonArray = [NSMutableArray array];
    NSArray *titleArr= @[@"NULS",@"NERVE",@"Ethereum",@"BSC",@"Heco"];
    NSInteger lineNum = 5;
    NSInteger space = 15;
    NSInteger lineSpace = 16;
    CGFloat height = 40;
    CGFloat itemWidth = (KSCREEN_WIDTH - space * (lineNum + 1)) / lineNum;
    for (int i = 0; i < titleArr.count; i ++) {
        NSString *title = titleArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setCircleWithRadius:2];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:KColorDarkGray forState:UIControlStateNormal];
        [button setTitleColor:KColorWhite forState:UIControlStateSelected];
        [button setBackgroundColor:KColorGray4 forState:UIControlStateNormal];
        [button setBackgroundColor:KColorPrimary forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        button.contentEdgeInsets = UIEdgeInsetsMake(0,1, 0, 1);
        button.tag = i;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setCircleWithRadius:4];
        [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
       
        [self.buttonArray addObject:button];
        CGFloat offictX = (i % lineNum + 1) * (space + itemWidth) - itemWidth;
        CGFloat offictY = (i / lineNum) * (lineSpace + height) + lineSpace;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(offictX);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(height);
            make.top.equalTo(self.contentView).offset(offictY);
        }];
    }
}

- (void)itemButtonClick:(UIButton *)sender
{
//    sender.selected = !sender.selected;
    if (self.delegate) {
        NSString *chain=sender.titleLabel.text;
//        if ([chain isEqualToString:@"ETH"]) {
//            chain = @"Ethereum";
//        }
        [self.delegate homeChainsViewCellDidSelected: chain];
    }
}

- (void)setWalletModel:(WalletModel *)walletModel{
    _walletModel = walletModel;
    for (int i = 0; i < self.buttonArray.count; i++) {
            UIButton *btn = self.buttonArray[i];
            if ([btn.titleLabel.text isEqualToString:walletModel.chain]) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
//                if ([walletModel.chain isEqualToString:@"Ethereum"] && [btn.titleLabel.text isEqualToString:@"ETH"]) {
//                    btn.selected = YES;
//                }else{
//
//                }
            }
    }
}
@end
