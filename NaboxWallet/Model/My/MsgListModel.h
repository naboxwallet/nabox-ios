//
//  MsgListModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MsgListModel : BaseModel

@property (nonatomic ,strong)NSString *language;
@property (nonatomic ,strong)NSString *terminal;
@property (nonatomic ,copy) NSArray *addressList;



- (NSDictionary *)getMsgIgnoredKeys;

@property (nonatomic ,assign) NSInteger count;

@property (nonatomic ,assign) NSInteger redCount;
@property (nonatomic ,assign) NSInteger yellowCount;
@property (nonatomic ,copy)NSArray *list;
@property (nonatomic ,assign) NSInteger size;
@property (nonatomic ,assign) NSInteger current;
@property (nonatomic ,strong) NSString *type;
@end
@interface UserMsgSubArrayModel : NSObject
// 用户信息
@property (nonatomic ,strong) NSString *docCode;
@property (nonatomic ,strong) NSString *language;
@property (nonatomic ,strong) NSString *messageId;
@property (nonatomic ,strong) NSString * createTime;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,assign) NSInteger readState;
@property (nonatomic ,strong) NSString *configCode;

@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,strong) NSString *txHex;
@property (nonatomic ,strong) NSString *id;
@property (nonatomic ,strong) NSString *extParams;
@property (nonatomic ,strong) NSString *iconUrl;
// 系统信息
@property (nonatomic ,strong) NSString *summary;

@end

NS_ASSUME_NONNULL_END
