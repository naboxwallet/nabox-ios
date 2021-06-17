//
//  MessageModeTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgListModel.h"
#define KMessageModeTableViewCellID     @"MessageModeTableViewCell"

NS_ASSUME_NONNULL_BEGIN

@interface MessageModeTableViewCell : UITableViewCell
@property (nonatomic ,strong) UserMsgSubArrayModel *msgModel;
@end

NS_ASSUME_NONNULL_END
