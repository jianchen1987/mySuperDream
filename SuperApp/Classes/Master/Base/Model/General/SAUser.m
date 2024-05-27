//
//  SAUser.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAUser.h"
#import "SACacheManager.h"
#import "SAGeneralUtil.h"
#import "SAGetUserInfoRspModel.h"
#import "SALoginRspModel.h"
#import <HDKitCore/HDCommonDefines.h>


@interface SAUser ()
/// 锁
@property (atomic, strong) NSLock *sessionLock;
@property (nonatomic, strong) dispatch_queue_t lockQueue;
@end


@implementation SAUser
static SAUser *_sharedUser = NULL;
+ (SAUser *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SACacheManager.shared setCustomNameSpace:self.lastLoginFullAccount];
        id cacheUser = [SACacheManager.shared objectForKey:kCacheKeyUser];
        _sharedUser = cacheUser;
        _sharedUser = _sharedUser ?: [SAUser new];
    });
    return _sharedUser;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    SAUser *user = [super allocWithZone:zone];
    [user commonInit];
    return user;
}

+ (BOOL)hasSignedIn {
    return HDIsStringNotEmpty(self.shared.loginName);
}

#pragma mark - private methods
- (void)commonInit {
    self.sessionLock = NSLock.new;
    self.lockQueue = dispatch_queue_create("com.wownow.session.lock", DISPATCH_QUEUE_SERIAL);
}

#pragma mark - public methods
- (void)save {
    if (self && HDIsStringNotEmpty(self.loginName)) {
        // 用户不为空的话先设置 user 目录
        [SACacheManager.shared setCurrentNamespaceWithUser:self];
        // 再存储用户
        [SACacheManager.shared setObject:self forKey:kCacheKeyUser];

        [SACacheManager.shared setObject:self.loginName forKey:kCacheKeyLastLoginedUserName type:SACacheTypeDocumentPublic];

        [SACacheManager.shared setObject:@(self.lastLoginType) forKey:kCacheKeyLastLoginedType type:SACacheTypeDocumentPublic];

        [SACacheManager.shared setObject:self.headURL forKey:kCacheKeyLastLoginedHeadURL type:SACacheTypeDocumentPublic];
        //验证码或密码登录
        if (self.lastLoginType == 0 || self.lastLoginType == 1) {
            [SACacheManager.shared setObject:self.loginName forKey:kCacheKeyLastLoginedShowName type:SACacheTypeDocumentPublic];
        } else {
            //第三方登录
            [SACacheManager.shared setObject:self.nickName forKey:kCacheKeyLastLoginedShowName type:SACacheTypeDocumentPublic];
        }

    } else {
        // 用户为空的话先删除用户
        [SACacheManager.shared removeObjectForKey:kCacheKeyUser];

        // 后设置 user 目录
        [SACacheManager.shared setCurrentNamespaceWithUser:self];
        [SACacheManager.shared setCustomNameSpace:@""];
    }
}

- (void)saveWithUserInfo:(SAGetUserInfoRspModel *_Nonnull)userInfoRsp {
    self.education = userInfoRsp.education;
    self.birthday = userInfoRsp.birthday;
    self.nickName = userInfoRsp.nickName;
    self.opLevel = userInfoRsp.opLevel;
    self.opLevelName = userInfoRsp.opLevelName;
    self.headURL = userInfoRsp.headURL;
    self.invitationCode = userInfoRsp.invitationCode;
    self.gender = userInfoRsp.gender;
    self.email = userInfoRsp.email;
    self.profession = userInfoRsp.profession;
    self.pointBalance = userInfoRsp.pointBalance;
    self.memberLogo = userInfoRsp.memberLogo;
    self.mobile = userInfoRsp.mobile;
    self.contactNumber = userInfoRsp.contactNumber;
    [self save];
}

- (void)lockSessionCompletion:(void (^)(void))completion {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(self.lockQueue ? self.lockQueue : dispatch_queue_create("com.wownow.session.lock", DISPATCH_QUEUE_SERIAL), ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.sessionLock lock];
        completion();
    });
}

- (void)unlockSession {
    [self.sessionLock unlock];
}

- (BOOL)needUpdateAccessToken {
    if (_accessTokenUpdateTime && [SAGeneralUtil getDiffValueUntilNowForDate:_accessTokenUpdateTime] < 50) {
        return NO;
    } else {
        return YES;
    }
}

+ (void)logout {
    _sharedUser = SAUser.new;
    [_sharedUser save];
    // 发出退出登录通知
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameUserLogout object:nil userInfo:nil];
}

+ (NSString *__nullable)lastLoginFullAccount {
    NSString *str = [SACacheManager.shared objectForKey:kCacheKeyLastLoginedUserName type:SACacheTypeDocumentPublic];
    return str;
}

+ (NSString *__nullable)lastLoginAccount {
    NSString *fullLastLoginName = self.lastLoginFullAccount;
    if (HDIsStringNotEmpty(fullLastLoginName) && fullLastLoginName.length > 4) {
        BOOL hasPrefix86 = [fullLastLoginName hasPrefix:@"86"];
        BOOL hasPrefix855 = [fullLastLoginName hasPrefix:@"855"];
        NSUInteger length = hasPrefix86 ? 2 : (hasPrefix855 ? 3 : 0);
        return [fullLastLoginName stringByReplacingCharactersInRange:NSMakeRange(0, length) withString:@""];
    } else {
        return nil;
    }
}

+ (NSInteger)lastLoginUserType {
    NSNumber *type = [SACacheManager.shared objectForKey:kCacheKeyLastLoginedType type:SACacheTypeDocumentPublic];
    return type.integerValue;
}

+ (NSString *)lastLoginUserHeadURL {
    return [SACacheManager.shared objectForKey:kCacheKeyLastLoginedHeadURL type:SACacheTypeDocumentPublic];
}

+ (NSString *)lastLoginUserShowName {
    return [SACacheManager.shared objectForKey:kCacheKeyLastLoginedShowName type:SACacheTypeDocumentPublic];
    ;
}

+ (NSString *)getUserMobile {
    if (HDIsStringNotEmpty(SAUser.shared.mobile)) {
        return SAUser.shared.mobile;
    } else if (HDIsStringNotEmpty(SAUser.shared.loginName)) {
        NSString *number = SAUser.shared.loginName;
        if ([number hasPrefix:@"855"] || [number hasPrefix:@"86"]) {
            int i = 2;
            BOOL res = YES;
            NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
            while (i < number.length) {
                NSString *string = [number substringWithRange:NSMakeRange(i, 1)];
                NSRange range = [string rangeOfCharacterFromSet:tmpSet];
                if (range.length == 0) {
                    res = NO;
                    break;
                }
                i++;
            }
            if (res)
                return number;
        }
    }
    return @"";
}

+ (void)loginWithPwdLoginRspModel:(SALoginRspModel *)rspModel {
    _sharedUser.loginName = rspModel.loginName;
    _sharedUser.nickName = rspModel.nickName;
    _sharedUser.accessToken = rspModel.accessToken;
    _sharedUser.refreshToken = rspModel.refreshToken;
    _sharedUser.headURL = rspModel.headURL;
    _sharedUser.operatorNo = rspModel.operatorNo;
    _sharedUser.hasLoginPwd = rspModel.hasLoginPwd;
    _sharedUser.lastLoginType = rspModel.lastLoginType;
    _sharedUser.mobile = rspModel.mobile;
    [_sharedUser save];

    // 发送登录成功通知
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameLoginSuccess object:nil];
}
@end
