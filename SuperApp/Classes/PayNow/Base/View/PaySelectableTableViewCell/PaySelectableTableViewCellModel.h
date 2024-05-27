//
//  PaySelectableTableViewCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SASelectableTableViewCellModel.h"
#import <UIColor+HDKitCore.h>
NS_ASSUME_NONNULL_BEGIN


@interface PaySelectableTableViewCellModel : SASelectableTableViewCellModel
/// 选中文字颜色
@property (nonatomic, strong) UIColor *selectedTextColor;
/// 选中文字字体
@property (nonatomic, strong) UIFont *selectedTextFont;
/// 勾图片
@property (nonatomic, strong, nullable) UIImage *checkImage;
/// 选中勾图片
@property (nonatomic, strong, nullable) UIImage *selectedCheckImage;

@property (nonatomic, copy) NSString *value; //返回字段


@end

NS_ASSUME_NONNULL_END
