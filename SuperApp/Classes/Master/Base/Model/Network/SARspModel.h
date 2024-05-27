//
//  SARspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/3/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *SAResponseType NS_STRING_ENUM;
/// 成功
FOUNDATION_EXPORT SAResponseType const SAResponseTypeSuccess;


@interface SARspInfoModel : SAModel
/// 码
@property (nonatomic, copy, nullable) SAResponseType code;
/// 信息
@property (nonatomic, copy, nullable) NSString *msg;
/// 数据，字典或者数组
@property (nonatomic, copy, nullable) id<NSCoding, NSCopying> data;
@end


@interface SARspModel : SARspInfoModel
/// 类型
@property (nonatomic, copy, nullable) NSString *rspType;
/// 版本
@property (nonatomic, copy, nullable) NSString *version;
/// 信息
@property (nonatomic, copy) NSString *time;
/// 是否是成功的业务数据
@property (nonatomic, assign, readonly) BOOL isValid;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
