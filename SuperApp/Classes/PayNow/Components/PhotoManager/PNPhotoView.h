//
//  PNPhotoView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HXPhotoPicker/HXPhotoPicker.h>

NS_ASSUME_NONNULL_BEGIN


@interface PNPhotoView : HXPhotoView
+ (instancetype)photoManager:(HXPhotoManager *)manager addViewBackgroundColor:(UIColor *_Nullable)color;
@end

NS_ASSUME_NONNULL_END
