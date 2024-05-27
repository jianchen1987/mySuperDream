//
//  WMOrderBoxView.h
//  SuperApp
//
//  Created by wmz on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMOrderDetailCommodityModel.h"
#import "WMShoppingCartStoreProduct.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderBoxView : SAView <HDCustomViewActionViewProtocol>

- (void)configureWithOrderDetailRspModel:(WMOrderDetailCommodityModel *)payFeeTrialCalRspModel;

- (void)configureWithSubmitRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel;

@end

NS_ASSUME_NONNULL_END
