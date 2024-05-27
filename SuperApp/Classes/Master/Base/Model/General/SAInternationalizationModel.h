//
//  SAInternationalizationModel.h
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAInternationalizationModel : NSObject
@property (nonatomic, copy) NSString *en_US; ///< 英文
@property (nonatomic, copy) NSString *zh_CN; ///< 中文
@property (nonatomic, copy) NSString *km_KH; ///< 柬语

+ (instancetype)modelWithCN:(NSString *)zh en:(NSString *)en kh:(NSString *)kh;
- (instancetype)initWithCN:(NSString *)zh en:(NSString *)en kh:(NSString *)kh;

+ (instancetype)modelWithInternationalKey:(NSString *)key value:(NSString *__nullable)value table:(NSString *__nullable)table;
- (instancetype)initWithInternationalKey:(NSString *)key value:(NSString *__nullable)value table:(NSString *__nullable)table;

@property (nonatomic, copy, readonly) NSString *desc; ///< 当前语言环境的描述
@end


@interface SAInternationalizationModel (YumNow)
+ (instancetype)modelWithWMInternationalKey:(NSString *)key value:(NSString *__nullable)value table:(NSString *__nullable)table;
- (instancetype)initWithWMInternationalKey:(NSString *)key value:(NSString *__nullable)value table:(NSString *__nullable)table;
@end


@interface SAInternationalizationModel (GroupBuy)
+ (instancetype)modelWithGNInternationalKey:(NSString *)key value:(NSString *__nullable)value table:(NSString *__nullable)table;
- (instancetype)initWithGNInternationalKey:(NSString *)key value:(NSString *__nullable)value table:(NSString *__nullable)table;
@end

NS_ASSUME_NONNULL_END
