//
//  WMHomeCustomDTO.h
//  SuperApp
//
//  Created by wmz on 2022/4/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMHomeNoticeModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMHomeCustomDTO : WMModel
/// 获取首页通知
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryYumNowHomeNoticeSuccess:(void (^_Nullable)(NSArray<WMHomeNoticeModel *> *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
