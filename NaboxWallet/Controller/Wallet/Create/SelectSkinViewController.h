//
//  SelectSkinViewController.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    SelectSkinTypeCreate,//创建方式
    SelectSkinTypeImport,//导入方式
    SelectSkinTypeUpdate,//更新方式
} SelectSkinType;

typedef void(^SelectSkinBlock)(WalletModel *model);

NS_ASSUME_NONNULL_BEGIN

@interface SelectSkinViewController : BaseViewController
@property (nonatomic, strong) WalletModel *walletModel;
@property (nonatomic, assign) SelectSkinType skinType;
@property (nonatomic, copy) SelectSkinBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
