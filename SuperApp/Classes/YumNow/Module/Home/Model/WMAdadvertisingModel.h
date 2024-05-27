//
//  WMAdadvertisingModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMAdadvertisingModel : WMModel
/// id
@property (nonatomic, assign) NSInteger id;
/// link
@property (nonatomic, copy) NSString *link;
/// images
@property (nonatomic, copy) NSString *images;
/// linkType
@property (nonatomic, copy) NSString *linkType;
/// 活动精选新版的图片字段
@property (nonatomic, copy) NSString *nImages;

@property (nonatomic, copy) NSString *showContentEn;
@property (nonatomic, copy) NSString *showContentZh;
@property (nonatomic, copy) NSString *showContentKm;

@property (nonatomic, copy) NSString *showContent;
@property (nonatomic, assign) CGFloat showContentWidth;

@end

NS_ASSUME_NONNULL_END
