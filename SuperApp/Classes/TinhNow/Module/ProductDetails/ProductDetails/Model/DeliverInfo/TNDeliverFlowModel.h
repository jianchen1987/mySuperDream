//
//  TNDeliverFlowModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNDeliverFlowModel : TNModel
/// 出发地
@property (nonatomic, copy) NSString *departTxt;
/// 国际物流
@property (nonatomic, copy) NSString *interShippingTxt;
/// 目的地
@property (nonatomic, copy) NSString *arriveTxt;
+ (instancetype)modelWithDepartTxt:(NSString *)departTxt interShippingTxt:(NSString *)interShippingTxt arriveTxt:(NSString *)arriveTxt;
@end

NS_ASSUME_NONNULL_END
