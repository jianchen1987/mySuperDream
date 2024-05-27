//
//  PNRspModel.h
//  SuperApp
//
//  Created by seeu on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *PNResponseType NS_STRING_ENUM;
/// 成功
FOUNDATION_EXPORT PNResponseType const PNResponseTypeSuccess;


@interface PNRspInfoModel : PNModel
/// 码
@property (nonatomic, copy, nullable) PNResponseType code;
/// 信息
@property (nonatomic, copy, nullable) NSString *msg;
/// 数据，字典或者数组
@property (nonatomic, copy, nullable) id data;
@end


@interface PNRspModel : PNRspInfoModel
/// 类型
@property (nonatomic, copy, nullable) NSString *rspType;
/// 版本
@property (nonatomic, copy, nullable) NSString *version;
/// 信息
@property (nonatomic, copy) NSString *time;
/// 是否是成功的业务数据
@property (nonatomic, assign, readonly) BOOL isValid;

@end

NS_ASSUME_NONNULL_END
