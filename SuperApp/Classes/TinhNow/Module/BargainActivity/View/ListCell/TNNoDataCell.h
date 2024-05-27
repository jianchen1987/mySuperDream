//
//  TNNoDataCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNNoDataCellModel : NSObject
/// 显示文案
@property (nonatomic, copy) NSString *noDataText;
/// 字体
@property (strong, nonatomic) UIFont *font;
/// 颜色
@property (strong, nonatomic) UIColor *textColor;
/// 图片
@property (nonatomic, copy) NSString *imageName;
@end


@interface TNNoDataCell : SATableViewCell
/// 数据源
@property (strong, nonatomic) TNNoDataCellModel *model;
@end

NS_ASSUME_NONNULL_END
