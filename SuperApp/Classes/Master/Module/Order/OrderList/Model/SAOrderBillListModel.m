//
//  SAOrderBillListModel.m
//  SuperApp
//
//  Created by Tia on 2023/2/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderBillListModel.h"
#import "SAGeneralUtil.h"


@interface SAOrderBillListItemModel ()

@property (nonatomic, copy) NSString *finishTimeStr;

@end


@implementation SAOrderBillListItemModel

- (void)setFinishTime:(NSTimeInterval)finishTime {
    _finishTime = finishTime;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.finishTime / 1000.0];
    _finishTimeStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
}

- (void)setCreateTime:(NSTimeInterval)createTime {
    _createTime = createTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.createTime / 1000.0];
    _createTimeStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
}

@end


@implementation SAOrderBillListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"payList": SAOrderBillListItemModel.class,
        @"refundList": SAOrderBillListItemModel.class,
    };
}

@end
