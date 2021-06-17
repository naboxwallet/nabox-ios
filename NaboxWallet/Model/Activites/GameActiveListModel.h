//
//  GameActiveListModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameActiveListModel : BaseModel

@end

@interface GameActiveListResModel : NSObject
@property (nonatomic ,strong) NSArray *list;
@end


@interface GameActiceResSubModel : NSObject
@property (nonatomic ,strong)NSString *fileDescEn;
@property (nonatomic ,strong)NSString *fileDesc;

@property (nonatomic ,strong)NSString *fileName;
@property (nonatomic ,strong)NSString *fileNameEn;

@property (nonatomic ,strong)NSString *endfileNameEn;
@property (nonatomic ,strong)NSString *jumpUrl;
@property (nonatomic ,strong)NSString *url;
@property (nonatomic ,strong)NSString *state;

@end

NS_ASSUME_NONNULL_END
