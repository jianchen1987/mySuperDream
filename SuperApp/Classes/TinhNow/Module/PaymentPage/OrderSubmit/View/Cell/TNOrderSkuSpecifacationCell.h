//
//  TNSkuSpecifacationCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "SATableViewCell.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNOrderSkuSpecifacationCellModel : TNModel
/// 商品图片
@property (nonatomic, copy) NSString *thumbnail;
/// 规格名称
@property (nonatomic, copy) NSString *spec;
/// 数量
@property (nonatomic, copy) NSNumber *quantity;
/// 金额
@property (nonatomic, strong) SAMoneyModel *price;
/// skuId
@property (nonatomic, copy) NSString *skuId;
///
@property (nonatomic, assign) CGFloat lineHeight;
///无效sku文案
@property (nonatomic, copy) NSString *invalidMsg;
@end


@interface TNOrderSkuSpecifacationCell : SATableViewCell
///
@property (strong, nonatomic) TNOrderSkuSpecifacationCellModel *cellModel;
@end

NS_ASSUME_NONNULL_END
