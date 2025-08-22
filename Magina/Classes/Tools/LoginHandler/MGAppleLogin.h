//
//  MGAppleLogin.h
//  Magina
//
//  Created by mac on 2025/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MGAppleLoginCompleteHandler)(BOOL successed,NSString * _Nullable user, NSString *_Nullable familyName, NSString *_Nullable givenName, NSString *_Nullable email,NSString *_Nullable password, NSData *_Nullable identityToken, NSData *_Nullable authorizationCode, NSError *_Nullable error, NSString * msg);

typedef void(^MGAppleLoginObserverHandler)(void);

@interface MGAppleLogin : NSObject

+ (instancetype)shareInstance;

+ (UIView *)mg_creatAppleIDAuthorizedButtonWithTarget:(id)target selector:(SEL)selector ;

+ (void)mg_checkAuthorizationStateWithUser:(NSString *) user
                         completeHandler:(void(^)(BOOL authorized, NSString *msg)) completeHandler ;

- (void)mg_loginWithExistingAccount:(MGAppleLoginCompleteHandler)completeHandler ;

- (void)mg_loginWithCompleteHandler:(MGAppleLoginCompleteHandler)completeHandler ;

- (void)mg_startAppleIDObserverWithCompleteHandler:(MGAppleLoginObserverHandler) handler ;

@end

NS_ASSUME_NONNULL_END
