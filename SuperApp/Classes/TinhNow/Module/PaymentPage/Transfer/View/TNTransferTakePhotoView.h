//
//  TNTransferTakePhotoView.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import "SAPhotoManager.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNTransferTakePhotoView : TNView
/// 选择的照片
@property (nonatomic, copy, readonly) NSArray<HXPhotoModel *> *selectedPhotos;
/// 图片文件
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;
/// 是否需要隐藏添加 和 删除按钮  用于仅查看状态
@property (nonatomic, assign) BOOL hiddenAddAndDeleteBtn;

@end

NS_ASSUME_NONNULL_END
