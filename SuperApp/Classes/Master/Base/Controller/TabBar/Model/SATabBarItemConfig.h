//
//  SATabBarItemConfig.h
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SATabBarImageModel : SACodingModel
/// 图片链接
@property (nonatomic, copy) NSString *url;
/// 图片类型
@property (nonatomic, copy) NSString *type;

@end


@interface SATabBarItemConfig : SACodingModel
@property (nonatomic, strong) SAInternationalizationModel *name;      ///< 功能名称
@property (nonatomic, strong) SAInternationalizationModel *guideDesc; ///< 功能引导
@property (nonatomic, copy) NSString *imageUrl;                       ///< 默认状态图片地址
@property (nonatomic, copy) NSString *selectedImageUrl;               ///< 选中状态图片地址
@property (nonatomic, strong) SAInternationalizationModel *localName; ///< 本地功能名称
@property (nonatomic, copy) NSString *localImage;                     ///< 本地图片
@property (nonatomic, copy) NSString *selectedLocalImage;             ///< 选中状态的本地图片
@property (nonatomic, assign) BOOL hideTextWhenSelected;              ///< 选中时是否隐藏文字
@property (nonatomic, copy) NSString *identifier;                     ///< 唯一标识
@property (nonatomic, assign) NSInteger index;                        ///< 排序序号
@property (nonatomic, assign) NSInteger funcGuideVersion;             ///< 功能引导版本号
@property (nonatomic, assign) BOOL hasUpdated;                        ///< 是否更新了
@property (nonatomic, assign) BOOL hasDisplayedNewFunctionGuide;      ///< 是否已经显示过新功能
@property (nonatomic, strong) UIColor *titleColor;                    ///< 默认状态颜色
@property (nonatomic, strong) UIColor *selectedTitleColor;            ///< 选中状态颜色
@property (nonatomic, strong) UIFont *titleFont;                      ///< 字体
@property (nonatomic, copy) NSString *loadPageName;                   ///< 加载页面
@property (nonatomic, strong) NSDictionary *startupParams;            ///< 启动参数
@property (nonatomic, copy) NSString *badgeValue;                     ///< 角标文本
@property (nonatomic, strong) UIFont *badgeFont;                      ///< 角标文本font
@property (nonatomic, strong) NSString *jsonName;                     ///< JSON动画文件

@property (nonatomic, strong) SATabBarImageModel *imageNormal;   ///< 正常图片模型
@property (nonatomic, strong) SATabBarImageModel *imageSelected; ///< 选中图片模型

- (void)setLocalName:(SAInternationalizationModel *)localName localImage:(NSString *)localImage selectedLocalImage:(NSString *)selectedLocalImage;

- (void)setTitleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selectedTitleColor;

@end

NS_ASSUME_NONNULL_END
