//
//  ContactsUtil.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ContactsUtil : NSObject
+ (NSMutableArray*)getContacts;
+ (void)addContacts:(ContactsModel*)contactModel;
+ (void)deleteContacts:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
