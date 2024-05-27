//
//  PNUploadInfoView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInfoView.h"
#import "SAImageAccessor.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^PNUploadInfoBlock)(NSString *url);


@interface PNUploadInfoView : PNInfoView
/// 是否需要裁剪
@property (nonatomic, assign) BOOL needCrop;
/// 裁剪的类型
@property (nonatomic, assign) SAImageCropMode cropMode;

/// 是否可以使用 使用默认照片 弹窗选项
@property (nonatomic, assign) BOOL isCanSelectDefaultPhoto;

@property (nonatomic, copy) PNUploadInfoBlock uploadInfoBlock;

@end

NS_ASSUME_NONNULL_END
