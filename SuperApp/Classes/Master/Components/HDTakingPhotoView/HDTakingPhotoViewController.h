//
//  HDTakingPhotoViewController.h
//  SuperApp
//
//  Created by VanJay on 19/4/3.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTakingPhotoView.h"
#import "HDTakingPhotoViewConfig.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HDTakingPhotoVieChoosedImageBlock)(UIImage *_Nullable image, NSError *_Nullable error);


@interface HDTakingPhotoViewController : UIViewController
/// 选择了照片的回调
@property (nonatomic, copy) HDTakingPhotoVieChoosedImageBlock choosedImageBlock;
/// 界面配置
@property (nonatomic, strong) HDTakingPhotoViewConfig *config;
@end

NS_ASSUME_NONNULL_END
