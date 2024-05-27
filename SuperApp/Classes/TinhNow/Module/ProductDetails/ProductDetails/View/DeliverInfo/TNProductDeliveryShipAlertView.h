//
//  TNProductDeliveryShipAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>
#import "TNDeliverInfoModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductDeliveryShipAlertView : HDActionAlertView
/// 数据源
@property (strong, nonatomic) NSArray<TNDeliverFreightModel *> *dataArr;

@end

NS_ASSUME_NONNULL_END
