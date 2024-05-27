//
//  WMNewCarouselAdvertiseTableViewCell.h
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewFoucsAdvertiseTableViewCell.h"
#import "WMAdadvertisingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewCarouselAdvertiseTableViewCell : WMNewFoucsAdvertiseTableViewCell
/// pageControl
@property (nonatomic, strong) HDPageControl *pageControl;

@end


@interface WMNewCarouselAdvertiseItemCardCell : WMItemCardCell
///图片
@property (nonatomic, strong) SDAnimatedImageView *imageView;

@end

NS_ASSUME_NONNULL_END
