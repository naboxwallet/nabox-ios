//
//  BackupsFinishView.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BackupsFinishBlock)(void);

@interface BackupsFinishView : UIView
@property (nonatomic, copy) BackupsFinishBlock backupsBlock;
@end

NS_ASSUME_NONNULL_END
