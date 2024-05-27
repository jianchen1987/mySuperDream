//
//  TNDeliveryAreaMapBottomTipView.h
//  SuperApp
//
//  Created by 张杰 on 2021/9/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"
@class TNDeliveryAreaMapModel;
@class TNDeliveryAreaStoreInfoModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNDeliveryAreaMapBottomTipView : TNView
/// 收货地址
@property (nonatomic, copy) NSString *adressName;
/// 提示文本
@property (nonatomic, copy) NSString *tips;
/// 模型
@property (strong, nonatomic) TNDeliveryAreaMapModel *model;
///进入专题回调
@property (nonatomic, copy) void (^activityClickCallBack)(void);
///选择收货地址回调
@property (nonatomic, copy) void (^adressClickCallBack)(void);
/// 点击专题名称回调
@property (nonatomic, copy) void (^storeTagClickCallBack)(TNDeliveryAreaStoreInfoModel *model);
/// 更新选中
- (void)updateStoreTagSelected;
@end

NS_ASSUME_NONNULL_END
