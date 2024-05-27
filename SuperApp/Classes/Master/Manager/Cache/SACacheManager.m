//
//  SACacheManager.m
//  SuperApp
//
//  Created by VanJay on 2020/4/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACacheManager.h"
#import "SAUser.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDServiceKit/HDCacheManager.h>


@interface SACacheManager ()
@property (nonatomic, copy) NSString *nameSpace;            ///< 自定义空间
@property (nonatomic, strong) SAUser *user;                 ///< 当前用户
@property (nonatomic, strong) HDCacheManager *cacheManager; ///< 缓存管理器
@end


@implementation SACacheManager

+ (SACacheManager *)shared {
    static dispatch_once_t onceToken;
    static SACacheManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.nameSpace = nil;
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

- (void)setCurrentNamespaceWithUser:(SAUser *)user {
    self.user = user;

    if (!user) {
        self.cacheManager = nil;
    }
}

- (void)setCustomNameSpace:(NSString *)nameSpace {
    self.nameSpace = nameSpace;
}

#pragma mark - private methods

- (NSString *)nameSpacePublic {
    return @"public";
}

- (NSString *)nameSpaceNotPublic {
    NSString *nameSpace = @"";

    if (self.user && HDIsStringNotEmpty(self.user.loginName)) {
        nameSpace = [self.user.loginName mutableCopy];
    } else if (HDIsStringNotEmpty(self.nameSpace) && [self.nameSpace isKindOfClass:NSString.class]) {
        nameSpace = [self.nameSpace mutableCopy];
    }
    return nameSpace;
}

- (void)settingCacheManagerPropertiesWithType:(SACacheType)cacheType compeletion:(void (^)(void))compeletionHandler {
    NSString *nameSpace = @"";
    BOOL isInDocumentDir = true;

    switch (cacheType) {
        case SACacheTypeDocumentNotPublic: {
            nameSpace = [self nameSpaceNotPublic];
            isInDocumentDir = true;
        } break;

        case SACacheTypeDocumentPublic: {
            nameSpace = [self nameSpacePublic];
            isInDocumentDir = true;
        } break;

        case SACacheTypeCacheNotPublic: {
            nameSpace = [self nameSpaceNotPublic];
            isInDocumentDir = false;
        } break;

        case SACacheTypeCachePublic: {
            nameSpace = [self nameSpacePublic];
            isInDocumentDir = false;
        } break;

        case SACacheTypeKeyChainNotPublic: {
            nameSpace = [self nameSpaceNotPublic];
            isInDocumentDir = self.cacheManager.isInDocumentDir;
        } break;

        case SACacheTypeKeyChainPublic: {
            nameSpace = [self nameSpacePublic];
            isInDocumentDir = self.cacheManager.isInDocumentDir;
        } break;

        case SACacheTypeUserDefaultsNotPublic: {
            nameSpace = [self nameSpaceNotPublic];
            isInDocumentDir = self.cacheManager.isInDocumentDir;
        } break;

        case SACacheTypeUserDefaultsPublic: {
            nameSpace = [self nameSpacePublic];
            isInDocumentDir = self.cacheManager.isInDocumentDir;
        } break;

        case SACacheTypeMemonryNotPublic: {
            nameSpace = [self nameSpaceNotPublic];
            isInDocumentDir = self.cacheManager.isInDocumentDir;
        } break;

        case SACacheTypeMemonryPublic: {
            nameSpace = [self nameSpacePublic];
            isInDocumentDir = self.cacheManager.isInDocumentDir;
        } break;

        default:
            break;
    }

    //    if (self.cacheManager.nameSpace != nameSpace) {
    self.cacheManager.nameSpace = nameSpace;
    //    }
    //    if (self.cacheManager.isInDocumentDir != isInDocumentDir) {
    self.cacheManager.isInDocumentDir = isInDocumentDir;
    //    }

    !compeletionHandler ?: compeletionHandler();
}

#pragma mark - document

- (void)setObject:(id)aObject forKey:(NSString *)aKey {
    [self setObject:aObject forKey:aKey type:SACacheTypeDocumentNotPublic];
}

- (void)setPublicObject:(id)aObject forKey:(NSString *)aKey {
    [self setObject:aObject forKey:aKey type:SACacheTypeDocumentPublic];
}

- (void)setObject:(id)aObject forKey:(NSString *)aKey type:(SACacheType)cacheType {
    [self settingCacheManagerPropertiesWithType:cacheType compeletion:^{
        if (cacheType == SACacheTypeKeyChainNotPublic || cacheType == SACacheTypeKeyChainPublic) {
            [self.cacheManager setObjectTokeyChain:aObject forKey:aKey];
        } else if (cacheType == SACacheTypeUserDefaultsNotPublic || cacheType == SACacheTypeUserDefaultsPublic) {
            [self.cacheManager setObjectToAppUserDefaults:aObject forKey:aKey];
        } else if (cacheType == SACacheTypeMemonryNotPublic || cacheType == SACacheTypeMemonryPublic) {
            [self.cacheManager setObject:aObject forKey:aKey toDisk:false];
        } else {
            [self.cacheManager setObject:aObject forKey:aKey];
        }
    }];
}

- (void)setObject:(id)aObject forKey:(NSString *)aKey type:(SACacheType)cacheType relyLanguage:(BOOL)rely {
    if (rely) {
        [self setObject:aObject forKey:[NSString stringWithFormat:@"%@.%@", aKey, SAMultiLanguageManager.currentLanguage] type:cacheType];
    } else {
        [self setObject:aObject forKey:aKey type:cacheType];
    }
}

- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration {
    [self setObject:aObject forKey:aKey duration:duration type:SACacheTypeDocumentNotPublic];
}

- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration type:(SACacheType)cacheType {
    [self settingCacheManagerPropertiesWithType:cacheType compeletion:^{
        if (cacheType == SACacheTypeKeyChainNotPublic || cacheType == SACacheTypeKeyChainPublic) {
            [self.cacheManager setObjectTokeyChain:aObject forKey:aKey];
        } else if (cacheType == SACacheTypeUserDefaultsNotPublic || cacheType == SACacheTypeUserDefaultsPublic) {
            [self.cacheManager setObjectToAppUserDefaults:aObject forKey:aKey];
        } else if (cacheType == SACacheTypeMemonryNotPublic || cacheType == SACacheTypeMemonryPublic) {
            [self.cacheManager setObject:aObject forKey:aKey toDisk:false];
        } else {
            [self.cacheManager setObject:aObject forKey:aKey duration:duration];
        }
    }];
}

- (id)objectForKey:(NSString *)aKey {
    return [self objectForKey:aKey type:SACacheTypeDocumentNotPublic];
}

- (id)objectPublicForKey:(NSString *)aKey {
    return [self objectForKey:aKey type:SACacheTypeDocumentPublic];
}

- (id)objectForKey:(NSString *)aKey type:(SACacheType)cacheType {
    [self settingCacheManagerPropertiesWithType:cacheType compeletion:nil];

    return [self.cacheManager objectForKey:aKey];
}

- (id)objectForKey:(NSString *)aKey type:(SACacheType)cacheType relyLanguage:(BOOL)rely {
    if (rely) {
        return [self objectForKey:[NSString stringWithFormat:@"%@.%@", aKey, SAMultiLanguageManager.currentLanguage] type:cacheType];
    } else {
        return [self objectForKey:aKey type:cacheType];
    }
}

- (void)removeObjectForKey:(NSString *)aKey {
    [self removeObjectForKey:aKey type:SACacheTypeDocumentNotPublic];
}

- (void)removeObjectForKey:(NSString *)aKey type:(SACacheType)cacheType {
    [self settingCacheManagerPropertiesWithType:cacheType compeletion:^{
        [self.cacheManager removeObjectForKey:aKey];
    }];
}

- (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock {
    [self removeObjectsWithCompletionBlock:completionBlock type:SACacheTypeDocumentNotPublic];
}

- (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock type:(SACacheType)cacheType {
    [self settingCacheManagerPropertiesWithType:cacheType compeletion:^{
        [self.cacheManager removeObjectsWithCompletionBlock:completionBlock];
    }];
}

/**
 异步检查缓存(duration大于0)的生命，删除过期缓存，可在App启动使用，不处理 keyChain 和偏好设置存储
 */
- (void)removeExpireObjects {
    [self removeExpireObjectsWithType:SACacheTypeDocumentNotPublic];
}

- (void)removeExpireObjectsWithType:(SACacheType)cacheType {
    [self settingCacheManagerPropertiesWithType:cacheType compeletion:^{
        [self.cacheManager removeExpireObjects];
    }];
}

- (void)clearMemory {
    [self.cacheManager clearMemory];
}

#pragma mark - lazy load
- (HDCacheManager *)cacheManager {
    if (!_cacheManager) {
        _cacheManager = [HDCacheManager cacheManagerWithNameSpace:[self nameSpacePublic] isInDocumentDir:true];
    }
    return _cacheManager;
}

#pragma mark - common
+ (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock {
    [HDCacheManager removeObjectsWithCompletionBlock:completionBlock];
}

+ (void)removeExpireObjects {
    [HDCacheManager removeExpireObjects];
}
@end
