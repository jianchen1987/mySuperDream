//
//  SAPhotoView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

// clang-format off
#if __has_include(<HXPhotoPicker/HXPhotoPicker.h>)
#import <HXPhotoPicker/HXPhotoPicker.h>
// clang-format on
#else
#import "HXPhotoPicker.h"
#endif

NS_ASSUME_NONNULL_BEGIN


@interface SAPhotoView : HXPhotoView

+ (instancetype)photoManager:(HXPhotoManager *)manager addViewBackgroundColor:(UIColor *_Nullable)color;

@end

NS_ASSUME_NONNULL_END
