//
//  SANoDataCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SANoDataCellModel : WMModel
/// 图片
@property (nonatomic, strong) UIImage *image;
/// 描述
@property (nonatomic, copy) NSString *descText;
/// 底部按钮标题,设置就显示底部按钮，不设置不显示。默认为不显示
@property (nonatomic, copy) NSString *bottomBtnTitle;
/// 描述文字颜色
@property (nonatomic, strong) UIColor *descColor;
/// 描述文字字体
@property (nonatomic, strong) UIFont *descFont;
/// 底部按钮文字颜色
@property (nonatomic, strong) UIColor *bottomBtnTitleColor;
/// 底部按钮文字字体
@property (nonatomic, strong) UIFont *bottomBtnTitleFont;
/// 图片大小，不设置则为原图大小
@property (nonatomic, assign) CGSize imageSize;
/// 图片距顶距离
@property (nonatomic, assign) CGFloat marginImageToTop;
/// desc距图片距离
@property (nonatomic, assign) CGFloat marginDescToImage;
/// 按钮距desc距离
@property (nonatomic, assign) CGFloat marginBtnToDesc;
/// 按钮内壁阿奴
@property (nonatomic, assign) UIEdgeInsets btnEdgeInsets;
/// 按钮配置
@property (nonatomic, strong) NSDictionary *btnInfo;
/// cell 高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;
///底部点击
@property (nonatomic, copy) void (^BlockOnClockBottomBtn)(void);
@end

NS_ASSUME_NONNULL_END
