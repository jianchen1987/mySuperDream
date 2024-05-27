//
//  CMSMuItipleIconTextMarqueeCardItemView.h
//  SuperApp
//
//  Created by Chaos on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN
@class CMSMuItipleIconTextMarqueeItemConfig;


@interface CMSMuItipleIconTextMarqueeCardItemView : SAView

@property (nonatomic, strong) CMSMuItipleIconTextMarqueeItemConfig *model;

/// 点击回调
@property (nonatomic, copy) void (^clickView)(CMSMuItipleIconTextMarqueeItemConfig *config, NSString *_Nullable link);

@end

NS_ASSUME_NONNULL_END
