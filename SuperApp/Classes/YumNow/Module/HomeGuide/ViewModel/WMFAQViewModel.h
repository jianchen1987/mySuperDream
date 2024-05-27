//
//  WMFAQViewModel.h
//  SuperApp
//
//  Created by wmz on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMFAQDTO.h"
#import "WMViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMFAQViewModel : WMViewModel
/// rspModel
@property (nonatomic, strong, nullable) WMFAQRspModel *rspModel;
/// rspDetailModel
@property (nonatomic, strong, nullable) WMFAQDetailRspModel *rspDetailModel;
/// 获取新手指引链接
- (void)yumNowQueryGuideLinkWithKey:(NSString *)key block:(void (^_Nullable)(WMFAQRspModel *rspModel))block;

/// 获取新手指引内容
- (void)yumNowQueryGuideContentWithKey:(NSString *)key code:(NSString *)code block:(void (^_Nullable)(WMFAQDetailRspModel *rspModel))block;

/// 评价新手指引内容
- (void)yumNowGuideFeedBackWithCode:(NSString *)code parrse:(BOOL)parse block:(void (^_Nullable)(BOOL success))block;
@end

NS_ASSUME_NONNULL_END
