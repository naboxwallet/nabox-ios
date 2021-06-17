//
//  BottomButtonView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KBottomButtonViewHeight 120

NS_ASSUME_NONNULL_BEGIN

@protocol BottomButtonViewDelegate <NSObject>

- (void)bottomButtonDidSelect;

@end

@interface BottomButtonView : UIView
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, weak) id<BottomButtonViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
