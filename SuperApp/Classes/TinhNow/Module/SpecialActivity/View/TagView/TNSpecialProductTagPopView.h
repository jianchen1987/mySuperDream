//
//  TNSpecialProductTagPopView.h
//  SuperApp
//
//  Created by 张杰 on 2022/11/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class TNGoodsTagModel;


@interface TNSpecialProductTagPopView : TNView
/// 选中分类回调
@property (nonatomic, copy) void (^tagClickCallBack)(TNGoodsTagModel *model);
/// 初始化筛选框
/// @param behindView 筛选框会在behindView下面弹出
/// @param tagArr  标签数组
/// @param width  弹窗宽度
- (instancetype)initWithView:(UIView *)behindView tagArr:(NSArray<TNGoodsTagModel *> *)tagArr width:(CGFloat)width;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
