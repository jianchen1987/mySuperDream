//
//  SAPhotoManager.h
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPhotoView.h"
// clang-format off
#if __has_include(<HXPhotoPicker/HXPhotoPicker.h>)
// clang-format on
#import <HXPhotoPicker/HXPhotoPicker.h>
#else
#import "HXPhotoPicker.h"
#endif

NS_ASSUME_NONNULL_BEGIN


@interface SAPhotoManager : HXPhotoManager

@end

NS_ASSUME_NONNULL_END
