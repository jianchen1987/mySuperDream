//
//  PNMSStoreImageTakeView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/11/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPhotoManager.h"
#import "PNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNMSStoreImageTakeView : PNView
/// 选择的照片
@property (nonatomic, copy, readonly) NSArray<HXPhotoModel *> *selectedPhotos;

/// 图片文件
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;

@end

NS_ASSUME_NONNULL_END
