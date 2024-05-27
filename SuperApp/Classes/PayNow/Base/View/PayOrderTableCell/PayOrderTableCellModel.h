//
//  PayOrderTableCellModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAModel.h"
#import <UIColor+HDKitCore.h>
NS_ASSUME_NONNULL_BEGIN


@interface PayOrderTableCellModel : SAModel
/// 图片
@property (nonatomic, strong, nullable) UIImage *image;
/// 图片大小
@property (nonatomic, assign) CGSize imageSize;
/// 文字
@property (nonatomic, copy) NSString *name;
/// 文字颜色
@property (nonatomic, strong) UIColor *nameTextColor;
/// 文字字体
@property (nonatomic, strong) UIFont *nameTextFont;

@property (nonatomic, copy) NSString *value;
/// 文字颜色
@property (nonatomic, strong) UIColor *valueTextColor;
/// 文字字体
@property (nonatomic, strong) UIFont *valueTextFont;
@end

NS_ASSUME_NONNULL_END
