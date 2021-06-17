//
//  TransferConfirmViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "TransferConfirmViewController.h"
#import "ImportWalletSuccessView.h"
#import "ComposeTransferModel.h"
#import "WalletNamePopView.h"
#import "AssetsDetalsViewController.h"
#import "ComposeTransferModel.h"
#import "AssetInfoModel.h"
#import "ConfigModel.h"
#import "ComposeCrossChainTransferModel.h"
#import "NerveTools.h"
#import "NeverMapAssetModel.h"
@interface TransferConfirmViewController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UIButton *fromInfoButton;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UIButton *toInfoButton;
@property (strong, nonatomic) IBOutlet UILabel *minersLabel;
@property (strong, nonatomic) IBOutlet UILabel *minersInfoLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonHeight;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkInfoLabel;
@property (nonatomic, strong) WalletModel *walletModel;
@property (nonatomic ,strong) NSString *privateKey;
@property (nonatomic ,assign) BOOL needCompose; // 是否需要组合2次交易
@property (nonatomic,strong) AssetListResModel *middleAssetModel; // 2次交易且fromChain是异构链需要中间资产

@property (nonatomic ,assign) BOOL nulsToEthSync; // nuls->eth同步变量
@end

@implementation TransferConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.walletModel = [WalletModel mj_objectWithKeyValues:[UserDefaultsUtil getNowWallet]];
    [self updateUI];
    DLog(@"确认交易:TransferTempModel%@",[self.transModel mj_keyValues]);
    
    self.needCompose = [ChainUtil needComposeHashFromChain:self.transModel.fromChain andToChain:self.transModel.toChain];
    // 获取中间资产 用于2次交易第二次
    if (self.needCompose && [ChainUtil isHeterChain:self.transModel.fromChain]) {
        [self getMiddleAssetInfo];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    KHideHUD;
}

- (void)updateUI
{
    self.navigationItem.title = KLocalizedString(@"transfer_accounts");
    self.view.backgroundColor = KColorPrimary;
    self.orderLabel.text = KLocalizedString(@"receive_network");
    self.fromLabel.text = KLocalizedString(@"from");
    self.toLabel.text = KLocalizedString(@"transfer_to");
    self.minersLabel.text = KLocalizedString(@"miners_fees");
    self.remarkLabel.text = KLocalizedString(@"remark");
    self.remarkInfoLabel.text = self.transModel.remark?:@"--";
    [self.confirmButton setTitle:KLocalizedString(@"confirmation_transfer") forState:UIControlStateNormal];
    [self.fromInfoButton setTitle:self.transModel.fromAddress forState:UIControlStateNormal];
    [self.toInfoButton setTitle:self.transModel.toAddress forState:UIControlStateNormal];
    if ([LanguageUtil getUserLanguageType] == LANGUAGETYPEEN) {
        self.leftLabelWidth.constant = 120;
    }
    
    // 转账资产图标,转账金额 ,手续费
    [self.iconImageView sd_setImageWithURL:KURL(AliyunImageUrl(self.transModel.assetModel.symbol)) placeholderImage:ImageNamed(@"default_pic")];
    self.orderInfoLabel.text = self.transModel.toChain;
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@",self.transModel.amount ,self.transModel.assetModel.symbol];
    
    // 显示手续费
    self.minersInfoLabel.text = self.feeValueStr;
}

// 获取中间资产 用于2次交易第二次
- (void)getMiddleAssetInfo{
    NeverMapAssetModel *reqModel = [NeverMapAssetModel new];
    reqModel.chain = self.transModel.fromChain;
    reqModel.assetId = self.transModel.assetModel.assetId;
    reqModel.chainId = self.transModel.assetModel.chainId;
    reqModel.contractAddress = self.transModel.assetModel.contractAddress;
    KShowHUD;
    WS(weakSelf);
    [NetUtil requestWithType:RequestTypePost path:API_ASSET_NERVE_CHAIN_INFO dataModel:reqModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        SS(strongSelf);
        KHideHUD;
        if (success) {
            DLog(@"中间资产信息返回:%@",dataObj);
            if (dataObj) {
                strongSelf.middleAssetModel = [AssetListResModel mj_objectWithKeyValues:dataObj];
                strongSelf.middleAssetModel.chain = NERVE;
                strongSelf.middleAssetModel.address = strongSelf.walletModel.addressDict[NERVE];
            }
        } else {
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}
// 点击确认交易按钮
- (IBAction)confirmButtonClick:(id)sender {
    WalletNamePopView *nameView = [WalletNamePopView instanceView];
    nameView.popType = WalletPopTypePassword;
    WS(weakSelf);
    nameView.nameBlock = ^(WalletNamePopView * _Nonnull nameView, NSString * _Nonnull name) {
        SS(strongSelf);
        [strongSelf beginTransCreateTXWithPassword:name popView:nameView];
    };
    [nameView showInController:self preferredStyle:TYAlertControllerStyleAlert];
}

// 开始组装交易
- (void)beginTransCreateTXWithPassword:(NSString *)password popView:(WalletNamePopView *)popView
{
    NSString *privateKey = [WalletUtil decryptPrivateKey:self.walletModel.encryptPrivateKey password:password];
    if (![self.walletModel.password isEqualToString:password] || ![privateKey isHaveValue]) {
//        [self.view showNormalToast:KLocalizedString(@"password_error")];
        [KAppDelegate.window makeToast:KLocalizedString(@"password_error") duration:2 position:CSToastPositionTop ];
        [popView endEditing:YES];
        return;
    }
    KShowHUD;
    self.privateKey = privateKey;
    [popView hideView];
    if ([ChainUtil isHeterChain:self.transModel.fromChain]) {
        // 解决lading被同步阻塞问题
        [self  performSelector:@selector(delaybeginTrans) withObject:nil afterDelay:0.5];
    }else{
        //开始交易逻辑
        [self beginTransCreateFromInfoWithChain:self.transModel.fromChain crossTx:nil];
    }
}
- (void)delaybeginTrans{
    [self beginTransCreateFromInfoWithChain:self.transModel.fromChain crossTx:nil];
}

/** 根据交易类型进行逻辑处理 crossTx存在说明是组合交易的第二次交易 fromChain是本次交易的出金链*/
- (void)beginTransCreateFromInfoWithChain:(NSString *)fromChain crossTx:(NSString *)crossTx
{
    self.nulsToEthSync = NO;
    ConfigMainAssetModel *mainAssetModel = [[GlobalVariable sharedInstance] getMainAssetWithChain:fromChain];
     mainAssetModel.amount = 0.01;
    // 当前交易是否是主资产
    BOOL isMainAsset = (mainAssetModel.symbol == self.transModel.assetModel.symbol);
   
    ConfigMainAssetModel *selAssetModel = [[ConfigMainAssetModel alloc] init];
    selAssetModel.assetId = self.transModel.assetModel.assetId;
    selAssetModel.chainId = self.transModel.assetModel.chainId;
    selAssetModel.amount = self.transModel.amount.doubleValue;
    selAssetModel.address = self.transModel.assetModel.address;
    self.transModel.extraToModel = nil;
    //1 from网络是NULS
    if ([ChainUtil isNuls:fromChain]) {
        // 1-1 合约资产交易
        if ([self.transModel.assetModel.contractAddress isHaveValue]) {
            if ([ChainUtil isNuls:self.transModel.toChain]) {
                selAssetModel.amount = self.transModel.amount.doubleValue + 0.001;
            } else {
                selAssetModel.amount = self.transModel.amount.doubleValue + 0.01;
            }
            //合约使用前面计算的手续费
            if ([self.transModel.assetModel.contractAddress isHaveValue]) {
                selAssetModel.amount = self.transModel.fee;
            }
            selAssetModel.contractAddress = self.transModel.assetModel.contractAddress;
            
            [self getFromAssetListWithMainAssetArr:@[selAssetModel] fromAssetBlock:^(NSArray *fromAssetArr) {
                self.transModel.fromAssetList = fromAssetArr;
                if (self.needCompose) {
                    //开始第一次交易 获取第一次交易本地txHex
                    NSString *txSerializeHex = [self getNulsContractTxSerializeHexWithType:1];
                    //第一次交易完成 开始递归走第二次交易
                    [self beginTransCreateFromInfoWithChain:NERVE crossTx:txSerializeHex];
                } else {
                    [self genTransferTypeWithCrossTx:crossTx fromChain:fromChain];
                }
            }];
            // 1-2 NULS非合约资产交易
        } else {
            //NULS转非合约，不判断主资产 链内0.001NULS 跨链0.01NULS
            if ([ChainUtil isNuls:self.transModel.toChain]) {
                mainAssetModel.amount = 0.001;
            } else {
                mainAssetModel.amount = 0.01;
            }
            // 如果是主资产则只需一个fromModel
            if (isMainAsset) {
                selAssetModel.amount += mainAssetModel.amount;
            }
            NSArray *foo = isMainAsset? @[selAssetModel]:@[selAssetModel,mainAssetModel];
            [self getFromAssetListWithMainAssetArr:foo fromAssetBlock:^(NSArray *fromAssetArr) {
                self.transModel.fromAssetList = fromAssetArr;
                if (self.needCompose) {
                    //开始第一次交易 获取第一次交易本地txHex
                    NSString *txSerializeHex = [self getCommonCrossChainTransferTxSerializeHexWithType:1 fromChain:self.transModel.fromChain];
                    //第一次交易完成 开始递归走第二次交易
                    [self beginTransCreateFromInfoWithChain:NERVE crossTx:txSerializeHex];
                } else {
                    [self genTransferTypeWithCrossTx:crossTx fromChain:fromChain];
                }
            }];
        }
        //2 from网络是NERVE
    } else if ([ChainUtil isNerve:fromChain]) {
        if (self.needCompose && [ChainUtil isHeterChain:self.transModel.fromChain]) { // 组合的第二次交易 需要重新赋值交易资产信息
            selAssetModel.assetId = self.middleAssetModel.assetId;
            selAssetModel.chainId = self.middleAssetModel.chainId;
            selAssetModel.decimals = self.middleAssetModel.decimals;
        }
       // 2 -1 toChain是NULS
        if ([ChainUtil isNuls:self.transModel.toChain]) {
            ConfigMainAssetModel *NulsAsset = [[GlobalVariable sharedInstance] getMainAssetWithChain:NULS];
            if (isMainAsset) {
                //选择资产为NVT
                NulsAsset.amount = 0.01;
                selAssetModel.amount += 0.01;
                [self getFromAssetListWithMainAssetArr:@[selAssetModel,NulsAsset] fromAssetBlock:^(NSArray *fromAssetArr) {
                    self.transModel.fromAssetList = fromAssetArr;
                    [self genTransferTypeWithCrossTx:crossTx fromChain:fromChain];
                }];
            } else if([self.transModel.assetModel.symbol isEqualToString:NulsAsset.symbol]) {
                //选择资产为NULS
                ConfigMainAssetModel *NerveAsset = [[GlobalVariable sharedInstance] getMainAssetWithChain:NERVE];
                NerveAsset.amount = 0.01;
                selAssetModel.amount += 0.01;
                [self getFromAssetListWithMainAssetArr:@[selAssetModel,NerveAsset] fromAssetBlock:^(NSArray *fromAssetArr) {
                    self.transModel.fromAssetList = fromAssetArr;
                    [self genTransferTypeWithCrossTx:crossTx fromChain:fromChain];
                }];
            } else {
                //选择资产为其它
                ConfigMainAssetModel *NerveAsset = [[GlobalVariable sharedInstance] getMainAssetWithChain:NERVE];
                NerveAsset.amount = 0.01;
                NulsAsset.amount = 0.01;
                [self getFromAssetListWithMainAssetArr:@[selAssetModel,NulsAsset,NerveAsset] fromAssetBlock:^(NSArray *fromAssetArr) {
                    self.transModel.fromAssetList = fromAssetArr;
                    [self genTransferTypeWithCrossTx:crossTx fromChain:fromChain];
                }];
            }
            // 2-2 toChain是NERVE
        } else if ([ChainUtil isNerve:self.transModel.toChain]) {
            //NERVE->NERVE改为不要手续费
            selAssetModel.amount = self.transModel.amount.doubleValue + 0;
            [self getFromAssetListWithMainAssetArr:@[selAssetModel] fromAssetBlock:^(NSArray *fromAssetArr) {
                self.transModel.fromAssetList = fromAssetArr;
                [self genTransferTypeWithCrossTx:crossTx fromChain:fromChain];
            }];
            // 2-3 toChain是异构链
        } else { // NERVE->HETER
            AssetListResModel *extraToModel = [AssetListResModel new];
            extraToModel.amount = self.transModel.fee;
            extraToModel.assetId = mainAssetModel.assetId;
            extraToModel.chainId = mainAssetModel.chainId;
            self.transModel.extraToModel = extraToModel;
            
            if (self.needCompose) { // 需要通知获取nonce时候切换地址和链
                self.nulsToEthSync = YES;
            }
            if (isMainAsset) {
                // eg:nuls->eth 第二步
                selAssetModel.amount = self.transModel.amount.doubleValue + self.transModel.fee;
                [self getFromAssetListWithMainAssetArr:@[selAssetModel] fromAssetBlock:^(NSArray *fromAssetArr) {
                    self.transModel.fromAssetList = fromAssetArr;
                    [self genTransferTypeWithCrossTx:crossTx fromChain:fromChain];
                }];
            } else {
                selAssetModel.amount = self.transModel.amount.doubleValue;
                mainAssetModel.amount = self.transModel.fee;
                //#warning 此处是否传 assetId chainId待定
                [self getFromAssetListWithMainAssetArr:@[selAssetModel,mainAssetModel] fromAssetBlock:^(NSArray *fromAssetArr) {
                    self.transModel.fromAssetList = fromAssetArr;
                    [self genTransferTypeWithCrossTx:crossTx fromChain:fromChain];
                }];
            }
        }
        // 3 from链是异构链
    } else {
        // 这里根据fromChain获取三个异构链的网络接口地址  chainId multyAddress
        NSString *publicUrl;
        NSString *chainId;
        NSString *multyAddress;
        if ([self.transModel.fromChain isEqualToString:@"Ethereum"]) {
            publicUrl = ETH_PUBLIC_URL;
            chainId = ETH_PUBLIC_CHAINID;
            multyAddress = ETH_MULTY_ADDRESS;
        } else if ([self.transModel.fromChain isEqualToString:@"BSC"]) {
            publicUrl = BSC_PUBLIC_URL;
            chainId = BSC_PUBLIC_CHAINID;
            multyAddress = BSC_MULTY_ADDRESS;
        } else if ([self.transModel.fromChain isEqualToString:@"Heco"]) {
            publicUrl = HECO_PUBLIC_URL;
            chainId = HECO_PUBLIC_CHAINID;
            multyAddress = HECO_MULTY_ADDRESS;
        } else if ([self.transModel.fromChain isEqualToString:@"OKExChain"]) {
            publicUrl = OKT_PUBLIC_URL;
            chainId = OKT_PUBLIC_CHAINID;
            multyAddress = OKT_MULTY_ADDRESS;
        }
        PKWeb3Objc *web3 = [PKWeb3Objc sharedInstance];
        [web3 setEndPoint:publicUrl AndChainID:chainId];
        NSString *result = @"1";
        
        NSString *NERVE_ADDRESS = self.walletModel.addressDict[NERVE];
        
        //判断是否是合约交易
        if ([self.transModel.assetModel.contractAddress isHaveValue]) {
            if ([fromChain isEqualToString:self.transModel.toChain]) {
                //本链合约交易
                /** token转账 0.1个HT，from testAddress1 to testAddress2 **/
                NSString *erc20Tx = [NerveTools sendERC20:web3 PriKey:self.privateKey ERC20Contract:self.transModel.assetModel.contractAddress ERC20Decimals:self.transModel.assetModel.decimals To:self.transModel.toAddress Value:self.transModel.amount];
                result =  [web3.eth sendSignedTransaction:erc20Tx];
                NSLog(@"广播token转账交易 : %@",result);
                if ([result isHaveValue]) {
                    //本次交易完成
                    [self showSuccessView];
                }
            } else {
                //跨链合约交易 1 heter->nerve 2 或者heter->heter/nuls的第一步
                //判断额度是否小于 小于的话授权额度
                NSString *crossTxWithERC20 = [NerveTools crossOutWithERC20:web3 PriKey:self.privateKey MultyContract:multyAddress ERC20Contract:self.transModel.assetModel.contractAddress ERC20Decimals:self.transModel.assetModel.decimals To:self.needCompose?NERVE_ADDRESS:self.transModel.toAddress Value:self.transModel.amount];
                NSLog(@"异构链->nerve token转账交易hash : %@",crossTxWithERC20);
                if (self.needCompose) {
                    //第一次交易完成 开始递归走第二次交易
                     NSLog(@"2次交易 nerve转出%@:",self.transModel.toChain);
                    [self beginTransCreateFromInfoWithChain:NERVE crossTx:crossTxWithERC20];
                }else{
                    result =  [web3.eth sendSignedTransaction:crossTxWithERC20];
                    NSLog(@"广播结果 : %@", result);
                    if ([result isHaveValue]) {
                        //本次交易完成
                        [self showSuccessView];
                    }
                }
            }
        } else { // 异构链非合约交易
            if ([fromChain isEqualToString:self.transModel.toChain]) {
                //本链非合约交易
                NSString *ethTx = [NerveTools sendEth:web3 PriKey:self.privateKey To:self.transModel.toAddress Value:self.transModel.amount];
                result =  [web3.eth sendSignedTransaction:ethTx];
                NSLog(@"广播异构链-本链交易 : %@", result);
                if ([result isHaveValue]) {
                    //本次交易完成
                    [self showSuccessView];
                }
            } else {
                //跨链非合约交易 或者heter->heter/nuls的第一步
                NSString *crossTxWithEth = [NerveTools crossOutWithETH:web3 PriKey:self.privateKey MultyContract:multyAddress To:self.needCompose? NERVE_ADDRESS:self.transModel.toAddress Value:self.transModel.amount];
                NSLog(@"eth跨链转入nerve交易hash : %@", crossTxWithEth);
                if (self.needCompose) {
                    //第一次交易完成 开始递归走第二次交易
                    NSLog(@"2次交易 nerve转出%@:",self.transModel.toChain);
                    [self beginTransCreateFromInfoWithChain:NERVE crossTx:crossTxWithEth];
                }else{
                    result =  [web3.eth sendSignedTransaction:crossTxWithEth];
                    NSLog(@"广播结果 : %@", result);
                    if ([result isHaveValue]) {
                        //本次交易完成
                        [self showSuccessView];
                    }
                }
            }
        }
        //交易失败
        if ([result isHaveValue] == NO) {
            KHideHUD;
            [self.view showNormalToast:@"error"];
        }
    }
}


/** 多次请求获取nonce后统一回调 */
- (void)getFromAssetListWithMainAssetArr:(NSArray *)mainAssetArr fromAssetBlock:(void (^)(NSArray *fromAssetArr))fromAssetBlock
{
    NSMutableArray *fromAssetArr = [NSMutableArray new];
    
    dispatch_group_t downGroup = dispatch_group_create();
    for (int i = 0; i < mainAssetArr.count; i ++) {
        [fromAssetArr addObject:@(i)];
        ConfigMainAssetModel *assetModel = mainAssetArr[i];
        dispatch_group_enter(downGroup);
        [self getAssetNonceWithAssetModel:assetModel nonceBlock:^(AssetListResModel *extraFromModel) {
//            [fromAssetArr addObject:extraFromModel];
            fromAssetArr[i] = extraFromModel;
            dispatch_group_leave(downGroup);
        }];
    }
    
    dispatch_group_notify(downGroup, dispatch_get_main_queue(), ^{
        if (fromAssetBlock) {
            DLog(@"返回fromAsset:%@",[fromAssetArr mj_keyValues]);
            fromAssetBlock(fromAssetArr);
        }
    });
}

/** 通用请求获取nonce */
- (void)getAssetNonceWithAssetModel:(ConfigMainAssetModel *)assetModel nonceBlock:(void (^)(AssetListResModel *extraFromModel))nonceBlock
{
    AssetInfoModel *assetInfoModel = [AssetInfoModel new];
    assetInfoModel.address = assetModel.address ? assetModel.address: self.transModel.fromAddress;
    assetInfoModel.chain = self.transModel.fromChain;
    assetInfoModel.chainId = assetModel.chainId;
    if (assetModel.contractAddress) {
        assetInfoModel.contractAddress = assetModel.contractAddress;
    }
    if ([ChainUtil isNuls:self.transModel.fromChain] && [assetModel.contractAddress isHaveValue]) { // NULS合约资产转账 合约资产手续费是链主体产
        assetInfoModel.assetId = 1;
    } else {
        assetInfoModel.assetId = assetModel.assetId;
    }
    if (self.needCompose) { // 处理当组合交易时候 nerve->x第二段交易时候address需改为nerve地址
        if ([ChainUtil isHeterChain:self.transModel.fromChain]) {
            assetInfoModel.address = self.middleAssetModel.address;
            assetInfoModel.chain = self.middleAssetModel.chain;
        }else if ([ChainUtil isNuls:self.transModel.fromChain] && self.nulsToEthSync){ // NULS->NERVE->HETER
            assetInfoModel.address = self.walletModel.addressDict[NERVE];
            assetInfoModel.chain = NERVE;
        }
    }
    
    
    assetInfoModel.refresh = true;
    DLog(@"获取nonce入参:%@",[assetInfoModel mj_keyValues]);
    assetInfoModel.resClassStr = NSStringFromClass([AssetListResModel class]);
    [NetUtil requestWithType:RequestTypePost path:API_WALLET_ADRESS_ASEET dataModel:assetInfoModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        if (success) {
            DLog(@"获取nonce返回:%@",[dataObj mj_keyValues]);
            AssetListResModel *model = dataObj;
            AssetListResModel *extraFromModel = [[AssetListResModel alloc] init];
            extraFromModel.nonce = model.nonce;
            extraFromModel.assetId = assetModel.assetId;
            extraFromModel.chainId = assetModel.chainId;
            extraFromModel.amount = assetModel.amount;
            extraFromModel.decimals = model.decimals;
            if (nonceBlock) {
                nonceBlock(extraFromModel);
            }
        }else {
            KHideHUD;
            DLog(@"获取nonce报错%@",message);
            [KAppDelegate.window showNormalToast:message];
        }
    }];
}



/**
 生成交易类型
 1 comfirmNulsAndNerveSelfChainTransfer 本链交易
 2 comfirmCrossChainTransfer 跨链交易
 3 comfirmContractTx 合约交易
 */
- (void)genTransferTypeWithCrossTx:(NSString *)crossTx fromChain:(NSString *)fromChain
{
    if ([ChainUtil isNuls:fromChain] && [self.transModel.assetModel.contractAddress isHaveValue]) { // 1-1 NULS合约交易
        [self comfirmNulsContractWithCrossTx:crossTx];
    } else { // 1-2转账交易
        if ([fromChain isEqualToString:self.transModel.toChain]) {
            [self comfirmNulsAndNerveSelfChainTransfer]; // 1-2-1链内转账交易
        } else {
            [self comfirmCrossChainTransferWithCrossTx:crossTx fromChain:fromChain]; // 1-2-2 跨链转账
        }
    }
}


// 1  NULS和nerve 链内交易 非合约
- (void)comfirmNulsAndNerveSelfChainTransfer
{
    // type 交易类型 asset资产类型 assetId资产类型id
    NSInteger type = 2; // 2转账 10 跨链
    TransactionModel *transactionModel = [[TransactionModel alloc] init];
    NSData *coinData = [TransferUtil getCoinDataWithTransferInfo:self.transModel locked:0 lockTime:0];
    transactionModel.coinData = coinData;
    transactionModel.type = [NSNumber numberWithInteger:type];
    transactionModel.time = [NSNumber numberWithLong:[Common getNowTimeTimestamp]];
    transactionModel.remark = [self.transModel.remark dataUsingEncoding:NSUTF8StringEncoding];
    NSString *txSerializeHex = [TransferUtil getTxSerializeHexWithTransactionModel:transactionModel privateKey:self.privateKey];
    WS(weakSelf);
    ComposeTransferModel *createComposeTransferModel = [ComposeTransferModel new];
    createComposeTransferModel.address = self.transModel.fromAddress;
    createComposeTransferModel.chain = self.transModel.fromChain;
    createComposeTransferModel.chainId = self.transModel.assetModel.chainId;
    createComposeTransferModel.assetId = self.transModel.assetModel.assetId;
    createComposeTransferModel.txHex = txSerializeHex;
    [NetUtil requestWithType:RequestTypePost path:API_TX_TRANSFER dataModel:createComposeTransferModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        KHideHUD;
        SS(strongSelf);
        DLog(@"本链交易返回%@ %@",dataObj,message);
        if (success) {
            [strongSelf showSuccessView];
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [strongSelf.view showNormalToast:message];
        }
    }];
}

/**
 通用获取跨链交易txSerializeHex 包含nuls nerve非合约跨链转账
 type：0~正常一次交易，1~两次交易的第一次交易，2~两次交易的第二次交易
 */
- (NSString *)getCommonCrossChainTransferTxSerializeHexWithType:(NSInteger)type fromChain:(NSString *)fromChain
{
    TransactionModel *transactionModel = [[TransactionModel alloc] init]; // 生成hash model
    TransferTempModel *transModel = [TransferTempModel mj_objectWithKeyValues:self.transModel.mj_JSONString];
    NSInteger transType = 10; // 2转账 10 跨链 43 nerve->het异构链
    if (type == 1) { // 组合交易时nuls->nerve 资产在NULS和nerve上一致不用改
        transModel.toChain = NERVE;
        transModel.toAddress = self.walletModel.addressDict[NERVE];
    } else if (type == 2) { // 组合交易时候nerve->other 资产在nerve和异构链不一致
        if (self.needCompose && [ChainUtil isHeterChain:self.transModel.fromChain]) {
             transModel.assetModel = self.middleAssetModel;
        }
        transModel.fromChain = NERVE;
        transModel.fromAddress = self.walletModel.addressDict[NERVE];
    } else {
        //正常一次交易不用改变数据
    }
    
    // 如果是nerve->heter需要额外处理txData
    if ([ChainUtil isNerve:fromChain] && [ ChainUtil isHeterAddress:self.transModel.toAddress]) {
        transType = 43;
        ConfigInfoModel *config = [[GlobalVariable sharedInstance] getChainConfigWithChain:NERVE];
        transModel.destroyAddress = [config.configs objectForKey:@"destroyAddress"];
        transModel.feeAddress = [config.configs objectForKey:@"feeAddress"];
        // 这里需要根据资产详情heterogeneousList字段获取异构链在nerve上的chainId
        NSArray *heterogeneousList = [HeterogeneousListModel mj_objectArrayWithKeyValuesArray:self.transModel.assetModel.heterogeneousList];
        for (int i = 0; i < heterogeneousList.count; i++) {
            HeterogeneousListModel *heterogeneousListModel = heterogeneousList[i];
            if ([heterogeneousListModel.chainName isEqualToString:transModel.toChain]) {
                transactionModel.txData = [TransferUtil getTxDataWithAddress:transModel.toAddress chainId:[NSString stringWithFormat:@"%ld",heterogeneousListModel.heterogeneousChainId]];
                break;
            }
        }
    }
    
    NSData *coinData = [TransferUtil getCoinDataWithTransferInfo:transModel locked:0 lockTime:0];
    transactionModel.coinData = coinData;
    transactionModel.type = [NSNumber numberWithInteger:transType];
    transactionModel.time = [NSNumber numberWithLong:[Common getNowTimeTimestamp]];
    transactionModel.remark = [transModel.remark dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *txSerializeHex = [TransferUtil getTxSerializeHexWithTransactionModel:transactionModel privateKey:self.privateKey];
    return txSerializeHex;
}

// 2 NULS和Nerve跨链交易 非合约
- (void)comfirmCrossChainTransferWithCrossTx:(NSString *)crossTx fromChain:(NSString *)fromChain
{

    ComposeCrossChainTransferModel *createComposeTransferModel = [ComposeCrossChainTransferModel new];
    NSString *txSerializeHex;
    
    //判断是否为二次交易
    if ([crossTx isHaveValue]) {
        //如果交易情况为ETH->NEVER->NULS 此处fromChain应该是传ETH还是NEVER
        //1、fromChain要传ETH 那赋值self.transModel.fromChain  2、fromChain要传NEVER则赋值fromChain
        createComposeTransferModel.fromChain = self.transModel.fromChain;
        createComposeTransferModel.fromAddress = self.transModel.fromAddress;
        createComposeTransferModel.toAddress = self.transModel.toAddress;
        createComposeTransferModel.toChain = self.transModel.toChain;
        createComposeTransferModel.chainId = self.transModel.assetModel.chainId;
        createComposeTransferModel.assetId = self.transModel.assetModel.assetId;
        createComposeTransferModel.contractAddress = self.transModel.assetModel.contractAddress;
        
        //获取txSerializeHex
        txSerializeHex = [self getCommonCrossChainTransferTxSerializeHexWithType:2 fromChain:NERVE];
        
        createComposeTransferModel.txHex = crossTx;
        createComposeTransferModel.crossTxHex = txSerializeHex;
    } else {
        createComposeTransferModel.fromChain = self.transModel.fromChain;
        createComposeTransferModel.fromAddress = self.transModel.fromAddress;
        createComposeTransferModel.toAddress = self.transModel.toAddress;
        createComposeTransferModel.toChain = self.transModel.toChain;
        createComposeTransferModel.chainId = self.transModel.assetModel.chainId;
        createComposeTransferModel.assetId = self.transModel.assetModel.assetId;
        createComposeTransferModel.contractAddress = self.transModel.assetModel.contractAddress;
        
        //获取txSerializeHex
        txSerializeHex = [self getCommonCrossChainTransferTxSerializeHexWithType:0 fromChain:self.transModel.fromChain];
        createComposeTransferModel.txHex = txSerializeHex;
    }
    
    [NetUtil requestWithType:RequestTypePost path:API_TX_CROSS_TRANSFER dataModel:createComposeTransferModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        DLog(@"跨链交易返回%@ %@",dataObj,message);
        KHideHUD;
        if (success) {
            [self showSuccessView];
        }else {
            [self.view showNormalToast:message];
        }
    }];
}

// 组装合约交易 区分是否是合约资产看资产的contractAddress是否存在
// 合约交易分为三种  1 NULS->NULS  2 NULS->NERVE 3 NULS->合约地址
// type 0是正常 1 是Nuls->异构链中nuls->nerve转合约资产
- (NSString *)getNulsContractTxSerializeHexWithType:(NSInteger)type{
    TransferTempModel *transModel = [TransferTempModel mj_objectWithKeyValues:self.transModel.mj_JSONString];
    if (type) {
        transModel.toChain = NERVE;
        transModel.toAddress = self.walletModel.addressDict[NERVE];
    }
    
    AssetListResModel *feeModel = self.transModel.fromAssetList[0];
    // 跨链和不跨链的区别在于value = 0 或者value = 0.1
    NSString *methodName = @"transfer";
    NSNumber *value = @(0);
    if ([transModel.toChain isEqualToString:@"NERVE"]) {
        methodName = @"transferCrossChain";
        value = @(0.1 *pow(10, 8));
    }
    
    double number =[self.transModel.amount doubleValue]*pow(10, self.transModel.assetModel.decimals);
    NSArray *args = @[transModel.toAddress,[NSString stringWithFormat:@"%.0f",number]];
    NSArray *argsType = @[@"Address",@"BigInteger"];
    
    TransactionModel  *transactionModel = [TransferUtil contractTxOffline:self.transModel.fromAddress
                                                                 feeModel:feeModel
                                                                    value:value
                                                          contractAddress:self.transModel.assetModel.contractAddress
                                                                 gasLimit:self.transModel.gasLimit
                                                               methodName:methodName
                                                               methodDesc:@""
                                                                     args:args
                                                                 argsType:argsType
                                                                   remark:self.transModel.remark];
    
    NSString *txSerializeHex = [TransferUtil getTxSerializeHexWithTransactionModel:transactionModel privateKey:self.privateKey];
    return txSerializeHex;
}

//3 NULS合约交易  包含跨链和不跨链
- (void)comfirmNulsContractWithCrossTx:(NSString *)crossTx{
    NSString *txSerializeHex = [self getNulsContractTxSerializeHexWithType:0];
    WS(weakSelf);
    ComposeTransferModel *createContractTransferModel = [ComposeTransferModel new];
    createContractTransferModel.address = self.transModel.fromAddress;
    createContractTransferModel.chain = self.transModel.fromChain;
    createContractTransferModel.chainId = self.transModel.assetModel.chainId;
    createContractTransferModel.assetId = self.transModel.assetModel.assetId;
    createContractTransferModel.txHex = txSerializeHex;
    createContractTransferModel.contractAddress = self.transModel.assetModel.contractAddress;
    [NetUtil requestWithType:RequestTypePost path:API_TX_TRANSFER dataModel:createContractTransferModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        KHideHUD;
        SS(strongSelf);
        DLog(@"合约交易返回%@ %@",dataObj,message);
        if (success) {
            [strongSelf showSuccessView];
        }else {
            [strongSelf.view showNormalToast:message];
        }
    }];
}



#pragma mark UpdateUI
- (void)showSuccessView
{
//    KHideHUD;
     [KAppDelegate.window showNormalToast:KLocalizedString(@"transaction_success")];
    [self  performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    
    return;
    WS(weakSelf);
    ImportWalletSuccessView *importView = [ImportWalletSuccessView instanceView];
    importView.style = SheetStyleTransfer;
    importView.result = 1;
    importView.resultBlock = ^(NSInteger result) {
        SS(strongSelf);
        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        //        AssetsDetalsViewController *detailsVC = [[AssetsDetalsViewController alloc] init];
        //        detailsVC.backRoot = true;
        ////        if(self.otherAssetModel){
        ////            detailsVC.otherAssetModel = self.otherAssetModel;
        ////        }
        //        [strongSelf.navigationController pushViewController:detailsVC animated:YES];
    };
    [importView showInController:self preferredStyle:TYAlertControllerStyleActionSheet];
}

- (void)delayMethod{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [Common drawLineOfDashByCAShapeLayer:self.lineView lineLength:4 lineSpacing:4 lineColor:KColorGray4 lineDirection:YES];
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
