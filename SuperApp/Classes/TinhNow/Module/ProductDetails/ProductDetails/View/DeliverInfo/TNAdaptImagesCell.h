//
//  TNAdaptImagesCell.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNAdaptImageModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNAdaptImagesCell : SATableViewCell
/// 图片数据源
@property (strong, nonatomic) NSArray<TNAdaptImageModel *> *images;
/// 获取图片高度后的回调  目前是需要根据图片的真实高度展示
@property (nonatomic, copy) void (^getRealImageSizeCallBack)(void);
@end

NS_ASSUME_NONNULL_END
