//
//  PNLabel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

typedef enum {
    PNVerticalAlignmentTop = 1, // default
    PNVerticalAlignmentMiddle = 2,
    PNVerticalAlignmentBottom = 3,
} PNVerticalAlignment;

NS_ASSUME_NONNULL_BEGIN


@interface PNLabel : HDLabel

@property (nonatomic, assign) PNVerticalAlignment verticalAlignment;

@end

NS_ASSUME_NONNULL_END
