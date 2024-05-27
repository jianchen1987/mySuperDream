//
//  CMSSingleImageScrolledCardView.h
//  SuperApp
//
//  Created by Chaos on 2021/6/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSCardView.h"

NS_ASSUME_NONNULL_BEGIN


@interface CMSSingleImageScrolledCardView : SACMSCardView

/// 图片比例 (高：宽)
@property (nonatomic, assign) CGFloat imageRatio;
/// 图片圆角
@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
