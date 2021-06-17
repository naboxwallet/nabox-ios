//
//  SWQRCodeViewController.h
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWQRCode.h"
#import "BaseViewController.h"

typedef void(^ResultBlock)(NSString *result);

@interface SWQRCodeViewController : BaseViewController

@property (nonatomic, copy) ResultBlock resultBlock;
@property (nonatomic, strong) SWQRCodeConfig *codeConfig;

@end
