//
//  SJClipsVideoCountDownView.h
//  SJVideoPlayer
//
//  Created by 畅三江 on 2019/1/20.
//  Copyright © 2019 畅三江. All rights reserved.
//

#import "SJProgressSlider.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SJClipsVideoCountDownView : UIView
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *promptLabel;
@property (nonatomic, strong, readonly) SJProgressSlider *progressSlider;
@end
NS_ASSUME_NONNULL_END
