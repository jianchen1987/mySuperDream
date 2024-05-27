//
//  SAOrderModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderModel.h"
#import "SAGeneralUtil.h"


@interface SAOrderModel ()

///< MM/dd/yyyy HH:mm
@property (nonatomic, copy) NSString *orderTimeStr;

@end


@implementation SAOrderModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"storeNo": @[@"storeNo", @"storeId"], @"speedDelivery": @"businessContent.speedDelivery"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"goodsInfoList": SAOrderGoodListModel.class,
    };
}

#pragma mark - setter
- (void)setOrderTime:(NSTimeInterval)orderTime {
    _orderTime = orderTime;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.orderTime / 1000.0];
    _orderTimeStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
}

@end


@implementation SAOrderGoodListModel

@end


@implementation SAOrderBusinessModel

@end
