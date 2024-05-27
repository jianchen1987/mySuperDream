//
//  TNMenuNavView.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNMenuNavView : TNView
/// 左边图片
@property (nonatomic, copy) NSString *leftImage;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 右边View（与右边图片冲突，设置右边view，右边图片不生效）
@property (nonatomic, strong) UIView *rightView;
/// 右边图片
@property (nonatomic, copy) NSString *rightImage;
/// 左边按钮边距 （默认为 0）
@property (nonatomic, assign) CGFloat leftImageInset;
/// 右边按钮边距（默认为 0）
@property (nonatomic, assign) CGFloat rightImageInset;
/// 背景颜色（默认是白色）
@property (nonatomic, strong) UIColor *bgColor;
/// 背景透明度
@property (nonatomic, assign) CGFloat bgAlpha;
/// 是否隐藏显示右边按钮
@property (nonatomic, assign) BOOL hiddenRightImageBtn;
/// 左边按钮事件
@property (nonatomic, copy) void (^clickedLeftViewBlock)(void);
/// 右边按钮事件
@property (nonatomic, copy) void (^clickedRightViewBlock)(void);
/// 设置参数后更新view
- (void)updateConstraintsAfterSetInfo;

@end

NS_ASSUME_NONNULL_END
