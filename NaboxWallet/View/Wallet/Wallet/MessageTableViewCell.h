//
//  MessageTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgListModel.h"
#define KMessageTableViewCellID     @"MessageTableViewCell"

NS_ASSUME_NONNULL_BEGIN

@interface MessageTableViewCell : UITableViewCell
@property (nonatomic, assign) MessgeMode messageMode;
@property (nonatomic ,strong) MsgListModel *sysMsgCountModel;
@property (nonatomic ,strong) MsgListModel *agentMsgCountModel;
@property (nonatomic ,strong) UserMsgSubArrayModel *userMsgModel;

@end

NS_ASSUME_NONNULL_END
