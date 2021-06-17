//
//  QueryTxListModel.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "QueryTxListModel.h"

@implementation QueryTxListModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNumber = 1;
        self.pageSize = 10;
        self.language = [LanguageUtil getUserLanguageStr];
//        NSString *startStr = [[[NSDate date] offsetMonths:-1] stringWithFormat:@"yyyy-MM-dd"];
//        NSString *endStr = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
//        self.startTime = [NSString stringWithFormat:@"%@ 00:00:00",startStr];
//        self.endTime = [NSString stringWithFormat:@"%@ 23:59:59",endStr];
    }
    return self;
}
@end
