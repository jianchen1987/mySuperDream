//
//  TNTakePhotoView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAPhotoManager.h"
#import "TNTakePhotoConfig.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNTakePhotoView : TNView
- (instancetype)initWithConfig:(TNTakePhotoConfig *)config;
/// 选择的照片
@property (nonatomic, copy, readonly) NSArray<HXPhotoModel *> *selectedPhotos;
/// 查看图片地址
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;
/// 不可编辑
@property (nonatomic, assign) BOOL onlyRead;

@end

NS_ASSUME_NONNULL_END
