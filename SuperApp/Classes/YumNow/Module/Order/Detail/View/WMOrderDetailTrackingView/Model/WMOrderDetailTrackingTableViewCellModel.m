//
//  WMOrderDetailTrackingTableViewCellModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailTrackingTableViewCellModel.h"


@implementation WMOrderDetailTrackingTableViewCellModel
+ (instancetype)modelWithStatus:(WMOrderDetailTrackingStatus)status title:(NSString *)title desc:(NSString *)desc {
    WMOrderDetailTrackingTableViewCellModel *model = WMOrderDetailTrackingTableViewCellModel.new;
    model.status = status;
    model.title = title;
    model.desc = desc;
    return model;
}
@end
