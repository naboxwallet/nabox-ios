//
//  MessageModeTableViewCell.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "MessageModeTableViewCell.h"

@interface MessageModeTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIView *remindView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MessageModeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bgView setShadowWithOpacity:0.15];
    [self.remindView setCircle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMsgModel:(UserMsgSubArrayModel *)msgModel{
    _msgModel = msgModel;
//    0未读，1已读
    self.titleLabel.text = msgModel.title;
    self.infoLabel.text = msgModel.summary;
    self.timeLabel.text = [Common datetimeStrFromZoneStr:msgModel.createTime andFormat:@"yyyy-MM-dd"];
    if(msgModel.readState == 0) {
        self.remindView.hidden = NO;
    }else{
        self.remindView.hidden = YES;
    }
}

@end
