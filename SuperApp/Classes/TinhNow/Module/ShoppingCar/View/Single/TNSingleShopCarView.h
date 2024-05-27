//
//  TNSingleShopCarView.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNSingleShopCarView : TNView <HDCategoryListContentViewDelegate>

/// 点击删除
- (void)onDeleteShopCarProducts;
@end

NS_ASSUME_NONNULL_END
