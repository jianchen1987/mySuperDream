//
//  TNActivityCardBannerItem.h
//  SuperApp
//
//  Created by 张杰 on 2021/1/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNActivityCardBannerItem : TNModel
/// 图片
@property (nonatomic, copy) NSString *bannerUrl;
/// 事件
@property (nonatomic, copy) NSString *jumpLink;
/// 名称
@property (nonatomic, copy) NSString *title;
/// 排序
@property (nonatomic, assign) NSUInteger sort;
/// 广告编号
@property (nonatomic, copy) NSString *bannerNo;

/// 绑定属性  卡片类型  （横幅/滑动/六宫格/走马灯/滑动方块/文字广告）
@property (nonatomic, copy) NSString *cardType;
/// 位置
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
