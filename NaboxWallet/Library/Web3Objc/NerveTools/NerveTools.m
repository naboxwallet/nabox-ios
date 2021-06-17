//
//  NerveTools.m
//  Web3Objc
//
//  Created by pierreluo on 2021/3/19.
//  Copyright © 2021 coin. All rights reserved.
//

#import "NerveTools.h"
#import "PKWeb3Objc.h"

@implementation NerveTools

static NSString *tokenContractAbi = nil;
static NSString *multyContractAbi = nil;
static NSString *zeroAddress = nil;
static BigNumber *minApprove = nil;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tokenContractAbi = @"[{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"type\":\"function\"},{\"name\":\"transfer\",\"type\":\"function\",\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"type\":\"uint256\",\"name\":\"_tokens\"}],\"constant\":false,\"outputs\":[],\"payable\":false},{\"constant\":true,\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]";
        multyContractAbi = @"[{\"constant\":false,\"inputs\":[{\"name\":\"to\",\"type\":\"string\"},{\"name\":\"amount\",\"type\":\"uint256\"},{\"name\":\"ERC20\",\"type\":\"address\"}],\"name\":\"crossOut\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"}]";
        zeroAddress = @"0x0000000000000000000000000000000000000000";
        minApprove = [BigNumber bigNumberWithDecimalString:@"39600000000000000000000000000"];
    });
}

+ (NSString *)sendEth: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey To: (NSString *)_to Value: (NSString *)_value
{
    NSString *from = [web3.eth.accounts privateKeyToAccount:_priKey];
    CVETHTransaction *tx = [[CVETHTransaction alloc] init];
    tx.nonce = [web3.utils numberToHex:[web3.eth getTranactionCount:from]];
    tx.gasPrice = [web3.utils numberToHex:[web3.eth getGasPrice]];
    NSString *gasLimit = [NSString stringWithFormat:@"%.0f",21000 * [GlobalVariable sharedInstance].feeLevel];
    tx.gasLimit = [web3.utils numberToHex:gasLimit];
    tx.to = [_to removePrefix0x];
    tx.value = [web3.utils numberToHex:[web3.utils parseEther:_value]];
    NSDictionary *signTx = [web3.eth.accounts signTransaction:tx WithPrivateKey:_priKey];
    return [signTx valueForKey:@"rawTransaction"];
}

+ (NSString *)sendERC20: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey ERC20Contract: (NSString *)_contract ERC20Decimals: (NSUInteger)_decimals To: (NSString *)_to Value: (NSString *)_value
{
    PKWeb3EthContract *tokenContract = [web3.eth.contract initWithAddress:_contract AbiJsonStr:tokenContractAbi];
    
    NSString *from = [web3.eth.accounts privateKeyToAccount:_priKey];
    CVETHTransaction *tx = [[CVETHTransaction alloc] init];
    tx.nonce = [web3.utils numberToHex:[web3.eth getTranactionCount:from]];
    tx.gasPrice = [web3.utils numberToHex:[web3.eth getGasPrice]];
    NSString *gasLimit = [NSString stringWithFormat:@"%.0f",100000 * [GlobalVariable sharedInstance].feeLevel];
    tx.gasLimit = [web3.utils numberToHex:gasLimit];
    tx.to = [_contract removePrefix0x];
    tx.data = [tokenContract encodeABI:@"transfer(address,uint256)" WithArgument:@[_to, [web3.utils parseUnits:_value WithUnit:_decimals]]];
    NSDictionary *signTx = [web3.eth.accounts signTransaction:tx WithPrivateKey:_priKey];
    return [signTx valueForKey:@"rawTransaction"];
}

+ (NSString *)approveERC20: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey ERC20Contract: (NSString *)_contract ERC20Decimals: (NSUInteger)_decimals To: (NSString *)_to Value: (NSString *)_value
{
    PKWeb3EthContract *tokenContract = [web3.eth.contract initWithAddress:_contract AbiJsonStr:tokenContractAbi];
    
    NSString *from = [web3.eth.accounts privateKeyToAccount:_priKey];
    CVETHTransaction *tx = [[CVETHTransaction alloc] init];
    tx.nonce = [web3.utils numberToHex:[web3.eth getTranactionCount:from]];
    tx.gasPrice = [web3.utils numberToHex:[web3.eth getGasPrice]];
    tx.gasLimit = [web3.utils numberToHex:@"80000"];
    tx.to = [_contract removePrefix0x];
    tx.data = [tokenContract encodeABI:@"approve(address,uint256)" WithArgument:@[_to, [web3.utils parseUnits:_value WithUnit:_decimals]]];
    NSDictionary *signTx = [web3.eth.accounts signTransaction:tx WithPrivateKey:_priKey];
    return [signTx valueForKey:@"rawTransaction"];
}

+ (NSString *)getERC20Allowance: (PKWeb3Objc *) web3 Owner: (NSString *)_owner ERC20Contract: (NSString *)_contract Spender: (NSString *)_spender
{
    PKWeb3EthContract *tokenContract = [web3.eth.contract initWithAddress:_contract AbiJsonStr:tokenContractAbi];
    return [tokenContract call:@"allowance(address,address)" WithArgument:@[_owner,_spender]];
}

+ (BOOL)needERC20Allowance: (PKWeb3Objc *) web3 Owner: (NSString *)_owner ERC20Contract: (NSString *)_contract Spender: (NSString *)_spender{
    BigNumber *currentAllowance = [BigNumber bigNumberWithDecimalString:[NerveTools getERC20Allowance:web3 Owner:_owner ERC20Contract:_contract Spender:_spender]];
    if ([currentAllowance lessThan:minApprove]) {
        NSLog(@"授权额度不足，请先授权，当前剩余额度");
        //@TODO throw error
        return YES;
    }
    return NO;
}

+ (NSString *)getERC20Balance: (PKWeb3Objc *) web3 Owner: (NSString *)_owner ERC20Contract: (NSString *)_contract
{
    PKWeb3EthContract *tokenContract = [web3.eth.contract initWithAddress:_contract AbiJsonStr:tokenContractAbi];
    return [tokenContract call:@"balanceOf(address)" WithArgument:@[_owner]];
}

+ (NSString *)crossOutWithETH: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey MultyContract: (NSString *)_contract To: (NSString *)_to Value: (NSString *)_value
{
    PKWeb3EthContract *multyContract = [web3.eth.contract initWithAddress:_contract AbiJsonStr:multyContractAbi];
    
    NSString *from = [web3.eth.accounts privateKeyToAccount:_priKey];
    CVETHTransaction *tx = [[CVETHTransaction alloc] init];
    NSString *value = [web3.utils parseEther:_value];
    tx.value = [web3.utils numberToHex:value];
    tx.gasPrice = [web3.utils numberToHex:@"1"];
    NSString *gasLimit = [NSString stringWithFormat:@"%.0f",1000000 * [GlobalVariable sharedInstance].feeLevel];
    tx.gasLimit = [web3.utils numberToHex:gasLimit];
    tx.to = _contract;
    tx.data = [multyContract encodeABI:@"crossOut(string,uint256,address)" WithArgument:@[_to,value,zeroAddress]];
    NSString *result = [web3.eth validateCallFrom:from TX:tx];
    if (result == nil) {
        NSString *estimateGas = [web3.eth estimateGasFrom:from TX:tx];
        if(!estimateGas) {
            NSLog(@"估算gas异常");
            //@TODO throw error
            return @"";
        }
        tx.nonce = [web3.utils numberToHex:[web3.eth getTranactionCount:from]];
        tx.gasLimit = [web3.utils numberToHex:estimateGas];
        tx.gasPrice = [web3.utils numberToHex:[web3.eth getGasPrice]];
    } else {
        NSLog(@"合约验证错误 : %@", result);
        //@TODO throw error
        return @"";
    }
    NSDictionary *signTx = [web3.eth.accounts signTransaction:tx WithPrivateKey:_priKey];
    return [signTx valueForKey:@"rawTransaction"];
}

+ (NSString *)crossOutWithERC20: (PKWeb3Objc *) web3 PriKey: (NSString *)_priKey MultyContract: (NSString *)_multyContract ERC20Contract: (NSString *)_erc20Contract ERC20Decimals: (NSUInteger)_erc20Decimals To: (NSString *)_to Value: (NSString *)_value
{
    PKWeb3EthContract *multyContract = [web3.eth.contract initWithAddress:_multyContract AbiJsonStr:multyContractAbi];
    
    NSString *from = [web3.eth.accounts privateKeyToAccount:_priKey];
    CVETHTransaction *tx = [[CVETHTransaction alloc] init];
    NSString *tokenValue = [web3.utils parseUnits:_value WithUnit:_erc20Decimals];
    tx.gasPrice = [web3.utils numberToHex:@"1"];
    NSString *gasLimit = [NSString stringWithFormat:@"%.0f",1000000 * [GlobalVariable sharedInstance].feeLevel];
    tx.gasLimit = [web3.utils numberToHex:gasLimit];
    tx.to = _multyContract;
    tx.data = [multyContract encodeABI:@"crossOut(string,uint256,address)" WithArgument:@[_to,tokenValue,_erc20Contract]];
    
    BigNumber *currentAllowance = [BigNumber bigNumberWithDecimalString:[NerveTools getERC20Allowance:web3 Owner:from ERC20Contract:_erc20Contract Spender:_multyContract]];
    if ([currentAllowance lessThan:minApprove]) {
        NSLog(@"授权额度不足，请先授权，当前剩余额度: %@", [web3.utils formatUnits:currentAllowance.decimalString WithUnit:_erc20Decimals]);
        //@TODO throw error
        return @"";
    }
    NSString *result = [web3.eth validateCallFrom:from TX:tx];
    if (result == nil) {
        NSString *estimateGas = [web3.eth estimateGasFrom:from TX:tx];
        if(!estimateGas) {
            NSLog(@"估算gas异常");
            //@TODO throw error
            return @"";
        }
        tx.nonce = [web3.utils numberToHex:[web3.eth getTranactionCount:from]];
        tx.gasLimit = [web3.utils numberToHex:estimateGas];
        tx.gasPrice = [web3.utils numberToHex:[web3.eth getGasPrice]];
    } else {
        NSLog(@"合约验证错误 : %@", result);
        //@TODO throw error
        return @"";
    }
    NSDictionary *signTx = [web3.eth.accounts signTransaction:tx WithPrivateKey:_priKey];
    return [signTx valueForKey:@"rawTransaction"];
}

@end
