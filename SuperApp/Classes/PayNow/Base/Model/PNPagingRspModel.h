//
//  PNPagingRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCommonPagingRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPagingRspModel : HDCommonPagingRspModel
/// 全部页码
@property (nonatomic, assign) NSInteger pages;
@end

NS_ASSUME_NONNULL_END
