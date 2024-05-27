//
//  SALotAnimationView.h
//  SuperApp
//
//  Created by Tia on 2022/7/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Lottie/Lottie.h>

NS_ASSUME_NONNULL_BEGIN


@interface SALotAnimationView : LOTAnimationView

/// Load animation  from the specified URL
- (void)setAnimationFromURL:(NSString *)animationURL;

@end

NS_ASSUME_NONNULL_END
