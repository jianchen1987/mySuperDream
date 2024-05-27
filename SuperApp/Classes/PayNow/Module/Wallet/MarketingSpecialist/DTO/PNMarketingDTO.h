//
//  PNMarketingDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2023/4/24.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PNMarketingDetailInfoModel;
@class PNMarketingListItemModel;
@class PNCheckMarketingRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNMarketingDTO : PNModel

/// 绑定推广专员
- (void)bindMarketing:(NSString *)mobile
    promoterLoginName:(NSString *)promoterLoginName
              success:(void (^_Nullable)(PNRspModel *rspModel))successBlock
              failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 通过手机号码反查 账号信息
- (void)getCCAmountWithMobile:(NSString *)mobile success:(void (^_Nullable)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 是否为推广专员
- (void)isPromoterAndBind:(void (^_Nullable)(PNCheckMarketingRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 是否已绑定推广专员
- (void)isBinded:(void (^_Nullable)(PNCheckMarketingRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询推广专员详情
- (void)queryPromoterDetail:(NSString *)mobile successBlock:(void (^_Nullable)(PNMarketingDetailInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 查询推广专员绑定的好友列表（需要脱敏）
- (void)queryPromoterFriendPage:(NSInteger)pageNo
              promoterLoginName:(NSString *)promoterLoginName
                   successBlock:(void (^_Nullable)(NSArray<PNMarketingListItemModel *> *rspModel))successBlock
                        failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
