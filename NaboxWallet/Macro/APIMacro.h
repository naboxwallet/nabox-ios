//
//  APIMacro.h
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#ifndef APIMacro_h
#define APIMacro_h

/*******************************************服务器地址********************************************/
#define ADDRESSTYPE      1
#define LENGTHPREFIX     @[@"",@"a",@"b",@"c",@"d",@"e"]
#define COINTYPE         @"NULS"
#define COINTYPECODE     @"8964"
#define COINTYPENAME     @"纳世"
#define NULS             @"NULS"
#define NERVE            @"NERVE"
#define NVT              @"NVT"

#define APIMACRO_ADDRESS 0

// 测试环境
#ifdef DEBUG

//环境1: 本地测试阶段
#if APIMACRO_ADDRESS == 0

#define CHAINID          2
#define ASSETID          1
#define CHAINID_NVT   5
#define PREFIX           @"tNULS"
#define NVT_PREFIX       @"TNVT"
#define WEB_NULSCAN      @"http://beta.nulscan.io/transaction/info"  //webview地址
#define HTTP_BASE         @"http://nabox_api.zhoulijun.top/nabox-api/"
#define HTTP_PUBLIC         @"https://beta.wallet.nuls.io/api/"

#define ETH_PUBLIC_URL         @"https://ropsten.infura.io/v3/7e086d9f3bdc48e4996a3997b33b032f"
#define ETH_PUBLIC_CHAINID     @"3"
#define ETH_MULTY_ADDRESS     @"0x7d759a3330cec9b766aa4c889715535eed3c0484"
#define BSC_PUBLIC_URL         @"https://data-seed-prebsc-2-s1.binance.org:8545/"
#define BSC_PUBLIC_CHAINID     @"97"
#define BSC_MULTY_ADDRESS     @"0xf7915d4de86b856F3e51b894134816680bf09EEE"
#define HECO_PUBLIC_URL         @"https://http-testnet.hecochain.com"
#define HECO_PUBLIC_CHAINID     @"256"
#define HECO_MULTY_ADDRESS     @"0xb339211438Dcbf3D00d7999ad009637472FC72b3"
#define OKT_PUBLIC_URL         @"https://exchaintestrpc.okex.org"
#define OKT_PUBLIC_CHAINID     @"65"
#define OKT_MULTY_ADDRESS     @"0xab34B1F41dA5a32fdE53850EfB3e54423e93483e"
//环境2  debug正式环境 可用于验收阶段
#elif APIMACRO_ADDRESS == 1

#define CHAINID   1
#define ASSETID   1
#define CHAINID_NVT   9
#define PREFIX           @"NULS"
#define NVT_PREFIX       @"NERVE"
#define WEB_NULSCAN      @"https://nulscan.io/transaction/info"  //webview地址

#define HTTP_BASE        @"http://api.v2.nabox.io/nabox-api/"
#define HTTP_PUBLIC         @"https://wallet.nuls.io/api/"

#define ETH_PUBLIC_URL         @"https://mainnet.infura.io/v3/6214eb6580bf49d485ed94417272640f"
#define ETH_PUBLIC_CHAINID     @"1"
#define ETH_MULTY_ADDRESS     @"0x6758d4C4734Ac7811358395A8E0c3832BA6Ac624"
#define BSC_PUBLIC_URL         @"https://bsc-dataseed.binance.org/"
#define BSC_PUBLIC_CHAINID     @"56"
#define BSC_MULTY_ADDRESS     @"0x3758AA66caD9F2606F1F501c9CB31b94b713A6d5"
#define HECO_PUBLIC_URL         @"https://http-mainnet.hecochain.com"
#define HECO_PUBLIC_CHAINID     @"128"
#define HECO_MULTY_ADDRESS     @"0x23023c99dceDE393d6D18ca7FB08541B3364fA90"
#define OKT_PUBLIC_URL         @"https://exchainrpc.okex.org"
#define OKT_PUBLIC_CHAINID     @"66"
#define OKT_MULTY_ADDRESS     @"0x3758aa66cad9f2606f1f501c9cb31b94b713a6d5"
#endif

// 生产环境 打包后的执行
#else

#define CHAINID   1
#define ASSETID   1

#define CHAINID_NVT   9
#define PREFIX           @"NULS"
#define NVT_PREFIX       @"NERVE"
#define WEB_NULSCAN      @"https://nulscan.io/transaction/info"  //webview地址

#define HTTP_BASE        @"http://api.v2.nabox.io/nabox-api/"
#define HTTP_PUBLIC         @"https://wallet.nuls.io/api/"

#define ETH_PUBLIC_URL         @"https://mainnet.infura.io/v3/6214eb6580bf49d485ed94417272640f"
#define ETH_PUBLIC_CHAINID     @"1"
#define ETH_MULTY_ADDRESS     @"0x6758d4C4734Ac7811358395A8E0c3832BA6Ac624"
#define BSC_PUBLIC_URL         @"https://bsc-dataseed.binance.org/"
#define BSC_PUBLIC_CHAINID     @"56"
#define BSC_MULTY_ADDRESS     @"0x3758AA66caD9F2606F1F501c9CB31b94b713A6d5"
#define HECO_PUBLIC_URL         @"https://http-mainnet.hecochain.com"
#define HECO_PUBLIC_CHAINID     @"128"
#define HECO_MULTY_ADDRESS     @"0x23023c99dceDE393d6D18ca7FB08541B3364fA90"
#define OKT_PUBLIC_URL         @"https://exchainrpc.okex.org"
#define OKT_PUBLIC_CHAINID     @"66"
#define OKT_MULTY_ADDRESS     @"0x3758aa66cad9f2606f1f501c9cb31b94b713a6d5"
#endif

/********************************************文档地址**********************************************/
//code="隐私条款：1  帮助中心：2  版本日志：3 什么是keystore:2-9  什么是助记词:2-8  什么是私钥:2-7"
//&language=CHS

#define WEB_BASE         @"http://admin.nabox.io/nabox/document/doc.html"  //webview文档地址


#define API_VERSION              @"version/best" //获取最新的版本信息
#define API_WALLETSYNC           @"wallet/sync"  //新增钱包信息
#define API_WALLETTOKENS         @"wallet/tokens"//获取钱包的合约资产
#define API_NULS_BALANCE         @"nuls/balance" //查询钱包余额
#define API_WALLET_UPDATE        @"wallet/update"//修改钱包
#define API_WALLET_TOKEN         @"wallet/tokens"//查询合约资产
#define API_TOKEN_BALANCE        @"nuls/token/balance"//查询钱包token余额
#define API_WALLET_DELETE        @"wallet/delete"//删除钱包
#define API_TRANS_QUERYLIST      @"trans/queryTxList"//资产详情列表数据
#define API_TRANS_TXINFO         @"trans/tx/info"//查询交易信息
#define API_TRANS_CREATETX       @"trans/broadcastTx"//转账交易
#define API_NULS_ACCOUNT         @"nuls/account"//获取账户信息
#define API_NULS_SYNCTERMINAL    @"wallet/batch/sync/terminal"//批量同步钱包信息
#define API_SYNC_WALLET_DEVICE   @"wallet/batch/sync/terminal"//批量同步钱包和地址
#define API_ACTIVITES_PROFIT     @"agent/address/yesterday" // 共识昨日收益
#define API_CONSENSUS_STATISTICS @"agent/address/statistics" // 共识统计
#define API_MY_CONSENSUS_LIST    @"agent/address/in" // 我参与(所有钱包)的共识列表
#define API_CONSENSUS_DETAIL     @"agent/address/detail" // 共识详情
#define API_ALL_CONSENSUS_LIST   @"agent/valid" // 所有共识列表
#define API_PROFIT_LIST          @"agent/address/reward" // 收益列表
#define API_AGENT_LIST           @"agent/address/all" // 筛选节点列表
#define  API_GAME_ACTIVE_LIST    @"api/icon/DAPP" // 游戏共识列表
#define API_GLOBAL_AGENT_INFO    @"nuls/coinInfo" // 获取全网节点信息
#define API_PARTNER_INFO         @"partner/info"  // 获取商户信息
#define API_TRANS_CREATEPAY      @"trans/createPay"  //钱包支付
#define API_CONTRACTCALL_GAS @"nuls/imputedContractCallGas" // 计算合约交易需要消耗的gas数量
#define API_MSG_COUNT_NOREAD @"message/total/noread/count" // 获取未读消息条数 用来显示首页消息红点
#define API_MSG_HOME @"message/home" // 获取首页公告
#define API_MSG_SYSTEM_LIST @"message/sys/list" // 获取系统消息列表
#define API_MSG_SYSTEM_NOREAD @"message/sys/noread/count" // 获取系统未读消息列表
#define API_MSG_AGENT_NOREAD @"message/agent/noread/count" // 获取委托消息未读数量
#define API_MSG_AGENT_LIST @"message/agent/list" // 获取委托消息列表
#define API_MSG_USER @"message/user/list" // 获取个人消息列表
#define API_MSG_READ_USER @"message/user/read" // 将一条个人消息设置为已读
#define API_MSG_READ_SYS @"message/sys/read" // 将一条系统消息设置为已读
#define API_MSG_READ_ALL @"message/read/all" // 将所有消息设置为已读


// public server
#define PUBLIC_API_ANNUL_REWARD @"getAnnulizedRewardStatistical" // 共识首页:年化收益率
#define PUBLIC_API_PROFIT @"getAccount" //共识首页:收益
#define PUBLIC_API_CONSENSUS_TOTAL @"getAccountDepositValue" //共识首页:获取共识委托量统计信息
#define PUBLIC_API_WALLET_INFO @"getAccountBalance" //获取钱包余额
#define PUBLIC_API_WALLETS_INFO @"getAccountsBalance" //获取多个钱包余额
#define PUBLIC_API_ACCOUNT_LEDGER @"getAccountLedgerList" //查询账户本链资产列表
#define PUBLIC_API_CROSS_ACCOUNT_LEDGER @"getAccountCrossLedgerList" //查询账户跨链资产列表
#define PUBLIC_API_TOKEN_TRADE_RECORD @"getTokenTransfers" //查询账户token的交易列表
#define PUBLIC_API_NULS_TRADE_RECORD @"getAccountTxs" //查询nuls账户的交易列表
#define PUBLIC_API_ACCOUNT_LIST @"getAccountTokens" //查询账户的token资产列表
#define PUBLIC_API_TRADE_INFO @"getTx" //查询交易详情
#define PUBLIC_API_BROADCAST_TX @"broadcastTx" // 广播交易
#define PUBLIC_API_SCAN_IMPORT @"commitData" // 扫码导入账户 扫码登录
#define PUBLIC_API_SCAN_SIGN @"getData" // 扫码签名

// 新版本接口

// 钱包
#define API_CHAIN_CONFIG @"api/chain/config" // 查询nabox当前支持的各条链的配置信息
#define API_USDT_EXCHANGE @"api/usd/exchange" // 查询USD对其他资产的汇率

// 资产
#define API_ASSET_QUERY @"asset/query" // 查询链上资产
#define API_ASSET_MAIN_PRICE @"asset/main/price" // 查询当前链主资产usd单价
#define API_ASSET_NERVE_CHAIN_INFO @"asset/nerve/chain/info" // 查询异构链资产在nerve链上对应资产的信息
#define API_ASSET_GAS_PRICE @"asset/gasprice" // 查询异构链gasprice
#define API_ASSET_NVT_CROSS_PRICE @"asset/nvt/cross/price" // 查询nerve跨链到异构链需要的NVT手续费

// 账户
#define API_WALLET_SYNC @"wallet/sync" // 同步账户 新导入私钥或更新账户信息时调用
#define API_WALLET_ADDRESS_ASSET_FOCUS @"wallet/address/asset/focus" // 关注资产
#define API_WALLET_ADRESS_ASEETS @"wallet/address/assets" // 查询地址资产列表
#define API_WALLET_ADRESS_ASEET @"wallet/address/asset" // 查询资产详情
#define API_WALLET_PRICE @"wallet/price" // 查询账户USD总价格
#define API_WALLET_PRICES @"wallet/prices" // 查询多个账户USD总价格
#define API_WALLET_CHAIN_PRICE @"wallet/chain/price" // 查询账户每条链USD总价格
#define API_ACCOUNT_REFRESH @"wallet/refresh" //刷新账户
// 智能合约
#define API_CONTRACT_VALIDATE_CALL @"contract/validate/call" // 智能合约调用验证
#define API_CONTRACT_IMPUTED_CALL_GAS @"contract/imputed/call/gas" // 估算调用合约交易的GAS
#define API_CONTRACT_METHOD_ARGS_TYPE @"contract/method/args/type" // 获取合约方法参数类型
// 交易
#define API_TX_TRANSFER @"tx/transfer" // 广播链内交易
#define API_TX_CROSS_TRANSFER @"tx/cross/transfer" // 跨链交易转账
#define API_TX_CROSS_AUTHOR @"tx/cross/author" // 跨链转账授权
#define API_TX_COIN_LIST @"tx/coin/list" // 交易明细列表
#define API_TX_COIN_INFO @"tx/coin/info" // 交易详情
//API_TX_TRANSFER

#endif /* APIMacro_h */
