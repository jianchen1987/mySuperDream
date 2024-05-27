//
//  TNProductOriginalModel.h
//  SuperApp
//
//  Created by xixi on 2021/2/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNProductOriginalModel : TNModel
/// 原始商品id
@property (nonatomic, strong) NSString *originalId;
/// 原始商品是否有效（下架或删除）
@property (nonatomic, assign) BOOL originalValid;
/// 原始商品默认sku销售价
@property (nonatomic, strong) SAMoneyModel *price;
@end

NS_ASSUME_NONNULL_END
