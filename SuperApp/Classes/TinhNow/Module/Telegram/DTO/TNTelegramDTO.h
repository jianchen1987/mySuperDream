//
//  TNTelegramDTO.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNModel.h"
@class TNTelegramGroupModel;
NS_ASSUME_NONNULL_BEGIN


@interface TNTelegramDTO : TNModel
/// 获取绑定的TG群数据
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryTelegramGroupInfoSuccess:(void (^_Nullable)(TNTelegramGroupModel *model))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
