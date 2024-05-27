//
//  TNAdaptHeightImagesView.h
//  SuperApp
//
//  Created by 张杰 on 2021/5/10.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNAdaptImageModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNAdaptHeightImagesView : UIView
/// 数组图片上下之间的间距
@property (nonatomic, assign) CGFloat vMargin;
/// 图片数组
@property (strong, nonatomic) NSArray<TNAdaptImageModel *> *images;
/// 获取图片高度后的回调  目前是需要根据图片的真实高度展示
@property (nonatomic, copy) void (^getRealImageSizeCallBack)(void);
/// 获取图片高度后的回调  目前是需要根据图片的真实高度展示  图片 下标和高度
@property (nonatomic, copy) void (^getRealImageSizeAndIndexCallBack)(NSInteger index, CGFloat imageHeight);
/// 图片点击回调
@property (nonatomic, copy) void (^imageViewClickCallBack)(NSInteger index, NSString *imgUrl, UIImageView *imageView);
@end

NS_ASSUME_NONNULL_END
