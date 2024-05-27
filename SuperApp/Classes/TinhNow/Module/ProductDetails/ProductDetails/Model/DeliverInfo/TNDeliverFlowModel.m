//
//  TNDeliverFlowModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNDeliverFlowModel.h"


@implementation TNDeliverFlowModel
+ (instancetype)modelWithDepartTxt:(NSString *)departTxt interShippingTxt:(NSString *)interShippingTxt arriveTxt:(NSString *)arriveTxt {
    TNDeliverFlowModel *model = [[TNDeliverFlowModel alloc] init];
    model.departTxt = departTxt;
    model.interShippingTxt = interShippingTxt;
    model.arriveTxt = arriveTxt;
    return model;
}
@end
