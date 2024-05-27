//
//  WMFAQDTO.h
//  SuperApp
//
//  Created by wmz on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMFAQDetailRspModel.h"
#import "WMFAQRspModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMFAQDTO : WMModel
/// 获取新手指引链接
/// @param key key
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)yumNowQueryGuideLinkWithKey:(NSString *)key success:(void (^_Nullable)(WMFAQRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取新手指引内容
/// @param key key
/// @param code code
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)yumNowQueryGuideContentWithKey:(NSString *)key
                                                code:(NSString *)code
                                             success:(void (^_Nullable)(WMFAQDetailRspModel *rspModel))successBlock
                                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 评价新手指引内容
/// @param code code
/// @param parse parse
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)yumNowGuideFeedBackWithCode:(NSString *)code parrse:(BOOL)parse success:(CMNetworkSuccessBlock _Nullable)successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
