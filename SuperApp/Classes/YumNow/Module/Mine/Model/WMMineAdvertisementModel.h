//
//  WMMineAdvertisementModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class SAWindowItemModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMMineAdvertisementModel : WMModel

/// 广告模型
@property (nonatomic, strong) SAWindowItemModel *model;
/// 高宽比
@property (nonatomic, assign) CGFloat advertisementHeight2WidthScale;

@end

NS_ASSUME_NONNULL_END
