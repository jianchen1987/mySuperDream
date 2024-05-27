//
//  TNProductSaleRegionModel.h
//  SuperApp
//
//  Created by xixi on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAInfoViewModel.h"
#import "TNModel.h"
@class TNProductSaleRegionModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNProductSaleRegionCellModel : SAInfoViewModel
///
@property (nonatomic, strong) TNProductSaleRegionModel *saleRegionModel;
@end


@interface TNProductSaleRegionModel : TNModel
/// 销售区域: 0全国 1指定区域金边  2.指定配送范围
@property (nonatomic, assign) NSInteger regionType;
/// 指定区域字符串','隔开
@property (nonatomic, strong) NSString *regionNames;
@end

NS_ASSUME_NONNULL_END
