//
//  WMProductPackingFeeViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMShoppingCartPayFeeCalProductModel;


@interface WMProductPackingFeeViewModel : WMViewModel
/// 试算商品列表
@property (nonatomic, copy) NSArray<WMShoppingCartPayFeeCalProductModel *> *productList;
/// 打包费
@property (nonatomic, strong) SAMoneyModel *packingFee;

@end

NS_ASSUME_NONNULL_END
