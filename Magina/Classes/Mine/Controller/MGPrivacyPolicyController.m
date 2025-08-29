//
//  MGPrivacyPolicyController.m
//  Magina
//
//  Created by mac on 2025/8/29.
//

#import "MGPrivacyPolicyController.h"
#import <WebKit/WebKit.h>

@interface MGPrivacyPolicyController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *contentWebView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation MGPrivacyPolicyController

#pragma mark -lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUIComponents];
    
    NSString *urlString = @"https://magina.art/privacy-policy/";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [self.contentWebView loadRequest:request];
    self.contentWebView.hidden = YES;
    [self showLoading];
}

#pragma mark - setupUIComponents
- (void)setupUIComponents {
    self.customNavBar.title = NSLocalizedString(@"Privacy policyt", nil);
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.contentWebView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.indicator.frame = self.view.bounds;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideLoading];
    self.contentWebView.hidden = NO;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.view makeToast:NSLocalizedString(@"LP_networkErrorDescription", nil)];
}

#pragma mark - assistMethod
- (void)showLoading {
    if (self.indicator.superview == nil || self.indicator.superview != self.view) {
        [self.view addSubview:self.indicator];
        [self.view bringSubviewToFront:self.indicator];
        [self.indicator startAnimating];
    }
}

- (void)hideLoading {
    if (self.indicator.superview) {
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
    }
}

#pragma mark - getter
- (WKWebView *)contentWebView {
    if (!_contentWebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preference = [[WKPreferences alloc] init];
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        _contentWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.customNavBar.lv_bottom, self.view.lv_width, UI_SCREEN_H - self.customNavBar.lv_bottom) configuration:config];
        _contentWebView.backgroundColor = [UIColor blackColor];
        _contentWebView.UIDelegate = self;
        _contentWebView.navigationDelegate = self;
        _contentWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _contentWebView;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] init];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        _indicator.color = [UIColor lightGrayColor];
    }
    return _indicator;
}

@end
