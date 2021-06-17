//
//  TransferFeeUtil.h
//  NaboxWallet
//
//  Created by Admin on 2021/4/15.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TransferFeeType) {
    TransferFeeTypeIsContractAddress = 1, //合约资产
    TransferFeeTypeIsNVTCroee,            //nerve->异构链
    TransferFeeTypeIsFromIsomerism,       //from链是异构链
};

@protocol TransferFeeUtilDelegate <NSObject>

- (void)transferFeeDidReceiveType:(TransferFeeType)type transferModel:(TransferTempModel *)transferModel;

@end

/** block回调 */
typedef void(^TransferFeeBlock)(TransferFeeType type, TransferTempModel *transferModel);

@interface TransferFeeUtil : NSObject

@property (nonatomic, weak) id<TransferFeeUtilDelegate> delegate;

/**
 快捷获取交易手续费
 @param type               类型
 @param transferModel      交易对象
 */
- (void)getTransferFeeWithType:(TransferFeeType)type
                 transferModel:(TransferTempModel *)transferModel;

- (void)getTransferFeeWithType:(TransferFeeType)type
                 transferModel:(TransferTempModel *)transferModel
              transferFeeBlock:(TransferFeeBlock)transferFeeBlock;

/**
 获取交易手续费
 @param type               类型
 @param transferModel      交易对象
 @param toAddress          接收地址
 @param amount             金额
 */
- (void)getTransferFeeWithType:(TransferFeeType)type
                 transferModel:(TransferTempModel *)transferModel
                     toAddress:(NSString * _Nullable)toAddress
                        amount:(NSString * _Nullable)amount;

- (void)getTransferFeeWithType:(TransferFeeType)type
                 transferModel:(TransferTempModel *)transferModel
                     toAddress:(NSString * _Nullable)toAddress
                        amount:(NSString * _Nullable)amount
              transferFeeBlock:(TransferFeeBlock _Nullable)transferFeeBlock;

@end

NS_ASSUME_NONNULL_END
