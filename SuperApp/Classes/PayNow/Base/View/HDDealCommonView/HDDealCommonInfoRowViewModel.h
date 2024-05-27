//
//  HDDealCommonInfoRowViewModel.h
//  customer
//
//  Created by VanJay on 2019/5/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDDealCommonInfoRowViewModel : NSObject

@property (nonatomic, copy) NSString *key;                        ///< 左边文字
@property (nonatomic, strong) UIFont *keyFont;                    ///< 左边文字字体
@property (nonatomic, strong) UIColor *keyColor;                  ///< 左边文字颜色
@property (nonatomic, assign) NSTextAlignment keyTextAlignment;   ///< 左边文字对齐方式
@property (nonatomic, copy) NSString *value;                      ///< 右边文字
@property (nonatomic, strong) UIFont *valueFont;                  ///< 右边文字字体
@property (nonatomic, strong) UIColor *valueColor;                ///< 右边文字颜色
@property (nonatomic, assign) NSTextAlignment valueTextAlignment; ///< 右边文字对齐方式
@property (nonatomic, assign) CGFloat minimumMargin;              ///< 左右最小间距
@property (nonatomic, assign) UIEdgeInsets contentInsets;         ///< 内边距
@property (nonatomic, assign) BOOL needRightArrow;                ///< 是否需要右边箭头，默认不需要

+ (instancetype)modelWithKey:(NSString *)key value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
