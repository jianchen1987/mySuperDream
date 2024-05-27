//
//  SAEarnPointBannerRspModel.h
//  SuperApp
//
//  Created by Tia on 2022/10/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SARspModel.h"
@class SAEarnPointBannerRspModel;
@class SAEarnPointBannerModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAEarnPointBannerRspModel : SARspInfoModel
/// 已达门槛
@property (nonatomic, strong) SAEarnPointBannerModel *reachThreshold;
/// 未达门槛
@property (nonatomic, strong) SAEarnPointBannerModel *thresholdNotMet;

@end


@interface SAEarnPointBannerModel : NSObject
/// banner分组id
@property (nonatomic, copy) NSString *bannerGroupId;
/// bannerId
@property (nonatomic, copy) NSString *bannerId;
/// 中文按钮
@property (nonatomic, copy) NSString *buttonTextCn;
/// 英文按钮
@property (nonatomic, copy) NSString *buttonTextEn;
/// 柬文按钮
@property (nonatomic, copy) NSString *buttonTextKh;
/// 跳转链接
@property (nonatomic, copy) NSString *forwardLink;
/// 中文提示语
@property (nonatomic, copy) NSString *hintsCn;
/// 英文提示语
@property (nonatomic, copy) NSString *hintsEn;
/// 柬文提示语
@property (nonatomic, copy) NSString *hintsKh;
/// 中文图片
@property (nonatomic, copy) NSString *imageUrlCn;
/// 英文图片
@property (nonatomic, copy) NSString *imageUrlEn;
/// 柬文图片
@property (nonatomic, copy) NSString *imageUrlKh;
/// 中文备注语
@property (nonatomic, copy) NSString *remarkCn;
/// 英文备注语
@property (nonatomic, copy) NSString *remarkEn;
/// 柬文备注语
@property (nonatomic, copy) NSString *remarkKh;
/// banner状态 0-停用 1-启用
@property (nonatomic, assign) NSInteger status;
/// banner类型 1-未达门槛 2-已达门槛
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
