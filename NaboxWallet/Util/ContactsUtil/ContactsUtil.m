//
//  ContactsUtil.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import "ContactsUtil.h"
#define contacts @"CONTACTS"

@implementation ContactsUtil
+(NSMutableArray*)getContacts{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *contactsArray = [userDefaults valueForKey:contacts];
    if (!contactsArray) {
        contactsArray = [NSMutableArray new];
    }else{
        contactsArray =  [ContactsModel mj_objectArrayWithKeyValuesArray:contactsArray];
    }
    return contactsArray;
}
+ (void)addContacts:(ContactsModel*)contactModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *contactsArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:contacts]];
    [contactsArray addObject:[contactModel mj_keyValues]];
    [userDefaults setValue:contactsArray forKey:contacts];
    [userDefaults synchronize];
}

+ (void)deleteContacts:(NSInteger)index{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *contactsArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:contacts]];
    [contactsArray removeObjectAtIndex:index];
    [userDefaults setValue:contactsArray forKey:contacts];
    [userDefaults synchronize];
}

@end
