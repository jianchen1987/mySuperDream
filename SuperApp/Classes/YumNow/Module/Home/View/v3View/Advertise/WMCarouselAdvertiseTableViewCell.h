//
//  WMCarouselAdvertiseTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/4/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMAdadvertisingModel.h"
#import "WMFoucsAdvertiseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCarouselAdvertiseTableViewCell : WMFoucsAdvertiseTableViewCell
/// pageControl
@property (nonatomic, strong) HDPageControl *pageControl;

@end


@interface WMCarouselAdvertiseItemCardCell : WMItemCardCell

@end

NS_ASSUME_NONNULL_END
