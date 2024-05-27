//
//  WMOrderCancelReasonModel.h
//  SuperApp
//
//  Created by wmz on 2021/8/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderCancelReasonModel : WMRspModel
/// 原因名称中
@property (nonatomic, copy) NSString *nameZh;
/// 原因名称英
@property (nonatomic, copy) NSString *nameEn;
/// 原因名称柬
@property (nonatomic, copy) NSString *nameKm;
/// 原因名称
@property (nonatomic, copy) NSString *name;
/// id
@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *operationCode;

@property (nonatomic, copy) NSString *cancellation;

@property (nonatomic, copy) NSString *operatorStr;

@property (nonatomic, assign, getter=isSelect) BOOL select;

@end

NS_ASSUME_NONNULL_END
