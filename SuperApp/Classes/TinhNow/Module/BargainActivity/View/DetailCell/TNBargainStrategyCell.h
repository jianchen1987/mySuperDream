//
//  TNBargainStrategyCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "TNBargainRuleModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainStrategyCell : SATableViewCell
/// 图片数组
@property (strong, nonatomic) NSArray<TNAdaptImageModel *> *rulePics;
/// 获取图片高度后的回调  目前是需要根据图片的真实高度展示
@property (nonatomic, copy) void (^getRealImageSizeCallBack)(NSInteger index, CGFloat imageHeight);
@end

NS_ASSUME_NONNULL_END
