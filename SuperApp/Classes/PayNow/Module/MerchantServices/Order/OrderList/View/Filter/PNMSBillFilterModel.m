//
//  BillsTypeModel.m
//  National Wallet
//
//  Created by 谢 on 2018/5/4.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "PNMSBillFilterModel.h"


@implementation PNMSBillFilterModel

+ (instancetype)billsTypeTitle:(NSString *)titleName image:(NSString *)imageName describe:(NSString *)describe billType:(PNTransType)type {
    PNMSBillFilterModel *model = [PNMSBillFilterModel new];
    model.titleName = titleName;
    //    model.imageName = imageName;
    //    model.describe = describe;
    //    model.type = type;
    return model;
}

+ (instancetype)billsTypeTitle:(NSString *)titleName image:(NSString *)imageName describe:(NSString *)describe {
    PNMSBillFilterModel *model = [PNMSBillFilterModel new];
    model.titleName = titleName;
    //    model.imageName = imageName;
    //    model.describe = describe;

    return model;
}
@end
