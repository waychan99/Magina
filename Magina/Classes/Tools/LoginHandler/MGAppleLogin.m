//
//  MGAppleLogin.m
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import "MGAppleLogin.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface MGAppleLogin ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
//////////////////////   单例持有block，注意内存泄漏
@property (nonatomic, copy) MGAppleLoginCompleteHandler completeHander;
@property (nonatomic, copy) MGAppleLoginObserverHandler observerHander;
////////////// /////// /////// /////// ////////
@end

@implementation MGAppleLogin

static MGAppleLogin *_instance;

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

+ (UIView *)mg_creatAppleIDAuthorizedButtonWithTarget:(id)target selector:(SEL)selector {
    ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton buttonWithType:(ASAuthorizationAppleIDButtonTypeSignIn) style:(ASAuthorizationAppleIDButtonStyleBlack)];
    [button addTarget:target action:selector forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}

+ (void)mg_checkAuthorizationStateWithUser:(NSString *)user completeHandler:(void (^)(BOOL, NSString * _Nonnull))completeHandler {
    if (user == nil || user.length <= 0) {
        if (completeHandler) {
            completeHandler(NO, @"用户标识符错误");
        }
        return;
    }
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    [provider getCredentialStateForUserID:user completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
        NSString *msg = @"未知";
        BOOL authorized = NO;
        switch (credentialState) {
            case ASAuthorizationAppleIDProviderCredentialRevoked:
                msg = @"授权被撤销";
                authorized = NO;
                break;
            case ASAuthorizationAppleIDProviderCredentialAuthorized:
                msg = @"已授权";
                authorized = YES;
                break;
            case ASAuthorizationAppleIDProviderCredentialNotFound:
                msg = @"未查到授权信息";
                authorized = NO;
                break;
            case ASAuthorizationAppleIDProviderCredentialTransferred:
                msg = @"授权信息变动";
                authorized = NO;
                break;
                
            default:
                authorized = NO;
                break;
        }
        if (completeHandler) {
            completeHandler(authorized, msg);
        }
    }];
}

- (void)mg_startAppleIDObserverWithCompleteHandler:(MGAppleLoginObserverHandler)handler {
    self.observerHander = handler;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mg_signWithAppleIDStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
}

- (void)mg_signWithAppleIDStateChanged:(NSNotification *)noti {
    if (noti.name == ASAuthorizationAppleIDProviderCredentialRevokedNotification) {
        if (self.observerHander) {
            self.observerHander();
        }
    }
}

- (void)mg_loginWithExistingAccount:(MGAppleLoginCompleteHandler)completeHandler {
    self.completeHander = completeHandler;
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest *req = [provider createRequest];
    ASAuthorizationPasswordProvider *pasProvider = [[ASAuthorizationPasswordProvider alloc]init];
    ASAuthorizationPasswordRequest *pasReq = [pasProvider createRequest];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:2];
    if (req) {
        [arr addObject:req];
    }
    
    if (pasReq) {
        [arr addObject:pasReq];
    }
    ASAuthorizationController *controller = [[ASAuthorizationController alloc]initWithAuthorizationRequests:arr.copy];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}

- (void)mg_loginWithCompleteHandler:(MGAppleLoginCompleteHandler)completeHandler {
    self.completeHander = completeHandler;
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *req = [provider createRequest];
    req.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[req]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    NSString *msg = @"未知";
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            msg = @"用户取消";
            break;
        case ASAuthorizationErrorFailed:
            msg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            msg = @"授权请求无响应";
            break;
        case ASAuthorizationErrorNotHandled:
            msg = @"授权请求未处理";
            break;
        case ASAuthorizationErrorUnknown:
            msg = @"授权失败，原因未知";
            break;
            
        default:
            break;
    }
    
    if (self.completeHander) {
        self.completeHander(NO, nil, nil, nil, nil, nil, nil, nil, error, msg);
    }
}

// 授权成功的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        NSString *user = credential.user;
        NSString *familyName = credential.fullName.familyName;
        NSString *givenName = credential.fullName.givenName;
        NSString *email = credential.email;
        
        NSData *identityToken = credential.identityToken;
        NSData *code = credential.authorizationCode;
        
        if (self.completeHander) {
            self.completeHander(YES, user, familyName, givenName, email, nil, identityToken, code, nil, @"授权成功");
        }
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 使用现有的密码凭证登录
        ASPasswordCredential *credential = (ASPasswordCredential *)authorization.credential;
        
        // 用户唯一标识符
        NSString *user = credential.user;
        NSString *password = credential.password;
        
        if (self.completeHander) {
            self.completeHander(YES, user, nil, nil, nil, password, nil, nil, nil, @"授权成功");
        }
    }
}

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return [UIApplication sharedApplication].windows.firstObject;
}


@end
