//
//  TransferChainSelectView.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/14.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferChainSelectCCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) BOOL isSelected;
@end


@protocol TransferChainSelectViewDelegate <NSObject>

@optional
/** 选择网络回调 */
- (void)transferChainSelect:(NSString *)chain;

@end

typedef void(^TransferChainBlock)(NSString *chain);

/** 网络选择 */
@interface TransferChainSelectView : UIView

@property (nonatomic, copy) NSArray *chainArr;

@property (nonatomic, copy) TransferChainBlock selectChainBlock;
@property (nonatomic, weak) id<TransferChainSelectViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
