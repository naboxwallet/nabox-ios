//
//  CommonWebViewController.m
//  NaboxWallet
//
//  Created by Admin on yyyy/m/d.
//  Copyright © 2019 NaboxWallet. All rights reserved.
//

#import "CommonWebViewController.h"
#import <WebKit/WebKit.h>

@interface CommonWebViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self beginLoadUrl];
}

- (void)beginLoadUrl
{
    NSString *codeStr = [NSString string];
    NSString *languageStr = [NSString string];
    if (self.docCode && self.language) {
        codeStr = self.docCode;
        languageStr = self.language;
    }else{
        if (self.docType == DocumentTypeMnemonic) {
            codeStr = @"2-7";
        }else if (self.docType == DocumentTypePrivateKey) {
            codeStr = @"2-8";
        }else if (self.docType == DocumentTypeKeyStore) {
            codeStr = @"2-9";
        }else if (self.docType == DocumentTypePrivacyPolicy) {
            codeStr = @"1";
        }else if (self.docType == DocumentTypeHelpCenter) {
            codeStr = @"2";
        }else if (self.docType == DocumentTypeVersionLogs) {
            codeStr = @"3";
        }else if (self.docType == DocumentTypeMessage) {
            codeStr = @"";
        }else {
            codeStr = @"";
        }
        languageStr = [LanguageUtil getUserLanguageStr];
    }
    
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@?code=%@&language=%@",WEB_BASE,codeStr,languageStr];
    if (self.extendUrl.length >0) {
        [urlStr appendString:self.extendUrl];
    }
    
    // 添加属性监听
    NSString *newStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:KURL(newStr)]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:[change[NSKeyValueChangeNewKey] floatValue] animated:YES];
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressView removeFromSuperview];
            });
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"加载完成");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self.progressView removeFromSuperview];
    NSLog(@"加载失败");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"加载失败");
}

//禁止缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return nil;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 2)];
        _progressView.progressTintColor = KColorBlue;
        _progressView.trackTintColor = KColorClear;
        [self.view addSubview:_progressView];
        // 设定宽高 宽不改
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
        _progressView.transform = transform;
    }
    return _progressView;
}

- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.backgroundColor = KColorWhite;
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _webView;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
