//
//  SAAppleIDSignInProvider.m
//  SuperApp
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppleIDSignInProvider.h"

API_AVAILABLE(ios(13.0));


@interface SAAppleIDSignInProvider () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, weak) ASPresentationAnchor presentationAnchor;

/// 授权控制器
@property (nonatomic, strong) ASAuthorizationController *authController;
@end


@implementation SAAppleIDSignInProvider
- (instancetype)init {
    self = [super init];
    if (self) {
        if (@available(iOS 13.0, *)) {
            self.requestedScopes = @[ASAuthorizationScopeEmail, ASAuthorizationScopeFullName];

            // 监听授权失效
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appleIDProviderCredentialRevokedNotification:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification
                                                     object:nil];
        }
    }
    return self;
}

- (BOOL)isAvailable {
    if (@available(iOS 13.0, *)) {
        return YES;
    }
    return NO;
}

- (void)startWithPresentationAnchor:(ASPresentationAnchor)presentationAnchor {
    self.presentationAnchor = presentationAnchor;

    ASAuthorizationAppleIDProvider *appleIdProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
    request.requestedScopes = self.requestedScopes;
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    if (self.presentationAnchor) {
        controller.presentationContextProvider = self;
    }
    [controller performRequests];

    self.authController = controller;
}

- (void)start {
    if (@available(iOS 13.0, *)) {
        [self startWithPresentationAnchor:nil];
    }
}

- (void)getCredentialStateForUserID:(NSString *)userID
                         completion:(void (^)(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError *_Nullable error))completion API_AVAILABLE(ios(13.0)) {
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        [provider getCredentialStateForUserID:userID completion:completion];
    } else {
        !completion ?: completion(ASAuthorizationAppleIDProviderCredentialNotFound, [NSError errorWithDomain:@"api_error" code:-1 userInfo:@{@"info": @"api_unAvailable"}]);
    }
}

#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    ASAuthorizationCredentialType type = ASAuthorizationCredentialTypeUnknown;
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        type = ASAuthorizationCredentialTypeAppleID;
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        type = ASAuthorizationCredentialTypePassword;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(appleIDSignInProvider:didCompleteWithCredential:type:)]) {
        [self.delegate appleIDSignInProvider:self didCompleteWithCredential:authorization.credential type:type];
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;

        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;

        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;

        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;

        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;

        default:
            break;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(appleIDSignInProvider:didCompleteWithError:errorMsg:)]) {
        [self.delegate appleIDSignInProvider:self didCompleteWithError:error errorMsg:errorMsg];
    }
}

#pragma mark - Notification
- (void)appleIDProviderCredentialRevokedNotification:(NSNotification *)notification {
    if (self.delegate && [self.delegate respondsToSelector:@selector(appleIDSignInProvider:didReceivedCredentialRevokedNotification:)]) {
        [self.delegate appleIDSignInProvider:self didReceivedCredentialRevokedNotification:notification];
    }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (nonnull ASPresentationAnchor)presentationAnchorForAuthorizationController:(nonnull ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    return self.presentationAnchor;
}

@end
