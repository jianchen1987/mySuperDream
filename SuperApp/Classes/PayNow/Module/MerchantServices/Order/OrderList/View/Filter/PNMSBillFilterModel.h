//
//  BillsTypeModel.h
//  National Wallet
//
//  Created by 谢 on 2018/5/4.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "PNEnum.h"

#import <Foundation/Foundation.h>


@interface PNMSBillFilterModel : NSObject

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *value; //记录一下tag ，type
@property (nonatomic, assign) BOOL isSelected;

+ (instancetype)billsTypeTitle:(NSString *)titleName image:(NSString *)imageName describe:(NSString *)describe billType:(PNTransType)type;
@end
