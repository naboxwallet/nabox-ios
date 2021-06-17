//
//  CrossChainTransferViewController.m
//  NaboxWallet
//
//  Created by Admin on 2021/3/14.
//  Copyright © 2021 NaboxWallet. All rights reserved.
//

#import "CrossChainTransferViewController.h"
#import "SGPagingView.h"
#import "FTPopOverMenu.h"
#import "TransferFeeUtil.h"
#import "TransferConfirmViewController.h"
#import "NerveTools.h"
#import "WalletNamePopView.h"
#import "CommonListView.h"

@interface CrossChainTransferViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *signViewHeight;

@property (strong, nonatomic) IBOutlet UILabel *signLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *toTypeLabel;
@property (strong, nonatomic) IBOutlet UIButton *fromAddressButton;
@property (strong, nonatomic) IBOutlet UIButton *toAddressButton;
@property (strong, nonatomic) IBOutlet UIView *toSelectView;
@property (strong, nonatomic) IBOutlet UIView *fromSelectView;
@property (strong, nonatomic) IBOutlet UILabel *moneyTxtView;
@property (strong, nonatomic) IBOutlet UIButton *currencyTypeButton;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;
@property (strong, nonatomic) IBOutlet UIButton *allButton;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *feeTxtLabel;
@property (strong, nonatomic) IBOutlet UILabel *feeValueLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIView *infoBgView;
@property (strong, nonatomic) IBOutlet UIView *moneyBgView;
@property (strong, nonatomic) IBOutlet UIButton *speedButton;

@property (nonatomic, strong) WalletModel *walletModel; // 当前钱包数据model
@property (nonatomic, strong) TransferTempModel *transferModel; // 交易的全部信息
@property (nonatomic, strong) NSMutableArray *assetArray; // 资产列表
@property (nonatomic, strong) TransferFeeUtil *feeUtil;

@property (nonatomic ,assign) BOOL clickAll; // 点击全部 计算手续费后 显示剩余金额
@property (nonatomic ,assign) BOOL isAllowing; // 正在授权

@end

@implementation CrossChainTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = KLocalizedString(@"innerTransfer1");
    
    [GlobalVariable sharedInstance].feeLevel = 1;
    self.walletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
    DLog(@"当前钱包数据%@",[self.walletModel mj_keyValues]);
    self.transferModel = [TransferTempModel new];
    [self updateUI];
    [self getAssetList];
}

- (void)updateUI
{
    self.signLabel.text = KLocalizedString(@"innerTransfer2");
    [self.infoBgView setCircleWithRadius:4];
    [self.moneyBgView setCircleWithRadius:4];
    [self.infoBgView setborderWithBorderColor:KColorGray4 Width:1];
    [self.moneyBgView setborderWithBorderColor:KColorGray4 Width:1];
    [self.currencyTypeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    
    // 国际化文本处理
    self.fromLabel.text = KLocalizedString(@"innerTransfer3");
    self.toLabel.text = KLocalizedString(@"innerTransfer4");
    [self.confirmButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    [self.allButton setTitle:KLocalizedString(@"all") forState:UIControlStateNormal];
    self.feeTxtLabel.text = KLocalizedString(@"service_charge");
    self.moneyTxtView.text = KLocalizedString(@"actual_achievement");
    
    [self.moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.speedButton setTitle:KLocalizedString(@"speed") forState:UIControlStateNormal];
    
    // from链是固定不可选择 默认当前chain
    [self updateSelectedChainWithChain:self.assetListModel.chain andIsFrom:YES];
    // to链需要选择 from是异构链和NULS to默认NERVE from是NERVE to默认NULS
    [self updateSelectedChainWithChain:[self.transferModel.fromChain isEqualToString:@"NERVE"]?@"NULS":@"NERVE" andIsFrom:NO];
    WS(weakSelf);
    [self.toSelectView addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
        SS(strongSelf);
        [strongSelf toSelectViewTapAction];
    }];
    
    // 提示文本隐藏
    NSString *sign = [UserDefaultsUtil getValueWithKey:@"SIGN"];
    if (sign && [sign isEqualToString:@"HIDDEN"]) {
        self.signViewHeight.constant = 0;
    }
}


#pragma mark - 查询当前链资产列表
- (void)getAssetList{
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_ADRESS_ASEETS dataModel:self.assetListModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            
            DLog(@"划转-资产列表%@",dataObj);
            strongSelf.assetArray = [NSMutableArray arrayWithArray:[AssetListResModel mj_objectArrayWithKeyValuesArray:dataObj]];
            if (strongSelf.assetArray.count >0) { // 默认选择主资产
                AssetListResModel *assetInfoModel = [self filterMainAssetModel];
                [strongSelf updateSeletedAsset:assetInfoModel];
            }
        } else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}
- (IBAction)closeTipAction:(UIButton *)sender {
    self.signViewHeight.constant = 0;
    [UserDefaultsUtil saveValue:@"HIDDEN" forKey:@"SIGN"];
}

- (void)toSelectViewTapAction
{
    // 这里获取除了本链的其他四条链
    NSMutableArray *toChains = [NSMutableArray new];
    for (NSString *chain in self.walletModel.addressDict) {
        if (![chain isEqualToString:self.transferModel.fromChain]) {
            [toChains addObject:chain];
        }
    }
    WS(weakSelf);
//    FTPopOverMenuConfiguration *configuration = [self getMenuConfiguration];
//    [FTPopOverMenu showForSender:self.toTypeLabel
//                   withMenuArray:toChains
//                      imageArray:nil
//                   configuration:configuration
//                       doneBlock:^(NSInteger selectedIndex) {
//        SS(strongSelf);
//        NSString *selectedChain = toChains[selectedIndex];
//        [strongSelf updateSelectedChainWithChain:selectedChain andIsFrom:NO];
//        [strongSelf getAssetList];
//        strongSelf.moneyTextField.text = @"";
//    } dismissBlock:nil];
    CommonListView *assetsListView = [CommonListView instanceView];
    assetsListView.titleLabel.text = KLocalizedString(@"chooseNetwork");
    assetsListView.dataSource = toChains;
    [assetsListView showInController:self preferredStyle:TYAlertControllerStyleActionSheet];
    assetsListView.selectBlock = ^(NSString * _Nullable name, NSInteger index) {
        SS(strongSelf);
        NSString *selectedChain = toChains[index];
        [strongSelf updateSelectedChainWithChain:selectedChain andIsFrom:NO];
        [strongSelf getAssetList];
        strongSelf.moneyTextField.text = @"";
    };
    
}

/** 资产类型 */
- (IBAction)currencyTypeButtonClick:(UIButton *)sender
{
    NSArray *symbolList = [self getAvailableAssetList];
    WS(weakSelf);
    FTPopOverMenuConfiguration *configuration = [self getMenuConfiguration];
    [FTPopOverMenu showForSender:sender
                   withMenuArray:symbolList
                      imageArray:nil
                   configuration:configuration
                       doneBlock:^(NSInteger selectedIndex) {
        SS(strongSelf);
            for (int i = 0; i< strongSelf.assetArray.count; i++) {
                AssetListResModel *model = strongSelf.assetArray[i];
                if ([model.symbol isEqualToString:symbolList[selectedIndex]]) {
                    [strongSelf updateSeletedAsset:model];
                    break;
                }
            }
            
    // 跨链合约交易-需要查询授权额度
    if ( [ChainUtil isHeterChain:self.transferModel.fromChain] && [self.transferModel.assetModel.contractAddress isHaveValue]) {
            BOOL needAllow =  [self hetTokenAllowanceWithType:1];
            if (needAllow) {
                self.isAllowing = YES;
            [self.confirmButton setTitle:KLocalizedString(@"authorization") forState:UIControlStateNormal];
                [KAppDelegate.window showNormalToast:KLocalizedString(@"auth_token")];
        }
    }else{
        strongSelf.isAllowing = NO;
        [strongSelf.confirmButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    }
                           
    } dismissBlock:nil];
}

/*** 选择了链后更新链和地址 **/
- (void)updateSelectedChainWithChain:(NSString *)selectedChain andIsFrom:(BOOL)isFrom{
    
    NSString *selectedAddress = [self.walletModel.addressDict objectForKey:selectedChain];
    if (isFrom) {
        self.transferModel.fromChain = self.fromTypeLabel.text = selectedChain;
        self.transferModel.fromAddress = selectedAddress;
        [self.fromAddressButton setTitle:selectedAddress forState:UIControlStateNormal];
    }else{
        self.transferModel.toChain = self.toTypeLabel.text = selectedChain;
        self.transferModel.toAddress = selectedAddress;
        [self.toAddressButton setTitle:selectedAddress forState:UIControlStateNormal];
        // 当fromChain和toChain是nuls或者nerve时隐藏加速按钮
        if ([ChainUtil isNulsSeries:self.transferModel.fromChain] && [ChainUtil isNulsSeries:self.transferModel.toChain]) {
            self.speedButton.hidden = YES;
        }else{
            self.speedButton.hidden = NO;
        }
    }
    //更新手续费
    [self updatefee];
}

/*** 选择资产后更新transferModel和界面余额信息 **/
- (void)updateSeletedAsset:(AssetListResModel *)seletedAssetInfo{
    self.transferModel.assetModel = seletedAssetInfo;
    [self.currencyTypeButton setTitle:seletedAssetInfo.symbol forState:UIControlStateNormal];
    self.balanceLabel.text = [NSString stringWithFormat:@"%@:%@",KLocalizedString(@"available"),[Common formatValueWithValue:seletedAssetInfo.balance andDecimal:seletedAssetInfo.decimals ]];
    //更新手续费
    [self updatefee];
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if([self.transferModel.assetModel.balance doubleValue] / pow(10, self.transferModel.assetModel.decimals)  < [textField.text doubleValue]  ){
        [KAppDelegate.window showNormalToast:KLocalizedString(@"balance_not_enough")];
    }
    //更新手续费
    [self updatefee];
}

/** 全部 需要减去手续费 */
- (IBAction)allButtonClick:(id)sender {
    if ([self.transferModel.assetModel.balance doubleValue] > 0 ) {
        if ([self isMainAsset]) {
            self.clickAll = true; // 如果是主资产则需要计算手续费后显示
        }else{
           self.moneyTextField.text = [Common formatValueWithValue:self.transferModel.assetModel.balance  andDecimal:self.transferModel.assetModel.decimals];
        }
        //输入金额后更新手续费
        [self updatefee];
    }
    
}



/** 确认 */
- (IBAction)confirmButtonClick:(id)sender
{
    if (self.isAllowing) {
        [self hetTokenAllowanceWithType:2];
        return;
    }
    
    if(![self.moneyTextField.text isHaveValue]){
        [KAppDelegate.window showNormalToast:KLocalizedString(@"please_enter_the_amount_of_transfer")];
        return;
    }
    
    if([self.transferModel.assetModel.balance doubleValue] / pow(10, self.transferModel.assetModel.decimals)  < [self.moneyTextField.text doubleValue]  ){
        [KAppDelegate.window showNormalToast:KLocalizedString(@"balance_not_enough")];
        return;
    }
    if ([self.moneyTextField.text isEqualToString:@"0"] || ![self balanceIsEnough]) {
        [KAppDelegate.window showNormalToast:KLocalizedString(@"balance_not_enough")];
        return;
    }
    
    
    
    
    
    TransferConfirmViewController *confirmVC = [[TransferConfirmViewController alloc] init];
    self.transferModel.amount = self.moneyTextField.text;
    confirmVC.transModel = self.transferModel;
    confirmVC.feeValueStr = self.feeValueLabel.text;
    [self.navigationController pushViewController:confirmVC animated:YES];
}



/** 手续费计算 */
- (void)updatefee
{
    if (self.moneyTextField.text.doubleValue == 0 && !self.clickAll) {
        self.feeValueLabel.text = @"--";
        return;
    }
    BOOL speed = self.speedButton.selected;
    double multiple = 1.3;
    NSString *fromChain = self.transferModel.fromChain;
    NSString *toChain = self.transferModel.toChain;
    NSString *amount = [NSString stringWithFormat:@"%.0f",[self.moneyTextField.text doubleValue] * pow(10, self.transferModel.assetModel.decimals)];
    //主资产
    ConfigMainAssetModel *mainAssetModel = [[GlobalVariable sharedInstance] getMainAssetWithChain:fromChain];
    //是否为合约资产
    BOOL isContractAddress = self.transferModel.assetModel.contractAddress.length;
    
    if ([fromChain isEqualToString:@"NULS"]) {
        if ([toChain isEqualToString:@"NERVE"]) {
            if (isContractAddress) {
                //如果选择合约资产 通过接口获取gas from链是合约
                [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsContractAddress transferModel:self.transferModel toAddress:self.transferModel.toAddress amount:amount transferFeeBlock:^(TransferFeeType type, TransferTempModel * _Nonnull transferModel) {
                    NSString *feeStr = [Common decimalNotPOWWithFormatByDecimal:transferModel.fee andDecimal:transferModel.assetModel.decimals];
                    self.feeValueLabel.text = [NSString stringWithFormat:@"%@NULS",feeStr];
                    self.transferModel.fee = transferModel.fee;
                }];
            } else {
                self.feeValueLabel.text = @"0.01NULS";
                [self setAvailableAmountOmitFee];
            }
        } else {
            //NULS->NERVE->异构链
            if (isContractAddress) {
                //gas+NERVE->异构链
                [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsContractAddress transferModel:self.transferModel toAddress:self.walletModel.addressDict[NERVE] amount:amount transferFeeBlock:^(TransferFeeType type, TransferTempModel * _Nonnull transferModel) {
                    NSString *feeStr = [Common decimalNotPOWWithFormatByDecimal:transferModel.fee andDecimal:transferModel.assetModel.decimals];
                    //nerve->异构链
                    [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsNVTCroee transferModel:self.transferModel transferFeeBlock:^(TransferFeeType type, TransferTempModel * _Nonnull transferModel) {
                        NSNumber *fee = [self getCurrentFeeWithFee:transferModel.fee];
                        NSString *croeeFeeStr = [[NSString stringWithFormat:@"%@",fee] stringByAppendingString:NVT];
                        self.feeValueLabel.text = [NSString stringWithFormat:@"%@NULS + %@",feeStr,croeeFeeStr];
                        self.transferModel.fee = [fee doubleValue];
                    }];
                }];
            } else {
                //0.01NULS+NERVE->异构链
                [self setAvailableAmountOmitFee]; // 只考虑第一步手续费
                
                [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsNVTCroee transferModel:self.transferModel transferFeeBlock:^(TransferFeeType type, TransferTempModel * _Nonnull transferModel) {
                    NSNumber *fee = [self getCurrentFeeWithFee:transferModel.fee];
                    NSString *feeStr = [[NSString stringWithFormat:@"%@",fee] stringByAppendingString:NVT];
                    self.feeValueLabel.text = [NSString stringWithFormat:@"0.01NULS + %@",feeStr];
                    self.transferModel.fee = [fee doubleValue];
                }];
            }
        }
    } else if ([fromChain isEqualToString:@"NERVE"]) {
        if ([toChain isEqualToString:@"NULS"]) {
            //NERVE->NULS
            self.feeValueLabel.text = @"0.01NULS + 0.01NVT";
            [self setAvailableAmountOmitFee];
        } else {
            //NERVE->异构链
            [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsNVTCroee transferModel:self.transferModel transferFeeBlock:^(TransferFeeType type, TransferTempModel * _Nonnull transferModel) {
                [self setAvailableAmountOmitFee];
                
                NSNumber *fee = [self getCurrentFeeWithFee:transferModel.fee];
                self.feeValueLabel.text = [[NSString stringWithFormat:@"%@",fee] stringByAppendingString:mainAssetModel.symbol];
                self.transferModel.fee = [fee doubleValue];
            }];
        }
    } else { // fromChain是异构链
        if ([toChain isEqualToString:@"NULS"]) {
            //异构链->NERVE->NULS
            [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsFromIsomerism transferModel:self.transferModel transferFeeBlock:^(TransferFeeType type, TransferTempModel * _Nonnull transferModel) {
                [self setAvailableAmountOmitFee];
                NSNumber *fee = [self getCurrentFeeWithFee:transferModel.fee];
                NSString *feeStr = [[NSString stringWithFormat:@"%@",fee] stringByAppendingString:mainAssetModel.symbol];
                self.feeValueLabel.text = [NSString stringWithFormat:@"%@ + 0.01NULS + 0.01NVT",feeStr];
            }];
        } else if ([toChain isEqualToString:@"NERVE"]) {
            //异构链->NERVE
            [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsFromIsomerism transferModel:self.transferModel transferFeeBlock:^(TransferFeeType type, TransferTempModel * _Nonnull transferModel) {
                [self setAvailableAmountOmitFee];
                NSNumber *fee = [self getCurrentFeeWithFee:transferModel.fee];
                transferModel.fee = speed? transferModel.fee * multiple:transferModel.fee;
                self.feeValueLabel.text = [[NSString stringWithFormat:@"%@",fee] stringByAppendingString:mainAssetModel.symbol];
            }];
        } else {
            //异构链->NERVE->异构链
            [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsFromIsomerism transferModel:self.transferModel transferFeeBlock:^(TransferFeeType type, TransferTempModel * _Nonnull transferModel) {
                [self setAvailableAmountOmitFee];
                NSNumber *fee = [self getCurrentFeeWithFee:transferModel.fee];
                transferModel.fee = speed? transferModel.fee * multiple:transferModel.fee;
                NSString *feeStr = [[NSString stringWithFormat:@"%@",fee] stringByAppendingString:mainAssetModel.symbol];
                //nerve->异构链
                [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsNVTCroee transferModel:self.transferModel transferFeeBlock:^(TransferFeeType type, TransferTempModel * _Nonnull transferModel) {
                    NSNumber *fee = [self getCurrentFeeWithFee:transferModel.fee];
                    NSString *croeeFeeStr = [ [NSString stringWithFormat:@"%@",fee] stringByAppendingString:NVT];
                    self.feeValueLabel.text = [NSString stringWithFormat:@"%@ + %@",feeStr,croeeFeeStr];
                    self.transferModel.fee = [fee doubleValue];
                }];
            }];
        }
    }
}

- (NSNumber *)getCurrentFeeWithFee:(double)fee{
    double multiple = self.speedButton.selected?1.3:1;
    NSNumber *currentFee = [Common Num1:fee multiplyingWithNum2:multiple];
    return currentFee;
}

// 只有是主资产或者NERVE转NULS需要判断
- (BOOL)balanceIsEnough{
    NSString *fromChain = self.transferModel.fromChain;
    NSString *toChain = self.transferModel.toChain;
    if ([self isMainAsset] || ([ChainUtil isNerve:fromChain] && [self.transferModel.assetModel.symbol isEqualToString:NULS])) {
    double fee = 0;
    BOOL selfChain = [fromChain isEqualToString:toChain];
    if ([ChainUtil isNuls:fromChain]) {
        fee = selfChain ? 0.001 : 0.01;
    }else if ([ChainUtil isNerve:fromChain]){
        if (selfChain) {
            fee = 0;
        }else if ([ChainUtil isNuls:toChain]){
            fee = 0.01;
        }else if ([ChainUtil isHeterChain:toChain]){
            fee = self.transferModel.fee;
        }
    }else if ([ChainUtil isHeterChain:fromChain]){
        fee = self.transferModel.fee;
    }
    
    BOOL enough = [[Common Num1:[self.transferModel.assetModel.balance doubleValue]  withNum1decimal:self.transferModel.assetModel.decimals subtractingWithNum2:fee] doubleValue] >= [self.moneyTextField.text doubleValue];
    return enough;
    }
    return YES;
}

// 点击全部后 获取手续费然后重置输入框的值 目前只处理主资产
- (void)setAvailableAmountOmitFee{
    if (!self.clickAll) return;
    double fee = 0;
    NSString *fromChain = self.transferModel.fromChain;
    NSString *toChain = self.transferModel.toChain;
    BOOL selfChain = [fromChain isEqualToString:toChain];
    if ([ChainUtil isNuls:fromChain]) {
        fee = selfChain ? 0.001 : 0.01;
    }else if ([ChainUtil isNerve:fromChain]){
        if (selfChain) {
            fee = 0;
        }else if ([ChainUtil isNuls:toChain]){
            fee = 0.01;
        }else if ([ChainUtil isHeterChain:toChain]){
            fee = self.transferModel.fee;
        }
    }else if ([ChainUtil isHeterChain:fromChain]){
        fee = self.transferModel.fee;
    }
    self.moneyTextField.text = [NSString stringWithFormat:@"%@",[Common Num1:[self.transferModel.assetModel.balance doubleValue]  withNum1decimal:self.transferModel.assetModel.decimals subtractingWithNum2:fee]];
    self.clickAll = false;
}

/**** 获取有效的资产列表 **/
- (NSArray *)getAvailableAssetList{
    // 这里需要过滤资产列表
    NSString *fromChain = self.transferModel.fromChain;
    NSString *toChain = self.transferModel.toChain;
    NSMutableArray *nameArray = [NSMutableArray array];
    for (AssetListResModel *model in self.assetArray) {
        if ([self getAssetAvailableWithFromChain:fromChain andToChain:toChain andAsset:model]) {
            [nameArray addObject:model.symbol];
        }
    }
    return nameArray;
}
- (BOOL)getAssetAvailableWithFromChain:(NSString *)fromChain andToChain:(NSString *)toChain andAsset:(AssetListResModel *)assetModel{
    //    划转可以当做是2次转账,如果入金和出金都不是nerve则需要组装两次转账
    //    转账时候资产筛选的原则是:
    //    1 如果是nuls和Nerve交易需判断nulsCross=true
    //    2 如果是nerve->异构链需判断heterogeneousList包含toChain
    if (![ChainUtil isNerve:fromChain] && ![ChainUtil isNerve:toChain]) {
        return [self getAssetAvailableWithFromChain:fromChain andToChain:NERVE andAsset:assetModel] && [self getAssetAvailableWithFromChain:NERVE andToChain:toChain andAsset:assetModel];
    }
    if ([ChainUtil isNulsSeries:fromChain] && [ChainUtil isNulsSeries:toChain]) {
        return assetModel.nulsCross;
    }
    if ([ChainUtil isNerve:fromChain] &&[ChainUtil isHeterChain:toChain]) {
        if (!assetModel.heterogeneousList || assetModel.heterogeneousList.count == 0) {
            return NO;
        }else{
            NSArray * heterNames = [assetModel.heterogeneousList valueForKeyPath:@"chainName"];
            return [heterNames containsObject:toChain];;
        }
    }
    return YES;
}

- (IBAction)setSpeedButtonClick:(UIButton *)sender {
     self.speedButton.selected = !self.speedButton.selected;
    [self updatefee];
    [GlobalVariable sharedInstance].feeLevel = sender.selected ? 1.3 :1;
}

// 1 查询授权额度 2 授权
- (BOOL)hetTokenAllowanceWithType:(int)type{
    
    // 这里根据fromChain获取三个异构链的网络接口地址  chainId multyAddress
    NSString *publicUrl;
    NSString *chainId;
    NSString *multyAddress;
    if ([self.transferModel.fromChain isEqualToString:@"Ethereum"]) {
        publicUrl = ETH_PUBLIC_URL;
        chainId = ETH_PUBLIC_CHAINID;
        multyAddress = ETH_MULTY_ADDRESS;
    } else if ([self.transferModel.fromChain isEqualToString:@"BSC"]) {
        publicUrl = BSC_PUBLIC_URL;
        chainId = BSC_PUBLIC_CHAINID;
        multyAddress = BSC_MULTY_ADDRESS;
    } else if ([self.transferModel.fromChain isEqualToString:@"Heco"]) {
        publicUrl = HECO_PUBLIC_URL;
        chainId = HECO_PUBLIC_CHAINID;
        multyAddress = HECO_MULTY_ADDRESS;
    } else if ([self.transferModel.fromChain isEqualToString:@"OKExChain"]) {
        publicUrl = OKT_PUBLIC_URL;
        chainId = OKT_PUBLIC_CHAINID;
        multyAddress = OKT_MULTY_ADDRESS;
    }
    PKWeb3Objc *web3 = [PKWeb3Objc sharedInstance];
    [web3 setEndPoint:publicUrl AndChainID:chainId];
    
    if (type == 1) {
        BOOL allowance = [NerveTools needERC20Allowance:web3 Owner:self.transferModel.fromAddress ERC20Contract:self.transferModel.assetModel.contractAddress Spender:multyAddress];
        if (allowance) {
            return YES;
        }
    }else{
        WalletNamePopView *nameView = [WalletNamePopView instanceView];
        nameView.popType = WalletPopTypePassword;
        WS(weakSelf);
        nameView.nameBlock = ^(WalletNamePopView * _Nonnull nameView, NSString * _Nonnull name) {
            SS(strongSelf);
            NSString *privateKey = [WalletUtil decryptPrivateKey:self.walletModel.encryptPrivateKey password:name];
            if (![self.walletModel.password isEqualToString:name] || ![privateKey isHaveValue]) {
                [KAppDelegate.window makeToast:KLocalizedString(@"password_error") duration:2 position:CSToastPositionTop ];
            }else{
                [nameView hideView];
                
                NSString *approveTx = [NerveTools approveERC20:web3 PriKey:privateKey ERC20Contract:self.transferModel.assetModel.contractAddress ERC20Decimals:18 To:multyAddress Value:@"39600000000000000000000000000"];
                NSString *res = [web3.eth sendSignedTransaction:approveTx];
                NSLog(@"广播token授权交易 : %@", res);
                if (res && res.length) {
                    [KAppDelegate.window showNormalToast:KLocalizedString(@"auth_success")];
                    strongSelf.isAllowing = NO;
                    [strongSelf.confirmButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
                }else{
                    [KAppDelegate.window showNormalToast:KLocalizedString(@"balance_not_enough")];
                }
            }
        };
        [nameView showInController:self preferredStyle:TYAlertControllerStyleAlert];
        return NO;
    }
    
    return NO;
}

/***  判断当前选择资产否为主资产 **/
- (BOOL)isMainAsset{
    ConfigMainAssetModel *mainAssetModel = [[GlobalVariable sharedInstance] getMainAssetWithChain:self.transferModel.fromChain];
    if (self.transferModel.assetModel.chainId == mainAssetModel.chainId && self.transferModel.assetModel.assetId == mainAssetModel.assetId)  {
        return YES;
    }
    return NO;
}

/***  获取主资产资产对象 **/
- (AssetListResModel *)filterMainAssetModel{
    AssetListResModel *res;
    ConfigMainAssetModel *mainAssetModel = [[GlobalVariable sharedInstance] getMainAssetWithChain:self.transferModel.fromChain];
    for (int i = 0; i< self.assetArray.count; i++) {
        AssetListResModel *temp = self.assetArray[i];
        if (temp.chainId == mainAssetModel.chainId && temp.assetId == mainAssetModel.assetId) {
            res = self.assetArray[i];
            break;
        }
    }
    return res;
}

/** 获取通用配置 */
- (FTPopOverMenuConfiguration *)getMenuConfiguration
{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = 120;
    configuration.backgroundColor = KColorWhite;
    configuration.borderColor = kColorBorder;
    configuration.textColor = KColorBlack;
    configuration.selectedTextColor = KColorSkin1;
    configuration.separatorColor = kColorLine;
    configuration.selectedCellBackgroundColor = KColorBg;
    configuration.textAlignment = NSTextAlignmentCenter;
    return configuration;
}


- (TransferFeeUtil *)feeUtil
{
    if (!_feeUtil) {
        _feeUtil = [[TransferFeeUtil alloc] init];
    }
    return _feeUtil;
}


// 小数点位数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isHavePoint;
    int len = self.transferModel.assetModel.decimals;
    //对复制黏贴也有效
    int location = (int)[textField.text rangeOfString:@"."].location;
    if (location > 0) {
        isHavePoint = YES; //isHavePoint 是BOOL型
    }else
    {
        isHavePoint = NO;
    }
    
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//输入格式正确
        {
            if ([textField.text length] == 0) {
                if (single == '.') {
                    //                    [self.view makeToast:@"亲，第一个数字不能为小数点"];
                    return NO;
                }
                //                if (single == '0') {
                //                    [self.view makeToast:@"亲，第一个数字不能为0"];
                //                    return NO;
                //                }
            }
            if (single == '.') {
                if (!isHavePoint) {
                    isHavePoint = YES;
                    return YES;
                }
                if (isHavePoint) {
                    //                    [self.view makeToast:@"亲，您已经输入过小数点了"];
                    return NO;
                }
            }else
            {
                //判断小数点的位数
                if (isHavePoint) {
                    NSRange pointRange = [textField.text rangeOfString:@"."];
                    int location = (int)range.location - (int)pointRange.location;
                    if (location <= len) {
                        return YES;
                    }else
                    {
                        [self.view showNormalToast:[NSString stringWithFormat:@"%@%d",KLocalizedString(@"decimal_max"),len]];
                        return NO;
                    }
                }else
                {
                    return YES;
                }
            }
        }else
        {
            //            [self.view makeToast:@"亲，您输入的格式不正确"];
            return NO;
        }
    }else
    {
        return YES;
    }
    return YES;
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
