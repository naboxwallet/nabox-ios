//
//  ImportWalletSuccessView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SheetStyleImportWallet, //导入钱包
    SheetStyleTransfer,     //转账
    SheetStyleBackup,       //备份
    SheetStyleCreate,       //创建
    SheetStyleJoinConsensus,//加入共识
    SheetStyleNaboxPay      //Nabox支付
} SheetStyle;

typedef void(^CreateSuccessBlock)(void);
typedef void(^SheetResultBlock)(NSInteger result);

@interface ImportWalletSuccessView : UIView
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, assign) SheetStyle style;//弹出类型，先result之前传值
@property (nonatomic, assign) NSInteger result;//结果，成功与否

@property (nonatomic, copy) SheetResultBlock resultBlock;//操作回调
@property (nonatomic, copy) CreateSuccessBlock successBlock;
@end

NS_ASSUME_NONNULL_END
