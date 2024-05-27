//
//  WMSpecialActivesProductRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class WMSpecialActivesProductModel;


@interface WMSpecialActivesProductRspModel : SACommonPagingRspModel
/// 商品列表
@property (nonatomic, strong) NSArray<WMSpecialActivesProductModel *> *list;
@end

NS_ASSUME_NONNULL_END
