//
//  WMOrderSubmitFullGiftRspModel.h
//  SuperApp
//
//  Created by wmz on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"
#import "WMStoreFillGiftRuleModel.h"
#import "SAInternationalizationModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitFullGiftRspModel : WMRspModel
/// 活动类型
@property (nonatomic, assign) NSInteger marketType;
/// 检查结束标识
@property (nonatomic, assign) BOOL result;
/// 活动标题
@property (nonatomic, strong) SAInternationalizationModel *activityTitle;
/// 失败原因
@property (nonatomic, copy) NSArray<NSString *> *checkActivityResults;
/// 失败原因
@property (nonatomic, copy) NSString *checkActivityResultStr;
/// 活动内容详情
@property (nonatomic, copy) NSArray<WMStoreFillGiftRuleModel *> *activityContentResps;
/// 赠品信息
@property (nonatomic, copy) NSArray<WMStoreFillGiftRuleModel *> *giftListResps;
/// custom Age
@property (nonatomic, assign) NSInteger age;
/// 活动长拼接文本
@property (nonatomic, copy) NSString *fillName;
@end

NS_ASSUME_NONNULL_END
