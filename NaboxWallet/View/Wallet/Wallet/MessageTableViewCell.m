//
//  MessageTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "NSDate+ZHFormatter.h"
@interface MessageTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *instructionButton;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTop;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *remindView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signWidthConstant;

@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView setShadowWithOpacity:0.15];
    [self.countLabel setCircleWithRadius:8];
    [self.remindView setCircle];
}

- (void)setMessageMode:(MessgeMode)messageMode
{
    _messageMode = messageMode;
    if (messageMode == MessgeModeSystem) {
        self.titleLabel.text = KLocalizedString(@"system_message");
        self.iconImageView.image = ImageNamed(@"icon_xiaoxi");
        self.titleLabelTop.constant = 11;
        self.timeLabel.hidden = YES;
        self.infoLabel.hidden = YES;
        self.instructionButton.hidden = YES;
        self.countLabel.hidden = NO;
    }if (messageMode == MessgeModeAgent) {
//        self.titleLabel.text = KLocalizedString(@"system_message");
        self.titleLabel.text = KLocalizedString(@"entrusted_warning");
        self.iconImageView.image = ImageNamed(@"icon_system_warn");
        self.titleLabelTop.constant = 11;
        self.timeLabel.hidden = YES;
        self.infoLabel.hidden = YES;
        self.instructionButton.hidden = NO;
        self.countLabel.hidden = NO;
    }else if (messageMode == MessgeModeOther) {
        self.titleLabelTop.constant = 0;
        self.timeLabel.hidden = NO;
        self.infoLabel.hidden = NO;
        self.instructionButton.hidden = YES;
        self.countLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSysMsgCountModel:(MsgListModel *)sysMsgCountModel{
    self.remindView.hidden = YES;
    NSInteger count = sysMsgCountModel.count;
        if (count) {
            self.countLabel.hidden = NO;
            NSString *countStr = [NSString stringWithFormat:@"%@",count>99?@"99+":@(count)];
            DLog(@"%lf",[self SG_widthWithString:countStr font:kSetSystemFontOfSize(12)]);
            if (countStr.length == 1) {
//                self.signWidthConstant.constant = 14;
            }else if (countStr.length == 2){
                self.signWidthConstant.constant = 20;
            }else{
                self.signWidthConstant.constant = 25;
            }
            self.countLabel.text = countStr;
        }else{
            self.countLabel.hidden = YES;
        }
//        self.countLabel.text = [NSString stringWithFormat:@"%ld",sysMsgCountModel.count];
//        self.countLabel.hidden = NO;
    
}

- (void)setAgentMsgCountModel:(MsgListModel *)agentMsgCountModel{
    self.remindView.hidden = YES;
    NSInteger count = agentMsgCountModel.yellowCount+agentMsgCountModel.redCount;
    if (count) {
        self.countLabel.hidden = NO;
        NSString *countStr = [NSString stringWithFormat:@"%@",count>99?@"99+":@(count)];
//        DLog(@"%lf",[self SG_widthWithString:countStr font:kSetSystemFontOfSize(12)]);
        if (countStr.length == 1) {
//            self.signWidthConstant.constant = 14;
        }else if (countStr.length == 2){
            self.signWidthConstant.constant = 20;
        }else{
            self.signWidthConstant.constant = 25;
        }
        self.countLabel.text = countStr;
    }else{
        self.countLabel.hidden = YES;
    }
    
    if (agentMsgCountModel.redCount>0) {
        self.instructionButton.hidden = NO;
        [self.instructionButton setImage:ImageNamed(@"icon_red") forState:UIControlStateNormal];

    }else if (agentMsgCountModel.yellowCount>0){
        self.instructionButton.hidden = NO;
         [self.instructionButton setImage:ImageNamed(@"icon_yellow") forState:UIControlStateNormal];
    }else{
        self.instructionButton.hidden = YES;
    }
}

- (void)setUserMsgModel:(UserMsgSubArrayModel *)userMsgModel{
    
    if ([userMsgModel.docCode isEqualToString:@"TRANSFER"]) {
        self.iconImageView.image = ImageNamed(@"icon_transaction_out");
    }else if ([userMsgModel.docCode isEqualToString:@"RECEIPT"]) {
         self.iconImageView.image = ImageNamed(@"icon_transcation_in");
    }else if ([userMsgModel.docCode isEqualToString:@"TRANSFER_FAIL"]) {
         self.iconImageView.image = ImageNamed(@"icon_tingzhi");
    }else if([userMsgModel.docCode isEqualToString:@"YELLOW_WARNING_CERATE"]){
        self.iconImageView.image = ImageNamed(@"icon_huangpai");
    }else if([userMsgModel.docCode isEqualToString:@"YELLOW_WARNING_DEPOSIT"]){
        self.iconImageView.image = ImageNamed(@"icon_huangpai");
    }else if([userMsgModel.docCode isEqualToString:@"YELLOW_WARNING"]){
        self.iconImageView.image = ImageNamed(@"icon_huangpai");
    }else if([userMsgModel.docCode isEqualToString:@"RED_STOP"]){
         self.iconImageView.image = ImageNamed(@"icon_tingzhi");
    }else if([userMsgModel.docCode isEqualToString:@"RED_STOP_CREATE"]){
        self.iconImageView.image = ImageNamed(@"icon_tingzhi");
    }else if([userMsgModel.docCode isEqualToString:@"RED_STOP_DEPOSIT"]){
        self.iconImageView.image = ImageNamed(@"icon_tingzhi");
    }else if([userMsgModel.docCode isEqualToString:@"PARTNER_RECEIPT"]){
        if(userMsgModel.iconUrl!=nil){
             [self.iconImageView sd_setImageWithURL:KURL(userMsgModel.iconUrl)];
        }else{
            self.iconImageView.image = ImageNamed(@"icon_transcation_in");
        }
    }else if([userMsgModel.docCode isEqualToString:@"PARTNER_TRANSFER"]){
        if(userMsgModel.iconUrl!=nil){
            [self.iconImageView sd_setImageWithURL:KURL(userMsgModel.iconUrl)];
        }else{
             self.iconImageView.image = ImageNamed(@"icon_transaction_out");
        }
    }else if([userMsgModel.docCode isEqualToString:@"PARTNER_TRANSFER_FAIL"]){
        if(userMsgModel.iconUrl!=nil){
            [self.iconImageView sd_setImageWithURL:KURL(userMsgModel.iconUrl)];
        }else{
            self.iconImageView.image = ImageNamed(@"icon_tingzhi");
        }
    }
    
    self.timeLabel.text = [Common datetimeStrFromZoneStr:userMsgModel.createTime andFormat:@"MM-dd HH:mm"];
    self.infoLabel.text = userMsgModel.summary;
    self.titleLabel.text = userMsgModel.title;
    if(userMsgModel.readState == 0) {
        self.remindView.hidden = NO;
    }else{
        self.remindView.hidden = YES;
    }
}


- (CGFloat)SG_widthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}



@end
