//
//  WMHomeColumnModel.h
//  SuperApp
//
//  Created by wmz on 2023/6/26.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMHomeColumnModel : WMModel
///nameEn
@property (nonatomic, copy) NSString *nameEn;
///nameEn
@property (nonatomic, copy) NSString *nameKm;
///nameEn
@property (nonatomic, copy) NSString *nameZh;
///name
@property (nonatomic, copy) NSString *name;
///param
@property (nonatomic, copy) NSDictionary *param;
///tag
@property (nonatomic, copy) NSString *tag;
///添加默认附近门店标签
+(WMHomeColumnModel*)addDefaultTag;
@end

NS_ASSUME_NONNULL_END
