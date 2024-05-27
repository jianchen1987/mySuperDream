//
//  SAInfoViewModel.h
//
//
//  Created by VanJay on 2020/3/31.
//

#import <Foundation/Foundation.h>
#import <HDUIKit/HDUIButton.h>

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef void (^HDInfoViewModelVoidBlock)(void);

/// 布局方式
typedef NS_ENUM(NSUInteger, SAInfoViewAlignType) {
    SAInfoViewAlignTypeHorizontal = 0, ///< 水平
    SAInfoViewAlignTypeVertical        ///< 垂直
};


@interface SAInfoViewModel : NSObject
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; ///< 内内边距

@property (nonatomic, strong) UIImage *leftImage;                   ///< 左边图片
@property (nonatomic, copy) NSString *leftImageURL;                 ///< 左边图片网络地址
@property (nonatomic, strong) UIImage *leftPlaceholderImage;        ///< 左边占位图片
@property (nonatomic, assign) CGSize leftImageSize;                 ///< 左图尺寸
@property (nonatomic, assign) UIEdgeInsets leftImageViewEdgeInsets; ///< 左图内边距，上下边距无效，默认垂直居中

@property (nonatomic, copy, nullable) NSString *keyText;                ///< 键文字
@property (nonatomic, copy, nullable) NSAttributedString *attrKey;      ///< 键文字属性内容（优先级高）
@property (nonatomic, strong) UIFont *keyFont;                          ///< 键文字字体
@property (nonatomic, strong) UIColor *keyColor;                        ///< 键文字颜色
@property (nonatomic, assign) NSTextAlignment keyTextAlignment;         ///< 键文字对齐方式
@property (nonatomic, assign) UIEdgeInsets keyContentEdgeInsets;        ///< 键内容内边距
@property (nonatomic, assign) UIEdgeInsets keyImageEdgeInsets;          ///< 键内容内边距
@property (nonatomic, assign) UIEdgeInsets keyTitletEdgeInsets;         ///< 键内容内边距
@property (nonatomic, assign) HDUIButtonImagePosition keyImagePosition; ///< key image 位置
@property (nonatomic, strong, nullable) UIImage *keyImage;              ///< 键图标
@property (nonatomic, assign) NSUInteger keyNumbersOfLines;             ///< 键文字行数
@property (nonatomic, assign) CGFloat keyWidth;                         ///< 键文字指定宽度

@property (nonatomic, copy) NSString *valueText;                          ///< 值文字
@property (nonatomic, copy, nullable) NSAttributedString *attrValue;      ///< 值文字属性内容（优先级高）
@property (nonatomic, strong) UIFont *valueFont;                          ///< 值文字字体
@property (nonatomic, strong) UIColor *valueColor;                        ///< 值文字颜色
@property (nonatomic, assign) NSTextAlignment valueTextAlignment;         ///< 值文字对齐方式
@property (nonatomic, assign) UIEdgeInsets valueContentEdgeInsets;        ///< 值内容内边距
@property (nonatomic, assign) UIEdgeInsets valueImageEdgeInsets;          ///< 值内容内边距
@property (nonatomic, assign) UIEdgeInsets valueTitleEdgeInsets;          ///< 值内容内边距
@property (nonatomic, assign) HDUIButtonImagePosition valueImagePosition; ///< value image 位置
@property (nonatomic, strong, nullable) UIImage *valueImage;              ///< 值图标
@property (nonatomic, copy) NSString *valueImageURL;                      ///< 值图片网络地址
@property (nonatomic, strong) UIImage *valueImagePlaceholderImage;        ///< 值图标占位图片
@property (nonatomic, assign) CGSize valueImageSize;                      ///< 值图标尺寸
@property (nonatomic, assign) NSUInteger valueNumbersOfLines;             ///< 值文字行数
@property (nonatomic, strong, nullable) UIColor *valueBackGroundColor;    ///< 值文字背景颜色
@property (nonatomic, assign) CGFloat valueCornerRadio;                   ///< 值文字圆角
///  是否需要重置值图片
@property (nonatomic, assign) BOOL resetValueImage;

@property (nonatomic, copy) NSString *rightButtonTitle;                         ///< 最右边标题文字
@property (nonatomic, strong) UIFont *rightButtonFont;                          ///< 最右边标题文字字体
@property (nonatomic, strong) UIColor *rightButtonColor;                        ///< 最右边标题文字颜色
@property (nonatomic, assign) NSTextAlignment rightButtonTextAlignment;         ///< 最右边标题文字对齐方式
@property (nonatomic, assign) UIEdgeInsets rightButtonContentEdgeInsets;        ///< 最右边标题内容内边距
@property (nonatomic, assign) UIEdgeInsets rightButtonImageEdgeInsets;          ///< 最右边标题内容内边距
@property (nonatomic, assign) UIEdgeInsets rightButtonTitletEdgeInsets;         ///< 最右边标题内容内边距
@property (nonatomic, assign) HDUIButtonImagePosition rightButtonImagePosition; ///< 最右边标题 image 位置
@property (nonatomic, strong, nullable) UIImage *rightButtonImage;              ///< 最右边标题图标
@property (nonatomic, assign) BOOL rightButtonaAlignKey;                        ///< 最右边标题与key对齐

@property (nonatomic, assign) CGFloat lineWidth;                     ///< 线条高度，默认 0，大于 0 则显示
@property (nonatomic, strong) UIColor *lineColor;                    ///< 线条颜色
@property (nonatomic, assign) UIEdgeInsets lineEdgeInsets;           ///< 线条内边距，上下边距无效
@property (nonatomic, strong) UIColor *backgroundColor;              ///< 背景色
@property (nonatomic, assign) CGFloat cornerRadius;                  ///< 圆角
@property (nonatomic, strong) id associatedObject;                   ///< 关联对象
@property (nonatomic, assign) BOOL needLeftImageRounded;             ///< 左边图片是否要圆角
@property (nonatomic, assign) BOOL needValueImageRounded;            ///< 值图片是否要圆角
@property (nonatomic, assign) BOOL enableTapRecognizer;              ///< 开启点击手势，默认不开启
@property (nonatomic, strong) UIImage *backgroundImage;              ///< 背景图
@property (nonatomic, assign) NSTextAlignment valueAlignmentToOther; ///< key 相对于其他控件的对齐方式，默认右对齐
@property (nonatomic, assign) SAInfoViewAlignType alignType;         ///< 布局方式
@property (nonatomic, assign) float keyToValueWidthRate;             ///< key 与 value 最大宽度比例（只对水平排版有效），默认 0.8
@property (nonatomic, copy) NSString *subValueText;                  ///< 子value值  布局在value下面  只有在SAInfoViewAlignTypeHorizontal水平布局有效
@property (nonatomic, strong) UIFont *subValueFont;                  ///< 子value文字字体
@property (nonatomic, strong) UIColor *subValueColor;                ///< 子value文字颜色
@property (nonatomic, assign) CGFloat subToValueButtonTopSpace;      ///< 子value距离value的间距
@property (nonatomic, assign) BOOL needFixedBottom;                  ///<是否需要固定底部间距 自适应  因为 subValueText设置会影响自适应高度不会更改
@property (nonatomic, assign) UIRectCorner rectCorner;               ///< 整个背景圆角位置 默认全圆角

@property (nonatomic, copy) HDInfoViewModelVoidBlock clickedLeftImageHandler;           ///< 点击左图事件
@property (nonatomic, copy, nullable) HDInfoViewModelVoidBlock clickedKeyButtonHandler; ///< 点击key事件
@property (nonatomic, copy) HDInfoViewModelVoidBlock clickedValueButtonHandler;         ///< 点击value事件
@property (nonatomic, copy) HDInfoViewModelVoidBlock clickedRightButtonHandler;         ///< 点击最右按钮事件
@property (nonatomic, copy, nullable) HDInfoViewModelVoidBlock eventHandler;            ///< 事件处理，优先级最高，需要设置 enableTapRecognizer 为 YES
@end

NS_ASSUME_NONNULL_END
