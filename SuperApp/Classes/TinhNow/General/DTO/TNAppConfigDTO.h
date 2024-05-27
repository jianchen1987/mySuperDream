//
//  TNAppConfigDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/10/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class SATabBarItemConfig;
NS_ASSUME_NONNULL_BEGIN


@interface TNAppConfigDTO : TNModel
/// 查询首页 Tab 配置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryTinhnowTabBarConfigListSuccess:(void (^)(NSArray<SATabBarItemConfig *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
