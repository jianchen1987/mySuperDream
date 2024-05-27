//
//  TNSellerOrderView.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderDTO.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerOrderView : TNView <HDCategoryListContentViewDelegate>
- (instancetype)initWithStatus:(TNSellerOrderStatus)status;
@end

NS_ASSUME_NONNULL_END
