//
//  TNAdaptPicModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNAdaptImageModel : TNModel
/// 图片地址
@property (strong, nonatomic) NSString *imgUrl;
/// 图片高度
@property (nonatomic, assign) CGFloat imageHeight;

/// 通过图片地址数组 转换为图片模型
/// @param list 图片地址数组
+ (NSArray<TNAdaptImageModel *> *)getAdaptImageModelsByImagesStrs:(NSArray<NSString *> *)list;
@end

NS_ASSUME_NONNULL_END
