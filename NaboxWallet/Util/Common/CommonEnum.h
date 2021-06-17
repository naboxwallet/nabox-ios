//
//  CommonEnum.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 语言类型 */
typedef enum : NSUInteger {
    LANGUAGETYPEZHHANS, //简体中文
//    LANGUAGETYPEZHHANT, //繁体中文
    LANGUAGETYPEEN,     //英文
} LANGUAGETYPE;
//获取当前系统语言
extern LANGUAGETYPE GetLocalPreferredLanguages(void);

/** 导入钱包类型 */
typedef enum : NSUInteger {
    ImportWalletTypeKeyStore,   //keystore
    ImportWalletTypeMnemonic,   //助记词
    ImportWalletTypePrivateKey, //私钥
} ImportWalletType;

/** web文档类型 */
typedef enum : NSUInteger {
    DocumentTypeMnemonic,       //助记词
    DocumentTypePrivateKey,     //私钥
    DocumentTypeKeyStore,       //keystore
    DocumentTypePrivacyPolicy,  //隐私条款
    DocumentTypeHelpCenter,     //帮助中心
    DocumentTypeVersionLogs,    //版本日志
    DocumentTypeMessage,        //消息
} DocumentType;

/** 消息列表类型 */
typedef enum : NSUInteger {
    MessgeModeSystem, //系统型
    MessgeModeAgent, // 节点型
    MessgeModeOther,  //其他类型
} MessgeMode;

//支付调用类型
typedef enum : NSUInteger {
    NaboxPayTypeNormal,     //app支付
    NaboxPayTypeOffline,    //只组装交易不请求后台接口
    NaboxPayTypeCallOffline,//只组装合约交易不请求后台
    NaboxPayTypeKeystore,   //不做支付，用于授权，返回keystore方式
} NaboxPayType;

/** type:0~取消，1~确定 */
typedef void(^PopBlock)(NSInteger type);

NS_ASSUME_NONNULL_BEGIN

@interface CommonEnum : NSObject

@end

NS_ASSUME_NONNULL_END
