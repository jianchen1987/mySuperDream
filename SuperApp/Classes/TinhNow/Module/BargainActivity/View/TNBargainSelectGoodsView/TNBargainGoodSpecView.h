//
//  TNBargainGoodSpecView.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import "TNProductDetailsRspModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainGoodSpecView : TNView
/// 商品规格模型
@property (strong, nonatomic) TNProductDetailsRspModel *skuModel;
/// 选完规格后回调
@property (nonatomic, copy) void (^selectedSpecCallBack)(TNProductSkuModel *sku);
/// 获取TNBargainGoodSpecView高度  主要是内层table高度
- (CGFloat)getGoodSpecTableViewHeight;
@end

NS_ASSUME_NONNULL_END
