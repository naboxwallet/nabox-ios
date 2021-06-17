//
//  BasePublicRequestModel.h
//  NaboxWallet
//
//  Created by Admin on 2020/8/2.
//  Copyright © 2020 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasePublicRequestModel : NSObject
@property (nonatomic ,strong) NSString *jsonrpc;
@property (nonatomic ,strong) NSString *method;
@property (nonatomic ,strong) NSArray *params;
@property (nonatomic ,strong) NSString *id;


@end

NS_ASSUME_NONNULL_END
