//
//  UIView+XIBInstance.m
//  SimplicityWeather
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2018年 SimplicityWeather. All rights reserved.
//

#import "UIView+XIBInstance.h"

@implementation UIView (XIBInstance)

+ (instancetype)instanceView {
    
    NSArray * nibView = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithUTF8String:object_getClassName([self class])] owner:nil options:nil];
    return [nibView firstObject];
}


+ (UINib *)loadNibNamed:(NSString*)nibName
{
    return [self loadNibNamed:nibName bundle:[NSBundle mainBundle]];
}
+ (UINib *)loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle
{
    return [UINib nibWithNibName:nibName bundle:bundle];
}
+ (instancetype)loadInstanceFromNib
{
    return [self loadInstanceFromNibWithName:NSStringFromClass([self class])];
}
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName
{
    return [self loadInstanceFromNibWithName:nibName owner:nil];
}
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner
{
    return [self loadInstanceFromNibWithName:nibName owner:owner bundle:[NSBundle mainBundle]];
}
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle
{
    UIView *result = nil;
    NSArray* elements = [bundle loadNibNamed:nibName owner:owner options:nil];
    for (id object in elements)
    {
        if ([object isKindOfClass:[self class]])
        {
            result = object;
            break;
        }
    }
    return result;
}

@end
