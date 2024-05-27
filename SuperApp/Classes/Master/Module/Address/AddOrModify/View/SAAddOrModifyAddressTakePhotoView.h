//
//  SAAddOrModifyAddressTakePhotoView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPhotoManager.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAddOrModifyAddressTakePhotoView : SAView
/// 选择的照片
@property (nonatomic, copy, readonly) NSArray<HXPhotoModel *> *selectedPhotos;

/// 图片文件
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;

@end

NS_ASSUME_NONNULL_END
