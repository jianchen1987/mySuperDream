//
//  PNWalletUploadImageItemView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/10/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNView.h"
#import "SAImageAccessor.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ButtonEnableBlock)(BOOL enabled, NSString *imageURL);


@interface PNWalletUploadImageItemView : PNView
/// 是否只展示【示例】
@property (nonatomic, assign) BOOL onlyShow;
/// 是否需要裁剪
@property (nonatomic, assign) BOOL needCrop;
/// 裁剪类型
@property (nonatomic, assign) SAImageCropMode cropMode;
/// 预占图片
@property (nonatomic, strong) UIImage *placeholderImage;
/// title
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) ButtonEnableBlock buttonEnableBlock;

- (void)setImageView:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
