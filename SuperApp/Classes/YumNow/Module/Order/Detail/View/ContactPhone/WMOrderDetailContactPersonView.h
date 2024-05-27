//
//  WMOrderDetailContactPhoneView.h
//  SuperApp
//
//  Created by VanJay on 2020/7/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

@class WMOrderDetailRiderModel;


@interface WMOrderDetailContactPersonView : SAView <HDCustomViewActionViewProtocol>
/// 订单编号
@property (nonatomic, copy) NSString *orderNo;
/// 商家号码
@property (nonatomic, copy) NSString *merchantNumber;
/// 骑手号码
@property (nonatomic, strong) WMOrderDetailRiderModel *rider;
/// 选择了联系人
@property (nonatomic, copy) void (^clickedPersonBlock)(void);
/// 拨打号码
@property (nonatomic, copy) void (^clickedPhoneNumberBlock)(NSString *phoneNumber);
@end

NS_ASSUME_NONNULL_END
