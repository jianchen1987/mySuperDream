//
//  TNRedZoneSaleAreaAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/2/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNRedZoneActivityModel.h"
#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNRedZoneSaleAreaAlertView : HDActionAlertView
/// 点击专题回调
@property (nonatomic, copy) void (^clickActivityCallBack)(TNRedZoneAdressForActivityModel *model);
/// 新建收货地址回调
@property (nonatomic, copy) void (^addNewAdressCallBack)(void);
/// 查看配送区域回调
@property (nonatomic, copy) void (^watchDeliverAreaCallBack)(void);
/// 返回商城回调
@property (nonatomic, copy) void (^backHomeCallBack)(void);
- (instancetype)initWithDataArr:(NSArray<TNRedZoneAdressForActivityModel *> *)dataArr;
@end

NS_ASSUME_NONNULL_END
