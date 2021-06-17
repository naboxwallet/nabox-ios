//
//  AssetManageSearchHeadView.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/4.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AssetManageSearchHeadViewDelegate <NSObject>
- (void)assetManageSearchChange:(NSString *)keyword;
@end

@interface AssetManageSearchHeadView : UIView
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, assign) CGSize intrinsicContentSize;

@property (nonatomic, weak) id<AssetManageSearchHeadViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
