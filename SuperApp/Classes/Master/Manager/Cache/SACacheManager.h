//
//  SACacheManager.h
//  SuperApp
//
//  Created by VanJay on 2020/4/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACacheKeyConst.h"
#import <Foundation/Foundation.h>

@class SAUser;

typedef NS_ENUM(NSInteger, SACacheType) {
    SACacheTypeDocumentNotPublic = 0, ///< 默认，Document，与 nameSpace 有关
    SACacheTypeDocumentPublic,        ///< Document，与 nameSpace 无关
    SACacheTypeCacheNotPublic,        ///< Cache，与 nameSpace 有关
    SACacheTypeCachePublic,           ///< Cache，与 nameSpace 无关
    SACacheTypeKeyChainNotPublic,     ///< KeyChain，与 nameSpace 有关
    SACacheTypeKeyChainPublic,        ///< KeyChain，与 nameSpace 无关
    SACacheTypeUserDefaultsNotPublic, ///< UserDefaults，与 nameSpace 有关
    SACacheTypeUserDefaultsPublic,    ///< UserDefaults，与 nameSpace 无关
    SACacheTypeMemonryNotPublic,      ///< 存内存，不序列化，与 nameSpace 有关
    SACacheTypeMemonryPublic,         ///< 存内存，不序列化，与 nameSpace 无关
};

NS_ASSUME_NONNULL_BEGIN


@interface SACacheManager : NSObject
/** 设置自定义空间 */
- (void)setCustomNameSpace:(NSString *)nameSpace;
+ (SACacheManager *)shared;

/**
 设置当前空间
 */
- (void)setCurrentNamespaceWithUser:(SAUser *)user;

/**
 根据Key缓存对象到磁盘，默认duration为0：对象一直存在，清理后失效，object为nil则removeObject

 @param aObject 存储对象，支持String,URL,Data,Number,Dictionary,Array,Null,自定义实体类
 @param aKey 唯一的对应的值，相同的值对覆盖原来的对象
 */
- (void)setObject:(id)aObject forKey:(NSString *)aKey;
- (void)setObject:(id)aObject forKey:(NSString *)aKey type:(SACacheType)cacheType;
- (void)setObject:(id)aObject forKey:(NSString *)aKey type:(SACacheType)cacheType relyLanguage:(BOOL)rely;

- (void)setPublicObject:(id)aObject forKey:(NSString *)aKey;
- (id)objectPublicForKey:(NSString *)aKey;

/**
 存储的对象的存在时间，duration默认为0，传-1，表示永久存在，不可被清理，只能手动移除或覆盖移除

 @param aObject 存储对象，支持String,URL,Data,Number,Dictionary,Array,Null,自定义实体类
 @param aKey 唯一的对应的值，相同的值对覆盖原来的对象
 @param duration 存储时间，单位:秒
 */
- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration;
- (void)setObject:(id)aObject forKey:(NSString *)aKey duration:(NSTimeInterval)duration type:(SACacheType)cacheType;

/**
 根据Key获取对象

 @param aKey 唯一的对应的值
 */
- (id)objectForKey:(NSString *)aKey;
- (id)objectForKey:(NSString *)aKey type:(SACacheType)cacheType;
- (id)objectForKey:(NSString *)aKey type:(SACacheType)cacheType relyLanguage:(BOOL)rely;

/**
 根据Key移除缓存对象，duration为负数的永久缓存可通过此方法清除

 @param aKey 唯一的对应的值
 */
- (void)removeObjectForKey:(NSString *)aKey;
- (void)removeObjectForKey:(NSString *)aKey type:(SACacheType)cacheType;

/**
 异步移除所有duration为0的缓存，不处理 keyChain 和偏好设置存储
 folderSize单位是字节，转换M需要folderSize/(1024.0*1024.0)

 @param completionBlock 完成回调
 */
- (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock;
- (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock type:(SACacheType)cacheType;

/**
 异步检查缓存(duration大于0)的生命，删除过期缓存，可在App启动使用，不处理 keyChain 和偏好设置存储
 */
- (void)removeExpireObjects;
- (void)removeExpireObjectsWithType:(SACacheType)cacheType;

/**
 不区分空间，对所有数据进行删除，谨慎操作，不处理 keyChain 和偏好设置存储

 @param completionBlock 完成回调
 */
+ (void)removeObjectsWithCompletionBlock:(void (^)(long long folderSize))completionBlock;

/**
 不区分空间，对所有缓存进行检查，删除过期缓存，谨慎操作，不处理 keyChain 和偏好设置存储
 */
+ (void)removeExpireObjects;

/** 清除内存缓存 */
- (void)clearMemory;

@end

NS_ASSUME_NONNULL_END
