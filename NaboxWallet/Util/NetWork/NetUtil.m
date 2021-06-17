//
//  NetUtil.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "NetUtil.h"
#import "BasePublicRequestModel.h"
@implementation NetUtil

/**
 *  数据请求
 *
 *  @param type          请求类型
 *  @param path          请求方法地址
 *  @param dataModel     请求参数
 *  @param responseBlock 数据的回调
 *
 */
+ (void)requestWithType:(RequestType)type
                   path:(NSString *)path
              dataModel:(BaseModel *)dataModel
          responseBlock:(ResponseDataBlock)responseBlock
{
    NSMutableDictionary *parameters = [dataModel mj_keyValuesWithIgnoredKeys:@[@"code",@"msg",@"data",@"isAdd",@"responseType",@"resClassStr"]];
    
    if (dataModel.isAdd) {
        path = [self addUrlStrWith:path parameters:parameters];
    }
    //类型区分
    __weak __typeof(self) weakSelf = self;
    if (type == RequestTypeGet) {
        [[NetManager shareNetManager] getRequestWithPath:path parameters:parameters result:^(id  _Nullable dataObj, NSError * _Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf networkRequestResult:responseBlock dataObj:dataObj error:error dataModel:dataModel];
        } httpProgress:^(NSProgress * _Nullable progress) {
            
        }];
    }else if (type == RequestTypePost) {
        [[NetManager shareNetManager] postRequestWithPath:path parameters:parameters result:^(id  _Nullable dataObj, NSError * _Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf networkRequestResult:responseBlock dataObj:dataObj error:error dataModel:dataModel];
        } httpProgress:^(NSProgress * _Nullable progress) {
            
        } type:0];
    }
}

/**
 *  网络请求结果处理
 */
+ (void)networkRequestResult:(ResponseDataBlock)responseBlock
                     dataObj:(id)dataObj
                       error:(NSError *)error
                   dataModel:(BaseModel *)dataModel
{
//      DLog(@"返回====:%@",dataObj);
    if (!responseBlock) {
        return;
    }
    if (!dataObj) {
        responseBlock(nil,NO,KLocalizedString(@"network_exception"));
        return;
    }
    BaseModel *resModel = [BaseModel mj_objectWithKeyValues:dataObj];
    if (resModel.code.integerValue == 1000 || resModel.code.integerValue == 0) {
        if (dataModel.resClassStr.length) {
            Class modelClass = NSClassFromString(dataModel.resClassStr);
            if (dataModel.responseType == ResponseTypeNormal) {
                responseBlock(resModel.data,YES,@"成功");
            }else if (dataModel.responseType == ResponseTypeObject) {
                responseBlock([modelClass mj_objectWithKeyValues:resModel.data],YES,@"成功");
            }else if (dataModel.responseType == ResponseTypeObjectArr) {
                responseBlock([modelClass mj_objectArrayWithKeyValuesArray:resModel.data],YES,@"成功");
            }else {
                responseBlock([modelClass mj_objectWithKeyValues:resModel.data],YES,@"成功");
            }
        }else {
            responseBlock(resModel.data,YES,@"成功");
        }
    }else {
        responseBlock(nil,NO,resModel.msg);
    }
}

/**
 *  URL拼接处理
 */
+ (NSString *)addUrlStrWith:(NSString *)urlStr parameters:(NSDictionary *)parameters
{
    //拼接方式
    NSString *paramete = @"";
    
    for (NSString *key in [parameters allKeys])
    {
        if ([paramete length] == 0)
        {
            paramete = [NSString stringWithFormat:@"?%@=%@", key, [parameters objectForKey:key]];
        }
        else
        {
            paramete = [NSString stringWithFormat:@"%@&%@=%@", paramete,key, [parameters objectForKey:key]];
        }
    }
    
    urlStr = [NSString stringWithFormat:@"%@%@",urlStr,paramete];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return urlStr;
}


/**
 *  publicServer数据请求
 *  @param method          请求方法地址
 *  @param dataModel     请求参数
 *  @param responseBlock 数据的回调
 */
+ (void)requestWithMethod:(NSString *)method
                dataModel:(BasePublicModel *)dataModel
            responseBlock:(ResponseDataBlock)responseBlock{
    
    BasePublicRequestModel *model = [BasePublicRequestModel new];
    model.jsonrpc = @"2.0";
    model.method = method;
    model.id = @"1234";
    
    if ([method isEqualToString:@"commitData"] || [method isEqualToString:@"getData"] ) {
        model.params = dataModel.params;
    }else{
        NSMutableArray *params = [NSMutableArray new];
        [params addObject: @(CHAINID)];
        [params addObjectsFromArray:dataModel.params];
        model.params = params;
    }
    DLog(@"publicServer: 入参:%@",[model mj_keyValues]);
    __weak __typeof(self) weakSelf = self;
        [[NetManager shareNetManager] postRequestWithPath:[NSString stringWithFormat:@""] parameters:[model mj_keyValues] result:^(id  _Nullable dataObj, NSError * _Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            DLog(@"publicServer: 返回:%@",dataObj);
            [strongSelf publicResponse:responseBlock dataObj:dataObj error:error dataModel:dataModel];
        } httpProgress:^(NSProgress * _Nullable progress) {
    
        } type:1];
    
}

/**
 *  public网络请求结果处理
 */
+ (void)publicResponse:(ResponseDataBlock)responseBlock
                     dataObj:(id)dataObj
                       error:(NSError *)error
                   dataModel:(BasePublicModel *)dataModel
{
    if (!responseBlock) {
        return;
    }
    if (!dataObj) {
        responseBlock(nil,NO,KLocalizedString(@"network_exception"));
        return;
    }
    
    BasePublicModel *resModel = [BasePublicModel mj_objectWithKeyValues:dataObj];
    
    if (!resModel.error) {
        if (dataModel.resClassStr.length) {
            Class modelClass = NSClassFromString(dataModel.resClassStr);
            if (dataModel.responseType == ResponseTypeNormal) {
                responseBlock(resModel.result,YES,@"成功");
            }else if (dataModel.responseType == ResponseTypeObject) {
                responseBlock([modelClass mj_objectWithKeyValues:resModel.result],YES,@"成功");
            }else if (dataModel.responseType == ResponseTypeObjectArr) {
                responseBlock([modelClass mj_objectArrayWithKeyValuesArray:resModel.result],YES,@"成功");
            }else {
                responseBlock([modelClass mj_objectWithKeyValues:resModel.result],YES,@"成功");
            }
        }else {
            responseBlock(resModel.result,YES,@"成功");
        }
    }else {
//        DLog(@"error:%@",[resModel mj_keyValues]);
        responseBlock(nil,NO,[resModel.error objectForKey:@"message"]);
    }
}


@end
