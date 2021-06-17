//
//  CommonWebViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonWebViewController : BaseViewController

@property (nonatomic, assign) DocumentType docType;
@property (nonatomic ,strong) NSString *docCode;
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong) NSString *extendUrl; // 额外的url 用于系统消息参数拼接
@end

NS_ASSUME_NONNULL_END
