//
//  ContactsModel.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019年 NaboxWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactsModel : NSObject
@property (nonatomic ,strong) NSString *iconName;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,strong) NSString *chain;
@end

NS_ASSUME_NONNULL_END
