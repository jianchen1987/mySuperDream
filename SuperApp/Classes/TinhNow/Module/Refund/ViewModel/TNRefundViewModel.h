//
//  TNRefundViewModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNViewModel.h"
#import "TNRefundSimpleOrderInfoModel.h"
#import "TNRefundDetailsModel.h"

@class TNRefundCommonDictItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface TNRefundViewModel : TNViewModel
/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 申请退款页面
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;

/// 退款类型 -数据源
@property (nonatomic, strong) NSArray<TNRefundCommonDictItemModel *> *refundTypeArray;
/// 申请原因 - 数据源
@property (nonatomic, strong) NSArray<TNRefundCommonDictItemModel *> *applyReasonTypeArray;
/// 申请类型 - 数据源
@property (nonatomic, strong) NSArray<TNRefundCommonDictItemModel *> *applyRefundTypeArray;

/// 当前选中的 - 退款类型
@property (nonatomic, strong) TNRefundCommonDictItemModel *currentRefundType;
/// 当前选中的 - 退款原因
@property (nonatomic, strong) TNRefundCommonDictItemModel *currentApplyReasonType;
/// 当前选中的 - 申请原因
@property (nonatomic, strong) TNRefundCommonDictItemModel *currentApplyRefundType;
/// 简单的订单数据
@property (nonatomic, strong) TNRefundSimpleOrderInfoModel *simpleOrderInfoModel;

/// 获取字典数据
- (void)hd_getData:(NSString *)orderNo;

/// 提交申请退款
- (void)postApplyInfoData:(NSDictionary *)paramsDic success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
