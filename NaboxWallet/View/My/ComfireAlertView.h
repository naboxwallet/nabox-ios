//
//  ComfireAlertView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComfireAlertView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) PopBlock popBlock;
@end

NS_ASSUME_NONNULL_END
