//
//  SAAppleIDSignInProvider.h
//  SuperApp
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import <AuthenticationServices/AuthenticationServices.h>

typedef NS_ENUM(NSUInteger, ASAuthorizationCredentialType) { ASAuthorizationCredentialTypeUnknown, ASAuthorizationCredentialTypeAppleID, ASAuthorizationCredentialTypePassword };

NS_ASSUME_NONNULL_BEGIN

@class SAAppleIDSignInProvider;

@protocol SAAppleIDSignInProvider <NSObject>

@optional

/// 展示窗口
- (UIWindow *)presentationAnchor;

/// 成功
- (void)appleIDSignInProvider:(SAAppleIDSignInProvider *)provider didCompleteWithCredential:(id<ASAuthorizationCredential>)credential type:(ASAuthorizationCredentialType)type API_AVAILABLE(ios(13.0));

/// 失败
- (void)appleIDSignInProvider:(SAAppleIDSignInProvider *)provider didCompleteWithError:(NSError *)error errorMsg:(NSString *)errorMsg API_AVAILABLE(ios(13.0));

/// 授权失效
- (void)appleIDSignInProvider:(SAAppleIDSignInProvider *)provider didReceivedCredentialRevokedNotification:(NSNotification *)notification;
@end


@interface SAAppleIDSignInProvider : SAModel
/// 是否可用
- (BOOL)isAvailable;

/// 代理
@property (nonatomic, weak) id<SAAppleIDSignInProvider> delegate;

/// 授权数据，默认 @[ASAuthorizationScopeEmail,ASAuthorizationScopeFullName]
@property (nonatomic, copy, nullable) NSArray<ASAuthorizationScope> *requestedScopes API_AVAILABLE(ios(13.0));

/// 授权控制器
@property (nonatomic, strong, readonly) ASAuthorizationController *authController API_AVAILABLE(ios(13.0));

- (void)startWithPresentationAnchor:(ASPresentationAnchor _Nullable)presentationAnchor API_AVAILABLE(ios(13.0));
- (void)start;

- (void)getCredentialStateForUserID:(NSString *)userID
                         completion:(void (^)(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError *_Nullable error))completion API_AVAILABLE(ios(13.0));
@end

NS_ASSUME_NONNULL_END
