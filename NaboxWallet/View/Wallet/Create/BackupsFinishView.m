//
//  BackupsFinishView.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "BackupsFinishView.h"

@interface BackupsFinishView ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BackupsFinishView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.text = KLocalizedString(@"backup_success");
    self.infoLabel.text = KLocalizedString(@"backup_hint");
}

- (IBAction)confirmButtonClick:(id)sender {
    [self hideView];
    if (self.backupsBlock) {
        self.backupsBlock();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
