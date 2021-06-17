//
//  TradingRecordFilterView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryTxListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FilterBlock)(QueryTxListModel *model,NSMutableArray *selectArr);

@interface TradingRecordFilterView : UIView

//用于记录选择状态
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) QueryTxListModel *queryModel;
@property (nonatomic, copy) FilterBlock filterBlock;
@property (nonatomic, assign) NSInteger type;

- (void)showInView;
- (void)hideInView;
@end

NS_ASSUME_NONNULL_END
