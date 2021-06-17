//
//  AssetsRecordTableViewCell.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeListModel.h"

#define KAssetsRecordTableViewCellID     @"AssetsRecordTableViewCell"
#define KAssetsRecordTableViewCellHeight 100

typedef enum : NSUInteger {
    AssetsRecordTypeNormal = 0,
    AssetsRecordTypeIcon=1,
     AssetsRecordTypeToken=2,
} AssetsRecordType;

NS_ASSUME_NONNULL_BEGIN

@interface AssetsRecordTableViewCell : UITableViewCell
@property (nonatomic, assign) AssetsRecordType recordType;
@property (nonatomic, strong) TradeListModel *transModel;
@end

NS_ASSUME_NONNULL_END
