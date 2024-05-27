//
//  TNDeliverInfoModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNDeliverInfoModel.h"
#import "TNAdaptImageModel.h"
#import "TNDeliverFlowModel.h"


@implementation TNDeliverVideoModel

@end


@implementation TNDeliverFreightModel

@end


@implementation TNDeliverAreaModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"freightTemplate": [TNDeliverFreightModel class]};
}

@end


@implementation TNDeliverInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"areaFreightDeclar": [TNDeliverAreaModel class]};
}

- (void)setOverseaImage:(NSArray<NSString *> *)overseaImage {
    _overseaImage = overseaImage;
    if (!HDIsArrayEmpty(overseaImage)) {
        self.deliverInfoImages = [TNAdaptImageModel getAdaptImageModelsByImagesStrs:overseaImage];
    }
}
- (TNDeliverFlowModel *)flowModel {
    if (!_flowModel) {
        _flowModel = [TNDeliverFlowModel modelWithDepartTxt:self.departTxt interShippingTxt:self.interShippingTxt arriveTxt:self.arriveTxt];
    }
    return _flowModel;
}
@end
