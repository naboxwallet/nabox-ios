# NaboxWallet

### 网络请求
* 方法定义
```
/** 请求类型 后续有需求可再拓展 */
typedef enum : NSUInteger {
RequestTypeGet,
RequestTypePost,
} RequestType;

@interface NetUtil : NSObject

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
responseBlock:(ResponseDataBlock)responseBlock;

@end

```
* 使用示例

```
/** 获取最新的版本信息 */
- (void)getVersion
{
    VersionManageModel *versionModel = [[VersionManageModel alloc] init];
    versionModel.resClassStr = NSStringFromClass([VersionManageModel class]);
    versionModel.isAdd = YES;
    versionModel.language = @"EN";
    [NetUtil requestWithType:RequestTypeGet path:API_VERSION dataModel:versionModel responseBlock:^(id  _Nullable dataObj, BOOL success, NSString * _Nullable message) {
        if (success) {
            VersionManageModel *dataModel = dataObj;
            DLog(@"%@",dataModel.version);
        }
    }];
}
```
