//
//  TNSellerOrderRspModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"
#import "TNSellerOrderModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNSellerOrderRspModel : TNPagingRspModel
@property (strong, nonatomic) NSArray<TNSellerOrderModel *> *content;
@end

NS_ASSUME_NONNULL_END
