//
//  TNQueryOrderDetailsRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsBizPartModel.h"
#import "TNOrderDetailsMidPartModel.h"
#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNQueryOrderDetailsRspModel : TNRspModel
/// 订单业务部分
@property (nonatomic, strong) TNOrderDetailsBizPartModel *orderDetail;
/// 中台部分
@property (nonatomic, strong) TNOrderDetailsMidPartModel *orderInfo;

@end

NS_ASSUME_NONNULL_END
