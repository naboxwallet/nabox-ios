//
//  FeeLevelSelectView.m
//  NaboxWallet
//
//  Created by Admin on 2021/4/4.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "FeeLevelSelectView.h"

@interface FeeLevelSelectView ()
@property (strong, nonatomic) IBOutlet UIButton *lowButton;
@property (strong, nonatomic) IBOutlet UILabel *lowLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *midButton;
@property (strong, nonatomic) IBOutlet UILabel *midLabel;
@property (strong, nonatomic) IBOutlet UILabel *midNunLabel;
@property (strong, nonatomic) IBOutlet UIButton *highButton;
@property (strong, nonatomic) IBOutlet UILabel *highLabel;
@property (strong, nonatomic) IBOutlet UILabel *highNumLabel;

@end

@implementation FeeLevelSelectView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setCircleWithRadius:4];
//    self.lowLabel.text = KLocalizedString(@"");
//    self.midLabel.text = KLocalizedString(@"");
//    self.highLabel.text = KLocalizedString(@"");
    [self selectButtonClick:self.midButton];
}

- (void)setFeeArr:(NSArray<NSString *> *)feeArr
{
    _feeArr = feeArr;
    if (feeArr.count > 2) {
        self.lowNumLabel.text = [self.feeArr firstObject];
        self.midNunLabel.text = self.feeArr.count > 1 ? self.feeArr[1] : @"";
        self.highNumLabel.text = [self.feeArr lastObject];
    }
}

- (IBAction)selectButtonClick:(UIButton *)sender {
    self.lowButton.backgroundColor = sender.tag == 0 ? KColorSkin1 : KColorClear;
    self.midButton.backgroundColor = sender.tag == 1 ? KColorSkin1 : KColorClear;
    self.highButton.backgroundColor = sender.tag == 2 ? KColorSkin1 : KColorClear;
    self.lowLabel.textColor = sender.tag == 0 ? KColorWhite : KColorGray2;
    self.lowNumLabel.textColor = sender.tag == 0 ? KColorWhite : KColorGray2;
    self.midLabel.textColor = sender.tag == 1 ? KColorWhite : KColorGray2;
    self.midNunLabel.textColor = sender.tag == 1 ? KColorWhite : KColorGray2;
    self.highLabel.textColor = sender.tag == 2 ? KColorWhite : KColorGray2;
    self.highNumLabel.textColor = sender.tag == 2 ? KColorWhite : KColorGray2;
    
    if (self.feeBlock && self.feeArr.count > 2) {
        self.feeBlock(sender.tag, self.feeArr[sender.tag]);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(feeLevelDidSelect:feeValue:)]) {
        [self.delegate feeLevelDidSelect:sender.tag feeValue:self.feeArr[sender.tag]];
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
