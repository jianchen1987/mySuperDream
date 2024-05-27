//
//  PayHDTradeBuildOrderRspModel.m
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDTradeBuildOrderRspModel.h"


@implementation PayHDTradeBuildOrderRspModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.inputVCTitle = PNLocalizedString(@"PAYPASSWORD_INPUT_WARM", @"请输入支付密码");
        self.tipsStr = @"";
    }
    return self;
}

+ (instancetype)modelWithOrderAmount:(SAMoneyModel *)orderAmt tradeNo:(NSString *)tradeNo {
    return [[self alloc] initWithOrderAmount:orderAmt tradeNo:tradeNo];
}

- (instancetype)initWithOrderAmount:(SAMoneyModel *)orderAmt tradeNo:(NSString *)tradeNo {
    if (self = [super init]) {
        self.payAmt = orderAmt;
        self.tradeNo = tradeNo;
        self.customerInfo = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}
@end
