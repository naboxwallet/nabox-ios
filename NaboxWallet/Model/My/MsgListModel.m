//
//  MsgListModel.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "MsgListModel.h"

@implementation MsgListModel

- (instancetype)init
{
    if (self = [super init]) {
        self.language = [LanguageUtil getUserLanguageStr];
        self.terminal = TERMINAL;
        self.type = @"IOS";
    }
    return self;
}

- (NSDictionary *)getMsgIgnoredKeys{
    NSDictionary *tempDict = [self mj_keyValuesWithKeys:@[@"addressList",@"id"]];
    return tempDict;
}
@end


@implementation UserMsgSubArrayModel


@end
