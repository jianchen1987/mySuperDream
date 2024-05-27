//
//  WMSpecialBrandPagingModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "WMSpecialBrandModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMSpecialBrandPagingModel : SACommonPagingRspModel
/// 列表
@property (nonatomic, copy) NSArray<WMSpecialBrandModel *> *list;

@end

NS_ASSUME_NONNULL_END
