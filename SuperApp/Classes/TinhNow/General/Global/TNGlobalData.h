//
//  TNGlobalData.h
//  SuperApp
//
//  Created by 张杰 on 2022/2/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAShoppingAddressModel.h"
#import "TNSeller.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNGlobalData : NSObject
/// 卖家数据
@property (strong, nonatomic) TNSeller *_Nullable seller;
/// 本地购订单  选择的地址   目前主要用于 酒水专题 切换地址后  去下单的时候 可以用到这个地址
@property (strong, nonatomic) SAShoppingAddressModel *_Nullable orderAdress;
/// 卖家收益页面是否回退版本  读取阿波罗配置
@property (nonatomic, assign) BOOL isNeedGobackSupplierIncomePage;

+ (instancetype)shared;
//清空单例数据
+ (void)clean;
/// 埋点类名与事件名映射表
+ (NSDictionary *)trackingPageEventMap;
@end

NS_ASSUME_NONNULL_END
