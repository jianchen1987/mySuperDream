//
//  HDTakingPhotoViewConfig.m
//  SuperApp
//
//  Created by VanJay on 2019/7/20.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTakingPhotoViewConfig.h"
#import <HDKitCore/HDCommonDefines.h>


@implementation HDTakingPhotoViewConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认值
        self.showFocusFrame = true;
        self.shouldHorizontalFlipFrontCameraImage = YES;
    }
    return self;
}
@end
