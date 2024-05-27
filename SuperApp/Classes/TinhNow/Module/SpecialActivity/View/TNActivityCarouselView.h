//
//  TNActivityCarouselView.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAddressModel.h"
#import "TNView.h"
@class TNSpeciaActivityDetailModel;
@class SAShoppingAddressModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNActivityCarouselView : TNView
/// 配置模型
@property (strong, nonatomic) TNSpeciaActivityDetailModel *model;
/// 展示地址按钮
@property (nonatomic, assign) BOOL showChangeAdressBtn;
/// 选择地址回调
@property (nonatomic, copy) void (^chooseAdressCallback)(SAShoppingAddressModel *adressModel, SAAddressModelFromType fromType);
/// 专题埋点前缀
@property (nonatomic, copy) NSString *speciaTrackPrefixName;
/// 更新地址显示
- (void)updateAdressText:(NSString *)adress;
@end

NS_ASSUME_NONNULL_END
