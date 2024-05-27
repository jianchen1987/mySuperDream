//
//  PNGuarateenUploadImageView.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/10.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPhotoManager.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^DoneBlock)(void);


@interface PNGuarateenUploadImageView : PNView
/// 选择的照片
@property (nonatomic, copy, readonly) NSArray<HXPhotoModel *> *selectedPhotos;

/// 图片文件
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;

@property (nonatomic, copy) DoneBlock doneBlock;
@end

NS_ASSUME_NONNULL_END
