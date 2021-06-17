//
//  TransferViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.


#import "TransferViewControllers.h"
#import "TransferConfirmViewController.h"
#import "ContactListViewController.h"
#import "GasLimitModel.h"
#import "GasPriceModel.h"
#import "FeeLevelSelectView.h"
#import "FTPopOverMenu.h"
#import "TransferChainSelectView.h"
#import "TransferFeeUtil.h"
#import "SWQRCodeViewController.h"
#import "NerveTools.h"
#import "WalletNamePopView.h"
@interface TransferViewControllers ()<UITextFieldDelegate,TransferChainSelectViewDelegate,TransferFeeUtilDelegate,FeeLevelSelectViewDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chainViewHeight;
@property (strong, nonatomic) IBOutlet UIView *chainButtonView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *chainButtonViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *chainTitleView;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UIView *addressBgView;

@property (strong, nonatomic) IBOutlet UILabel *actualLabel;
@property (strong, nonatomic) IBOutlet UILabel *usableAmountLabel;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UIButton *maxAmountButton;


@property (strong, nonatomic) IBOutlet UIView *feeBgView;
@property (strong, nonatomic) IBOutlet UILabel *feeTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *feeValueLabel;

@property (strong, nonatomic) IBOutlet UIView *noteView;
@property (strong, nonatomic) IBOutlet UIView *noteInfoBgView;
@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet UITextField *noteTextField;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nextButtonBottom;
@property (strong, nonatomic) IBOutlet UIButton *assetChooseButton;
@property (strong, nonatomic) IBOutlet UIView *assetChooseView;
@property (strong, nonatomic) IBOutlet UIButton *crossChainWarningButton;
@property (strong, nonatomic) IBOutlet UILabel *errorAddressLabel;

@property (nonatomic, strong) NSMutableArray *assetArray; // 资产列表
@property (nonatomic, strong) WalletModel *walletModel; // 当前钱包数据model
@property (nonatomic, strong) TransferTempModel*transferModel;
@property (nonatomic, strong) FeeLevelSelectView *feeLevelView;
@property (nonatomic, strong) TransferChainSelectView *chainSelectView;
@property (nonatomic, strong) TransferFeeUtil *feeUtil;



@property (nonatomic ,assign) BOOL clickAll; // 点击全部 计算手续费后 显示剩余金额
@property (nonatomic ,assign) BOOL agree; // 是否接受警告内容
@property (nonatomic ,assign) BOOL isAllowing; // 正在授权
@end

@implementation TransferViewControllers

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [self getBarButtonItemWithImage:ImageNamed(@"icon_screen") action:@selector(richScanAction:)];
    [GlobalVariable sharedInstance].feeLevel = 1;
    self.walletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
    
    self.transferModel = [TransferTempModel new];
    self.transferModel.fromAddress = self.assetListModel.address;
    self.transferModel.fromChain = self.assetListModel.chain;
    [self updateUI];
    [self getAssetList];
}

#pragma mark - 查询当前链资产列表
- (void)getAssetList{
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_ADRESS_ASEETS dataModel:self.assetListModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        if (success) {
            DLog(@"链-资产列表%@",dataObj);
            strongSelf.assetArray = [NSMutableArray arrayWithArray:[AssetListResModel mj_objectArrayWithKeyValuesArray:dataObj]];
            if (strongSelf.assetArray.count >0) {
                AssetListResModel *assetInfoModel = [self getCurrentChainMainAssetModel];
                strongSelf.transferModel.assetModel = assetInfoModel;
                [strongSelf.assetChooseButton setTitle:assetInfoModel.symbol forState:UIControlStateNormal];
                [self.assetChooseButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
                strongSelf.usableAmountLabel.text = [NSString stringWithFormat:@"%@:%@",KLocalizedString(@"available"),[Common formatValueWithValue:assetInfoModel.balance  andDecimal:assetInfoModel.decimals ]];
            }
        } else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}
#pragma  扫码
- (void)richScanAction:(UIBarButtonItem *)sender{
    SWQRCodeViewController *qrCodeVC = [[SWQRCodeViewController alloc] init];
    SWQRCodeConfig *config = [[SWQRCodeConfig alloc]init];
    config.scannerType = SWScannerTypeQRCode;
    qrCodeVC.codeConfig = config;
    qrCodeVC.title = @"扫码";
    WS(weakSelf);
    qrCodeVC.resultBlock = ^(NSString *result) {
        SS(strongSelf);
        DLog(@"扫描内容->%@",result);
        strongSelf.addressTextField.text = result;
        [strongSelf updateToChain];
        [strongSelf decideAddress];
    };
    [qrCodeVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:qrCodeVC animated:YES];
}


#pragma mark - Action
// 选择资产
- (IBAction)chooseAssetAction:(UIButton *)sender {
    DLog(@"%@",self.transferModel.toChain);
    if (![self.transferModel.toChain isHaveValue]) {
        [self.view makeToast:KLocalizedString(@"choose_network")];
        return;
    }
    NSArray *nameArray = [self getAvailableAssetList];
    DLog(@"%@:%@",nameArray,self.transferModel.toChain);
    WS(weakSelf);
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = 100.f;
    configuration.backgroundColor = KColorWhite;
    configuration.borderColor = kColorBorder;
    configuration.textColor = KColorBlack;
    configuration.separatorColor = kColorLine;
    configuration.selectedCellBackgroundColor = KColorBg;
    configuration.textAlignment = NSTextAlignmentCenter;
    [FTPopOverMenu showForSender:sender
                   withMenuArray:nameArray
                      imageArray:nil
                   configuration:configuration
                       doneBlock:^(NSInteger selectedIndex)
     {
         SS(strongSelf);
         //赋值选择的资产
         for (int i = 0; i< strongSelf.assetArray.count; i++) {
             AssetListResModel *model = strongSelf.assetArray[i];
             if ([model.symbol isEqualToString:nameArray[selectedIndex]]) {
                 strongSelf.transferModel.assetModel = model;
             }
         }
//         strongSelf.transferModel.assetModel = strongSelf.assetArray[selectedIndex];
         strongSelf.amountTextField.text = @""; // 选择资产后清空金额框
         //选择资产后更新手续费
         [strongSelf updateFee];
         
         //更新视图
         NSString *name = nameArray[selectedIndex];
         [strongSelf.assetChooseButton setTitle:name forState:UIControlStateNormal];
         [self.assetChooseButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
         strongSelf.usableAmountLabel.text = [NSString stringWithFormat:@"%@:%@",KLocalizedString(@"available"),[Common decimalwithFormatByDecimal:[strongSelf.transferModel.assetModel.balance doubleValue] andDecimal:strongSelf.transferModel.assetModel.decimals ]];
         // 更新手续费
         [strongSelf updateFee];
         // 是否需要授权
         // 跨链合约交易-需要查询授权额度
         if (![strongSelf.transferModel.fromChain isEqualToString:strongSelf.transferModel.toChain] && [ChainUtil isHeterChain:self.transferModel.fromChain] && [strongSelf.transferModel.assetModel.contractAddress isHaveValue]) {
             BOOL needAllow =  [self hetTokenAllowanceWithType:1];
             if (needAllow) {
                 strongSelf.isAllowing = YES;
                 [strongSelf.nextButton setTitle:KLocalizedString(@"authorization") forState:UIControlStateNormal];
                 [KAppDelegate.window showNormalToast:KLocalizedString(@"auth_token")];
             }
         }else{
             if (self.isAllowing) {
                 strongSelf.isAllowing = NO;
                 [strongSelf.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
             }
         }
     } dismissBlock:nil];
}

//选择联系人
- (IBAction)selectContactButtonClick:(id)sender {
    ContactListViewController *listVC = [[ContactListViewController alloc] init];
    WS(weakSelf);
    listVC.selectBlock = ^(ContactsModel * _Nonnull model) {
        SS(strongSelf);
        strongSelf.addressTextField.text = model.address;
        [strongSelf updateToChain];
        [self decideAddress];
    };
    [self.navigationController pushViewController:listVC animated:YES];
}

// 点击全部可转
// 手续费模块目前规则
// 1 如果转账资产是主资产需要扣除手续费
// 2 对金额输入框进行限制 防止输入小数点位数大于有效位

- (IBAction)maxAmountButtonClick:(UIButton *)sender {
    if (![self.transferModel.toChain isHaveValue]) {
        return;
    }
    if ([self.transferModel.assetModel.balance doubleValue] > 0 ) {
        if ([self isMainAsset]) {
            self.clickAll = true; // 如果是主资产则需要计算手续费后显示
        }else{
            self.amountTextField.text = [NSString stringWithFormat:@"%@",[Common decimalwithFormatByDecimal:[self.transferModel.assetModel.balance doubleValue]  andDecimal:self.transferModel.assetModel.decimals]];
        }
        //输入金额后更新手续费
        [self updateFee];
    }
}

//下一步  成功后跳转确认支付页
- (IBAction)nextButtonClick:(id)sender {
    if (![self.transferModel.toChain isHaveValue]) {
        [KAppDelegate.window showNormalToast:KLocalizedString(@"choose_network")];
        return;
    }
    // 正在授权 点击确认按钮发起授权
    if (self.isAllowing) {
        [self hetTokenAllowanceWithType:2];
        return;
    }
    
    NSString *toAddress = self.addressTextField.text;
    //请输入转账地址
    if (![toAddress isHaveValue]) {
        [KAppDelegate.window showNormalToast:KLocalizedString(@"please_enter_the_transfer_address")];
        return;
    }
    // 验证地址合法性
    if (![ChainUtil isCorrectAddress:toAddress withChain:self.transferModel.toChain]) {
        [KAppDelegate.window showNormalToast:KLocalizedString(@"error_address")];
        return;
    }
    
    
    NSString *amount = self.amountTextField.text;
    NSString *remark = self.noteTextField.text;
    if(![self.amountTextField.text isHaveValue]){
        [KAppDelegate.window showNormalToast:KLocalizedString(@"please_enter_the_amount_of_transfer")];
        return;
    }
    //余额不足
    if([self.transferModel.assetModel.balance doubleValue] / pow(10, self.transferModel.assetModel.decimals)  < [amount doubleValue]  ){
        [KAppDelegate.window showNormalToast:KLocalizedString(@"balance_not_enough")];
        return;
    }
    if ([amount isEqualToString:@"0"] || ![self balanceIsEnough]) {
        [KAppDelegate.window showNormalToast:KLocalizedString(@"balance_not_enough")];
        return;
    }
    //备注超长
    if (remark.length > 100) {
        [KAppDelegate.window showNormalToast:KLocalizedString(@"parameter_error_overlong_notes")];
        return;
    }
    
    // 跨链必须允许警告内容
    if (![self.transferModel.fromChain isEqualToString:self.transferModel.toChain] && !self.agree) {
        return;
    }
    
    TransferConfirmViewController *confirmVC = [[TransferConfirmViewController alloc] init];
    self.transferModel.amount = amount;
    self.transferModel.toAddress = toAddress;
    self.transferModel.remark = remark;
    confirmVC.transModel = self.transferModel;
    confirmVC.feeValueStr = self.feeValueLabel.text;
    [self.navigationController pushViewController:confirmVC animated:YES];
}

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

    BOOL enough = [[Common Num1:[self.transferModel.assetModel.balance doubleValue]  withNum1decimal:self.transferModel.assetModel.decimals subtractingWithNum2:fee] doubleValue] >= [self.amountTextField.text doubleValue];
    return enough;
    }
    return YES;
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
        return allowance;
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
                [strongSelf.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
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


#pragma mark - uddateUI
- (void)updateUI
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.navigationItem.title = KLocalizedString(@"transfer_accounts");
    
    self.toLabel.text = KLocalizedString(@"transfer_to");
    self.addressTextField.placeholder = KLocalizedString(@"enter_the_receipt_address");
    self.actualLabel.text = KLocalizedString(@"actual_achievement");
    self.amountTextField.placeholder = KLocalizedString(@"transfer_amount");
    [self.assetChooseView setCircleWithRadius:6];
    [self.assetChooseView setborderWithBorderColor:kColorBorder Width:1];
    self.chainTitleView.text = KLocalizedString(@"receive_network");
    
    self.noteLabel.text = KLocalizedString(@"remark");
    self.noteTextField.placeholder = KLocalizedString(@"input_remark");
    [self.nextButton setTitle:KLocalizedString(@"next") forState:UIControlStateNormal];
    [self.maxAmountButton setTitle:KLocalizedString(@"all") forState:UIControlStateNormal];
    self.feeTextLabel.text = KLocalizedString(@"service_charge");
    self.feeValueLabel.hidden = NO;
    self.feeLevelView.hidden = YES;
    
    [self.addressBgView setCircleWithRadius:6];
    [self.addressBgView setborderWithBorderColor:kColorBorder Width:1];
    
    [self.noteInfoBgView setCircleWithRadius:6];
    [self.noteInfoBgView setborderWithBorderColor:kColorBorder Width:1];
    
    [self.assetChooseButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    
    [self.crossChainWarningButton setTitle:KLocalizedString(@"transfer_warning") forState:UIControlStateNormal];
    self.errorAddressLabel.text = KLocalizedString(@"error_address_type");
    self.errorAddressLabel.hidden = YES;
    //更新接收网络
    [self updateToChain];
    
    if (iPhone5) {
        self.nextButtonBottom.constant = 0;
    }
}

- (IBAction)crossChainWarningButtonClick:(UIButton *)sender {
    self.crossChainWarningButton.selected = !self.crossChainWarningButton.selected;
    self.agree = sender.selected;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

//文本输入框的输入完成监听
- (void)textFieldTextChanged:(NSNotification *)sender
{
    UITextField *textField = (UITextField *)sender.object;
    if (textField.tag == 100) {
        //更新接收网络显示
        [self updateToChain];
    } else if (textField.tag == 101) {
        //余额不足
        if([self.transferModel.assetModel.balance doubleValue] / pow(10, self.transferModel.assetModel.decimals)  < [self.amountTextField.text doubleValue]  ){
            [KAppDelegate.window showNormalToast:KLocalizedString(@"balance_not_enough")];
        }
        //输入金额后更新手续费
        [self updateFee];
    } else if (textField.tag == 102) {
        //备注
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag != 101) {
        return YES;
    }
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
                    return NO;
                }
            }
            if (single == '.') {
                if (!isHavePoint) {
                    isHavePoint = YES;
                    return YES;
                }
                if (isHavePoint) {
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
            return NO;
        }
    }else
    {
        return YES;
    }
    return YES;
}

#pragma mark - 更新接收网络
- (void)updateToChain
{
    // 转账页面根据当前链 显示不同的接受链
    // 1 发送者为nerve地址则网络标签处展示全部5条网络，
    // 2 发送者为其余4条网络，则网络标签处展示发送网络和Nerve网络2个标签
    // 3 若发送地址为Nerve，当接收地址为NULS或nerve，自动选中对应网络标签，其余网络标签消失。
    // 4 若发送者为非Nerve地址，用户就只能填入本链地址或者Nerve地址，则当用户填入接收地址后，自动选中网络标签
    
    self.transferModel.toChain = @"";
    NSArray *chainNameArr;
    NSString *address = self.addressTextField.text;
    NSString *chain = [ChainUtil ChainFromAddress:address]; // 根据地址获取链 NULS和NERVE链
    if ([ChainUtil isNerve:self.transferModel.fromChain]) {// 1 发送网络为NERVE
        if (chain.length > 0) { // 接受链为NULS或者NERVE链
            chainNameArr = @[chain];
            self.transferModel.toChain = chain;
        } else if([ChainUtil isHeterAddress:address]){ // 是异构链
            chainNameArr = @[@"Ethereum",@"BSC",@"Heco",@"OKExChain"];
        } else { // 未识别
            chainNameArr = @[NULS,NERVE,@"Ethereum",@"BSC",@"Heco",@"OKExChain"];
        }
    } else if ([ChainUtil isNuls:self.transferModel.fromChain]) { // 2 发送网络为NULS
        if (chain.length >0) {
            chainNameArr = @[chain];
            self.transferModel.toChain = chain;
        } else { // 未识别
            chainNameArr = @[NULS,NERVE];
        }
    } else { // 发送网络为异构链
        if ([ChainUtil isNerveAddress:address]) { // 如果是NERVE地址则NERVE链
            chainNameArr = @[NERVE];
            self.transferModel.toChain = chain;
        } else if ([ChainUtil isHeterAddress:address]){ // 是异构链则是本链交易
            chainNameArr = @[self.transferModel.fromChain];
        } else { // 未识别
            chainNameArr = @[NERVE,self.transferModel.fromChain];
        }
    }
    //接收网络列表传值
    self.chainSelectView.chainArr = chainNameArr;
    // 更新入金链后处理
    [self updateChainAfterHander];
    
    WS(weakSelf);
    self.chainSelectView.selectChainBlock = ^(NSString * _Nonnull chain) {
        SS(strongSelf);
        strongSelf.transferModel.toChain = chain;
        [strongSelf updateChainAfterHander];
    };
}

// 更新链后清理交易金额 更新手续费 更新备注显示
- (void)updateChainAfterHander{
    [self clearTradeAmount];
    [self updateFee];
    [self updateRemarkViewShow];
    [self updateCrossChainWarning];
}

// 更新入金链或者地址错误界面
- (void)decideAddress{
    // 如果地址不合法
    // nuls链 toAddress不是nuls也不是nerve
    NSString *toAddress = self.addressTextField.text;
    if (toAddress.length>0&& [ChainUtil isNuls:self.transferModel.fromChain] && (![ChainUtil isNulsAddress:toAddress]) && ![ChainUtil isNerveAddress:toAddress]) {
        self.errorAddressLabel.hidden = NO;
        self.chainButtonView.hidden = YES;
    }else{
        self.errorAddressLabel.hidden = YES;
        self.chainButtonView.hidden = NO;
    }
}

#pragma mark - 更新手续费
- (void)updateFee
{
    self.feeValueLabel.hidden = NO;
    self.feeLevelView.hidden = YES;
    // 点击全部的情况没得金额也可以计算手续费
    if ([self.addressTextField.text isHaveValue] == NO
        || [self.transferModel.toChain isHaveValue] == NO
        || (self.amountTextField.text.doubleValue == 0 && !self.clickAll))
    {
        self.feeValueLabel.text = @"--";
        return;
    }
    // 出金链
    NSString *fromChain = self.transferModel.fromChain;
    // 入金链
    NSString *toChain = self.transferModel.toChain;
    //是否为本链
    BOOL sameChain = [fromChain isEqualToString:toChain];
    //是否为合约资产
    BOOL isContractAddress = self.transferModel.assetModel.contractAddress.length;
    
    if ([ChainUtil isNuls:fromChain]) { // 1 NULS转账
        if (isContractAddress) { // 1 - 1 NULS转合约资产
            //如果选择合约资产 通过接口获取gas from链是合约
            NSString *amount = [NSString stringWithFormat:@"%.0f",[self.amountTextField.text doubleValue] * pow(10, self.transferModel.assetModel.decimals)];
            [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsContractAddress transferModel:self.transferModel toAddress:self.addressTextField.text amount:amount];
        } else { // 1-2 NULS转非合约资产  NULS都是0.001 非NULS 0.01
            NSString *feeNumStr;
            if (sameChain) {
                feeNumStr = @"0.001";
            } else {
                feeNumStr = @"0.01";
            }
            self.feeValueLabel.text = [NSString stringWithFormat:@"%@NULS",feeNumStr];
        }
        [self setAvailableAmountOmitFee];
    } else if ([fromChain isEqualToString:@"NERVE"]) {// 2 NERVE转账
        if ([toChain isEqualToString:@"NERVE"]) { // 2-1 NERVE->NERVE
            //NEVER链内转账手续费为0
            self.feeValueLabel.text = @"0NVT";
            [self setAvailableAmountOmitFee];
        } else if ([toChain isEqualToString:@"NULS"]) { // 2-2 nerve->nuls
            self.feeValueLabel.text = @"0.01NULS + 0.01NVT";
            [self setAvailableAmountOmitFee];
        } else { // 2-3 never->heter
            //nerve->异构链
            [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsNVTCroee transferModel:self.transferModel];
        }
    } else {
        // from链是异构链的情况
        [self.feeUtil getTransferFeeWithType:TransferFeeTypeIsFromIsomerism transferModel:self.transferModel];
    }
    
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
    self.amountTextField.text = [NSString stringWithFormat:@"%@",[Common Num1:[self.transferModel.assetModel.balance doubleValue]  withNum1decimal:self.transferModel.assetModel.decimals subtractingWithNum2:fee]];
    self.clickAll = false;
}

// 清理手续费 选择网络后 手续费和输入框清空
- (void)clearTradeAmount{
    self.amountTextField.text = @"";
}

// 判断金额小数点是否合法
//- (BOOL)amountDecimalsIsFitAmount:(NSString *)amount{
//
//    if ([amount containsString:@"."]) {
//        NSRange subRange = [amount rangeOfString:@"."];
//        if (amount.length - subRange.location > self.transferModel.assetModel.decimals) {
//            [self.view makeToast:[NSString stringWithFormat:@"%@%d",KLocalizedString(@"decimal_max"),self.transferModel.assetModel.decimals]];
//            return NO;
//        }
//    }
//    return YES;
//}

/** 手续费请求更新代理 */
- (void)transferFeeDidReceiveType:(TransferFeeType)type transferModel:(TransferTempModel *)transferModel
{
    if (type == TransferFeeTypeIsContractAddress) {
        NSString *feeStr = [Common decimalNotPOWWithFormatByDecimal:transferModel.fee andDecimal:transferModel.assetModel.decimals];
        self.transferModel.fee = transferModel.fee;
        self.feeValueLabel.text = [NSString stringWithFormat:@"%@NULS",feeStr];
    } else {
        //分三级手续费
        ConfigMainAssetModel *mainAssetModel = [[GlobalVariable sharedInstance] getMainAssetWithChain:transferModel.fromChain];
        NSArray *feeLevelArr = [self getThirdLevelFeeArrayWithBaseFee:transferModel.fee andSymbol:mainAssetModel.symbol];
        self.feeLevelView.feeArr = feeLevelArr;
        self.feeLevelView.hidden = NO;
        [self.feeBgView bringSubviewToFront:self.feeLevelView];
        if ([self.feeValueLabel.text isEqualToString:@"--"]) {
            self.transferModel.fee = [feeLevelArr[1] doubleValue];
            self.feeValueLabel.text = feeLevelArr[1];
        }
        // 点击全部 获取手续费成功后 减去手续费
        [self setAvailableAmountOmitFee];
    }
}

/** 获取三级数据费数据**/
- (NSMutableArray *)getThirdLevelFeeArrayWithBaseFee:(double )fee andSymbol:(NSString *)symbol{
    NSArray * levelArray = @[@(0.8),@(1),@(1.3)];
    NSMutableArray *feeArray = [NSMutableArray new];
    for (int i = 0; i < levelArray.count; i++) {
        NSDecimalNumber *feeNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf",fee]];
        NSString *level = [NSString stringWithFormat:@"%@",levelArray[i]];
        NSDecimalNumber *levelNumber = [NSDecimalNumber decimalNumberWithString:level];
        NSDecimalNumber *result = [feeNumber decimalNumberByMultiplyingBy:levelNumber];
        NSString *str= [NSString stringWithFormat:@"%@%@",result,symbol];
        
        [feeArray addObject:str];
    }
    return feeArray;
}


/** 手续分级选择 */
- (void)feeLevelDidSelect:(NSInteger)index feeValue:(NSString *)feeValue
{
    self.transferModel.fee = [feeValue doubleValue];
    self.feeValueLabel.text = feeValue;
    [GlobalVariable sharedInstance].feeLevel = index == 0? 0.8:index==1?1:1.3;
}

/**跨链交易隐藏备注 */
- (void)updateRemarkViewShow{
    if (self.transferModel.toChain.length == 0) {
        return;
    }
    self.noteView.hidden = ![self.transferModel.fromChain isEqualToString:self.transferModel.toChain];
    if (self.noteView.hidden) {
        self.transferModel.remark = @"";
        
    }
}

/*** 跨链交易显示跨链警告**/
- (void)updateCrossChainWarning{
    if (self.transferModel.toChain.length == 0) {
        return;
    }
    self.crossChainWarningButton.hidden = [self.transferModel.fromChain isEqualToString:self.transferModel.toChain];
}

#pragma mark - 通用函数
/** 根据地址获取对应的网络链 */
- (NSString *)getChainWithCurrentAddress{
    NSString *address =  self.addressTextField.text;
    NSString *chain = @"";
    if ([address hasPrefix:PREFIX]) {
        chain = @"NULS";
    } else if ([address hasPrefix:NVT_PREFIX]){
        chain = @"NERVE";
    }
    // 更新当前网络链
    self.transferModel.toChain = chain;
    return chain;
}

/** 是异构链 异构链根据地址无法判断具体是哪个链 需要用户手动选择 */
- (BOOL)isHetChainWithAddress:(NSString *)address{
    if ([address hasPrefix:@"0x"]) {
        return YES;
    }
    return NO;
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
    //    1 如果是nuls和Nerve交易需判断nulsCross=true
    //    2 如果是nerve->异构链需判断heterogeneousList包含toChain
    BOOL available = YES;
    if ([ChainUtil isNulsSeries:fromChain] && [ChainUtil isNulsSeries:toChain]) {
        available = assetModel.nulsCross;
    }
    if ([ChainUtil isNerve:fromChain] &&[ChainUtil isHeterChain:toChain]) {
        DLog(@"%@ %@",toChain, [assetModel mj_keyValues]);
        if (!assetModel.heterogeneousList || assetModel.heterogeneousList.count == 0) {
            available = NO;
        }else{
            NSArray * heterNames = [assetModel.heterogeneousList valueForKeyPath:@"chainName"];
            available = [heterNames containsObject:toChain];
            DLog(@"%@:%@",heterNames,assetModel.symbol);
        }
    }
    return available;
}
/***  获取主资产资产对象 **/
- (AssetListResModel *)getCurrentChainMainAssetModel{
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

/***  判断当前选择资产否为主资产 **/
- (BOOL)isMainAsset{
    AssetListResModel *mainAssetModel = [self getCurrentChainMainAssetModel];
    if (self.transferModel.assetModel.chainId == mainAssetModel.chainId && self.transferModel.assetModel.assetId == mainAssetModel.assetId)  {
        return YES;
    }
    return NO;
}

#pragma mark - lazy loading

- (TransferChainSelectView *)chainSelectView
{
    if (!_chainSelectView) {
        _chainSelectView = [[TransferChainSelectView alloc] init];
        _chainSelectView.delegate = self;
        [self.chainButtonView addSubview:_chainSelectView];
        [_chainSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.chainButtonView);
        }];
    }
    return _chainSelectView;
}

- (FeeLevelSelectView *)feeLevelView
{
    if (!_feeLevelView) {
        _feeLevelView = [FeeLevelSelectView instanceView];
        _feeLevelView.delegate = self;
        [self.feeBgView addSubview:_feeLevelView];
        [_feeLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.feeTextLabel);
            make.top.equalTo(self.feeTextLabel.mas_bottom).offset(8);
            make.right.mas_equalTo(-15);
            //            make.width.mas_equalTo(180);
            make.height.mas_equalTo(32);
        }];
    }
    return _feeLevelView;
}

- (TransferFeeUtil *)feeUtil
{
    if (!_feeUtil) {
        _feeUtil = [[TransferFeeUtil alloc] init];
        _feeUtil.delegate = self;
    }
    return _feeUtil;
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
