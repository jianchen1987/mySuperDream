//
//  TNGlobalData.m
//  SuperApp
//
//  Created by 张杰 on 2022/2/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//  存放一些全局数据 的单例

#import "TNGlobalData.h"
#import "SAApolloManager.h"
#import "TNShoppingCar.h"


@implementation TNGlobalData
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static TNGlobalData *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}
+ (void)clean {
    [TNGlobalData shared].orderAdress = nil;
    [TNGlobalData shared].seller = nil;
    //购物车的数据清理
    [[TNShoppingCar share] clean];
}
- (BOOL)isNeedGobackSupplierIncomePage {
    BOOL goBack = NO;
    NSString *goBackValue = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeyTinhnowSupplierIncomePageGoBack];
    if (HDIsStringNotEmpty(goBackValue)) {
        goBack = [goBackValue isEqualToString:@"1"] ? YES : NO;
    }
    return goBack;
}

+ (NSDictionary *)trackingPageEventMap {
    return @{
        @"TNHomeViewController": @"home",                                            //首页
        @"TNProductDetailsViewController": @[@"detail", @"buyer_detail"],            //商品详情
        @"TNSpecialActivityViewController": @"special",                              //专题
        @"TNShoppingCarViewController": @"cart",                                     //购物车
        @"TNSpecificationSelectAlertView": @"spec",                                  //规格
        @"TNOrderSubmitViewController": @"order",                                    //订单提交
        @"TNOrderDetailsViewController": @"order_result",                            //订单详情
        @"TNStoreInfoViewController": @[@"store_home", @"store_category"],           //店铺主页
        @"TNSearchViewController": @[@"search", @"store_search", @"special_search"], //搜索
        @"TNSellerTabBarViewController": @"buyer",                                   //微店
        @"TNClassificationViewController": @"category",                              //分类
    };
}
@end
