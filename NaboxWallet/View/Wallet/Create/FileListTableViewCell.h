//
//  FileListTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KFileListTableViewCellID     @"FileListTableViewCell"
#define KFileListTableViewCellHeight 85

NS_ASSUME_NONNULL_BEGIN

@interface FileListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tiemLabel;

@end

NS_ASSUME_NONNULL_END
