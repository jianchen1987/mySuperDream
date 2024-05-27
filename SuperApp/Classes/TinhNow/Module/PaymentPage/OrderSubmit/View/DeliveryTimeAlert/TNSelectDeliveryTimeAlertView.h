//
//  TNSelectDeliveryTimeAlertView.h
//  SuperApp
//
//  Created by 张杰 on 2022/2/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//  用户选择配送时间弹窗

#import "TNCalcTotalPayFeeTrialRspModel.h"
#import <HDUIKit/HDUIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNSelectDeliveryTimeAlertView : HDActionAlertView
/// 选择日期回调  date  日期   time  时间区间 showStr 展示文案 appointmentType 预约类型
@property (nonatomic, copy) void (^selectedCallBack)(NSString *date, NSString *time, NSString *showStr, TNOrderAppointmentType appointmentType);
- (instancetype)initWithDataArr:(NSArray<TNCalcDateModel *> *)dataArr
           selectedDeliveryTime:(NSString *)selectedDeliveryTime
        selectedAppointmentType:(TNOrderAppointmentType)selectedAppointmentType
                          title:(NSString *)title
         immediateDeliveryModel:(TNImmediateDeliveryModel *_Nullable)immediateDeliveryModel;

@end

NS_ASSUME_NONNULL_END
