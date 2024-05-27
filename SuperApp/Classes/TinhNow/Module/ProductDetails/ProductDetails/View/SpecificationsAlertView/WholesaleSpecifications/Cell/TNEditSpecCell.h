//
//  TNEditSpecCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNModel.h"
#import "TNProductBatchPriceInfoModel.h"
@class TNProductSkuModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNEditSpecCellModel : TNModel
/// spec名称
@property (nonatomic, copy) NSString *name;
/// 对应的sku数据
@property (strong, nonatomic) TNProductSkuModel *skuModel;
/// 阶梯价模型
@property (strong, nonatomic) TNProductBatchPriceInfoModel *batchPriceInfoModel;

@end


@interface TNEditSpecCell : SATableViewCell
///
@property (strong, nonatomic) TNEditSpecCellModel *cellModel;
///  输入商品数量后回调
@property (nonatomic, copy) void (^enterCountCallBack)(TNEditSpecCellModel *cellModel);
@end

NS_ASSUME_NONNULL_END
