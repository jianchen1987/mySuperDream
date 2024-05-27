//
//  HDTakingPhotoViewConfig.h
//  SuperApp
//
//  Created by VanJay on 2019/7/20.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDTakingPhotoViewConfig : NSObject
/// 是否显示聚焦 View，默认 YES
@property (nonatomic, assign) BOOL showFocusFrame;
/// 前置拍摄是否水平翻转照片,，默认 YES
@property (nonatomic, assign) BOOL shouldHorizontalFlipFrontCameraImage;
@end

NS_ASSUME_NONNULL_END
