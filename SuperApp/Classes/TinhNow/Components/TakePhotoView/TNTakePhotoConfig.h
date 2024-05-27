//
//  TNTakePhotoConfig.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNTakePhotoConfig : NSObject
/// 最大图片数量
@property (nonatomic, assign) NSInteger maxPhotoNum;
/// 一行多少张图片
@property (nonatomic, assign) NSInteger lineCount;
/// 行间距  默认5
@property (nonatomic, assign) NSInteger lineSpace;

/// 描述文本
@property (nonatomic, copy) NSString *desText;
/// 描述富文本  优先级高于 desText
@property (nonatomic, copy) NSAttributedString *desAttr;
/// 描述文本字体
@property (strong, nonatomic) UIFont *desFont;
/// 描述文本颜色
@property (strong, nonatomic) UIColor *desColor;

/// 描述文本与图片选择器的间距
@property (nonatomic, assign) NSInteger titleAndImagesSpace;
/// 主题颜色
@property (strong, nonatomic) UIColor *themeColor;
/// 内边距
@property (assign, nonatomic) UIEdgeInsets contentInset;
@end

NS_ASSUME_NONNULL_END
