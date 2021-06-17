//
//  TradingRecordViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "TradingRecordViewController.h"
#import "TradeInfoModel.h"
#import "AddFeePopView.h"
@interface TradingRecordViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottom;

@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIView *txIdView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txIdViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *txidLabel;
@property (strong, nonatomic) IBOutlet UILabel *txidInfoLabel;
@property (strong, nonatomic) IBOutlet UIView *blockHeightView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blockHeight;
@property (strong, nonatomic) IBOutlet UILabel *blockHeightLabel;
@property (strong, nonatomic) IBOutlet UILabel *blockHeightInfoLabel;
@property (strong, nonatomic) IBOutlet UIView *remarkView;
@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;
@property (strong, nonatomic) IBOutlet UILabel *remarkInfoLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *remarkHeight;


@property (strong, nonatomic) IBOutlet UILabel *minersLabel;
@property (strong, nonatomic) IBOutlet UILabel *minersInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *tradeTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *tradeTypeInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateInfoLabel;
@property (strong, nonatomic) IBOutlet UIView *selfChainTradeInfoView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selfChainTradeInfoViewHeight;

@property (strong, nonatomic) IBOutlet UILabel *paymentLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *receivablesLabel;
@property (strong, nonatomic) IBOutlet UILabel *receivablesInfoLabel;


@property (strong, nonatomic) IBOutlet UIView *crossChainTradeInfoView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *crossChainTradeInfoViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *crossChainFromChainLabel;
@property (strong, nonatomic) IBOutlet UILabel *crossChainFromAddressLabel;

@property (strong, nonatomic) IBOutlet UILabel *crossChainFromTxIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *crossChainToChainLabel;
@property (strong, nonatomic) IBOutlet UILabel *crossChainToAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *crossChainToTxIdLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftLabelWidth;


@property (strong, nonatomic) IBOutlet UIButton *queriesButton;

@property (nonatomic, copy) NSString *allFromStr;
@property (nonatomic, copy) NSString *allToStr;
@property (strong, nonatomic) IBOutlet UIButton *addFeeButton;

@end

@implementation TradingRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
    [self getTransQueryTxList];
}

- (void)updateUI
{
    self.navigationItem.title = KLocalizedString(@"transaction_record");
    self.minersLabel.text = KLocalizedString(@"miners_fees");
    self.remarkLabel.text = KLocalizedString(@"remark");
    self.dateLabel.text = KLocalizedString(@"trans_date");
    self.tradeTypeLabel.text = KLocalizedString(@"txType");
//    [self.queriesButton setTitle:KLocalizedString(@"go_to_the_browser_for_queries") forState:UIControlStateNormal];
    if ([LanguageUtil getUserLanguageType] == LANGUAGETYPEEN) {
        self.leftLabelWidth.constant = 120;
    }
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.paymentInfoLabel.userInteractionEnabled = YES;
    self.receivablesInfoLabel.userInteractionEnabled = YES;
    self.txidInfoLabel.userInteractionEnabled = YES;
//    WS(weakSelf);
//    [self.paymentInfoLabel addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
//        [weakSelf beginCopyWithType:0];
//    }];
//    [self.receivablesInfoLabel addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
//        [weakSelf beginCopyWithType:1];
//    }];
//    [self.txidInfoLabel addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
//        [weakSelf beginCopyWithType:2];
//    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.bgViewWidth.constant = KSCREEN_WIDTH;
//    self.bgViewHeight.constant = CGRectGetMaxY(self.crossChainTradeInfoView.frame) + 50;
//    self.scrollView.contentSize = CGSizeMake(KSCREEN_WIDTH, self.bgView.height);
}

- (void)beginCopyWithType:(NSInteger)type
{
    [KAppDelegate.window showNormalToast:KLocalizedString(@"copy_to_clipboard")];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (type == 0) {
        pasteboard.string = self.allFromStr;
    }else if (type == 1) {
        pasteboard.string = self.allToStr;
    }else if (type == 2) {
        pasteboard.string = self.txidInfoLabel.text;
    }
}

/**
 资产详情数据 通用界面
 */
- (void)getTransQueryTxList
{    
    KShowHUD;
    TradeInfoModel *requestModel =  [TradeInfoModel new];
    requestModel.chain = self.chain;
    requestModel.txHash =self.txHash;
    requestModel.transCoinId = self.transCoinId;
    requestModel.resClassStr = NSStringFromClass([requestModel class]);
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_TX_COIN_INFO dataModel:requestModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        KHideHUD;
        if (success) {
            DLog(@"详情%@",dataObj);
            TradeInfoModel *resModel = dataObj;
            [strongSelf updateCommonUIWithTradeInfo:resModel.tx];
            if (resModel.crossTx) {
                [strongSelf updateCrossChainTradeUIWithTradeInfo:resModel.tx andCrossTx:resModel.crossTx];
            }else{
                [strongSelf updateSelfChainTradeUIWithTradeInfo:resModel.tx];
            }
        }else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}

- (void)updateCommonUIWithTradeInfo:(TradeInfoResModel*)model{
    self.numLabel.text = [NSString stringWithFormat:@"%@%@",[Common formatValueWithValue:model.amount andDecimal:model.decimals],model.symbol];
    self.minersInfoLabel.text = model.fee;
    NSString *transType = [NSString stringWithFormat:@"type_%@",model.type]; // 交易类型
    self.tradeTypeInfoLabel.text = [NSString stringWithFormat:@"%@",KLocalizedString(transType)];
    self.dateInfoLabel.text = model.createTime;
}

// 本链交易
- (void)updateSelfChainTradeUIWithTradeInfo:(TradeInfoResModel*)model{
    self.crossChainTradeInfoView.hidden = YES;
    self.crossChainTradeInfoViewHeight.constant = 0;
    
   // 交易状态
    NSString *tradeStatus = [NSString stringWithFormat:@"statusType_%@",model.status];
    if ([model.status isEqualToString:@"0"]) {
        self.statusLabel.textColor = KColorOrange;
    }
    self.statusLabel.text = KLocalizedString(tradeStatus);
    // 备注
    self.remarkInfoLabel.text = model.remark ? : @"-- --";
    // 区块高度
    self.blockHeightInfoLabel.text = model.height;
    
    self.txidInfoLabel.text = self.txHash;
    // from
    self.paymentInfoLabel.text = model.froms;
    // to
    self.receivablesInfoLabel.text = model.tos;
}

- (void)updateCrossChainTradeUIWithTradeInfo:(TradeInfoResModel *)model andCrossTx:(CrossTxModel*)crossTx{
    self.txIdView.hidden = YES;
    self.txIdViewHeight.constant = 0;
    self.blockHeightView.hidden = YES;
    self.blockHeight.constant = 0;
    self.remarkView.hidden = YES;
    self.remarkHeight.constant = 0;
    
    self.selfChainTradeInfoView.hidden = YES;
    self.selfChainTradeInfoViewHeight.constant = 0;
    
    self.numLabel.text = [NSString stringWithFormat:@"%@%@",[Common formatValueWithValue:model.amount andDecimal:model.decimals],model.symbol];
      //  交易状态
        NSString *tradeStatus = [NSString stringWithFormat:@"crossStatusType_%@",crossTx.status];
    self.statusLabel.text = KLocalizedString(tradeStatus);
    // 跨链交易详情
    self.crossChainFromChainLabel.text = [NSString stringWithFormat:@"%@%@",crossTx.fromChain,KLocalizedString(@"network")];
    self.crossChainFromAddressLabel.text = model.froms;
    self.crossChainFromTxIdLabel.text = crossTx.txHash;
    
    
    self.crossChainToChainLabel.text = [NSString stringWithFormat:@"%@%@",crossTx.toChain,KLocalizedString(@"network")];
    self.crossChainToAddressLabel.text = model.tos;
    self.crossChainToTxIdLabel.text = crossTx.crossTxHash;
    
}

- (IBAction)addFeebuttonClick:(UIButton *)sender {
    AddFeePopView *nameView = [AddFeePopView instanceView];
    WS(weakSelf);
    nameView.nameBlock = ^(AddFeePopView * _Nonnull nameView, NSString * _Nonnull name) {
        SS(strongSelf);
        
    };
    [nameView showInController:self preferredStyle:TYAlertControllerStyleAlert];
}


//[Common editLabelStringWithLabel:self.txidInfoLabel allStr:self.txidInfoLabel.text editStr:@"" color:KColorBlack isSetLine:YES];
////    [Common editLabelStringWithLabel:self.paymentInfoLabel allStr:self.paymentInfoLabel.text editStr:@"" color:KColorBlack isSetLine:YES];
////    [Common editLabelStringWithLabel:self.receivablesInfoLabel allStr:self.receivablesInfoLabel.text editStr:@"" color:KColorBlack isSetLine:YES];
//    //    if (model.froms.length >0) {
//    //        NSArray *coinFroms = [model.froms componentsSeparatedByString:@","];
//    //        self.allFromStr = [self getAppendStrWithModelArr:coinFroms maxCount:coinFroms.count];
//    //        self.paymentInfoLabel.text = [self getAppendStrWithModelArr:coinFroms maxCount:5];
//    //    }
//    //    if (model.tos.length >0 ) {
//    //         self.allToStr = [self getAppendStrWithModelArr:model.coinTos maxCount:model.coinTos.count];
//    //    }
//    //    self.receivablesInfoLabel.text = [self getAppendStrWithModelArr:model.coinTos maxCount:5];

- (NSString *)getAppendStrWithModelArr:(NSArray *)modelArr maxCount:(NSInteger)maxCount
{
    NSString *addressStr = [NSString string];
    for (int i = 0; i < modelArr.count; i ++) {
        TransferCoinModel *coinModel = modelArr[i];
        if (addressStr.length) {
            if (i < maxCount) {
                addressStr = [NSString stringWithFormat:@"%@\n%@",addressStr,coinModel.address];
            }else {
                addressStr = [NSString stringWithFormat:@"%@\n...",addressStr];
                break;
            }
        }else {
            addressStr = coinModel.address;
        }
    }
    return addressStr;
}

- (IBAction)queriesButtonClick:(id)sender {
    NSString *urlStr = [NSString stringWithFormat:@"%@?hash=%@",WEB_NULSCAN,self.txHash];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
