//
//  TNBargainGoodView.h
//  SuperApp
//
//  Created by 张杰 on 2020/10/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
//#import "TNBargainGoodModel.h"
#import "TNProductSkuModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainGoodView : TNView
/// sku模型
@property (strong, nonatomic) TNProductSkuModel *model;
/// 商品名称
@property (nonatomic, copy) NSString *goodName;
@end

NS_ASSUME_NONNULL_END
