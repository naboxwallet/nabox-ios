//
//  VersionManageModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VersionManageModel : BaseModel
/* 主键 */
@property (nonatomic, strong) NSNumber *ID;
/* 版本 example: V1.0.0 */
@property (nonatomic, copy) NSString *version;
/* 版本Code */
@property (nonatomic, strong) NSNumber *versionCode;
/* 版本更新内容 */
@property (nonatomic, copy) NSString *markDownContext;
/* 安装包下载地址 */
@property (nonatomic, copy) NSString *downUrl;
/* 是否强制更新 */
@property (nonatomic, strong) NSNumber *forceUpdate;
/* 文档code */
@property (nonatomic, copy) NSString *docCode;
/* 创建时间 */
@property (nonatomic, copy) NSString *createTime;
/* 文档扩展参数 */
@property (nonatomic, copy) NSString *extParams;
/* 更新时间 */
@property (nonatomic, copy) NSString *updateTime;

/* 语言 CHS EN （用于数据请求时使用）*/
@property (nonatomic, copy) NSString *language;

@end

NS_ASSUME_NONNULL_END
