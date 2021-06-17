//
//  FeeLevelSelectView.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/4.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FeeLevelSelectViewDelegate <NSObject>

@optional
/** 手续费级别选择回调 */
- (void)feeLevelDidSelect:(NSInteger)index feeValue:(NSString *)feeValue;

@end

/** 手续费级别选择回调 */
typedef void(^FeeSelectBlock)(NSInteger index, NSString *feeValue);

@interface FeeLevelSelectView : UIView

@property (nonatomic, copy) NSArray <NSString *> *feeArr;//手续费数组
@property (nonatomic, copy) FeeSelectBlock feeBlock;
@property (nonatomic, weak) id<FeeLevelSelectViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
