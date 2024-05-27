//
//  TNActivityCardItemView.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNActivityCardModel.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNActivityCardItemView : TNView
/// 图片高度
@property (nonatomic, assign) CGFloat imageViewHeight;
/// 图片宽度度
@property (nonatomic, assign) CGFloat imageViewWidth;
/// 数据源
@property (strong, nonatomic) TNActivityCardBannerItem *item;
/// 显示场景  首页和专题样式不同
@property (nonatomic, assign) TNActivityCardScene scene;
@end

NS_ASSUME_NONNULL_END
