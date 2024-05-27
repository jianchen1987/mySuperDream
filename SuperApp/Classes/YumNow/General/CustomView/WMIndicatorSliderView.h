//
//  WMIndicatorSliderView.h
//  SuperApp
//
//  Created by wmz on 2022/3/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMIndicatorSliderView : SAView
///滑动条
@property (nonatomic, strong) UIView *sliderView;
/// 0-1
@property (nonatomic, assign) CGFloat offset;
@end

NS_ASSUME_NONNULL_END
