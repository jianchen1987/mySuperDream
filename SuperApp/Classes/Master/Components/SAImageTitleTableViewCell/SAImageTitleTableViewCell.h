//
//  SAImageTitleTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAImageTitleTableViewCellModel : NSObject
/// 图片
@property (nonatomic, strong) UIImage *image;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 标记
@property (nonatomic, assign) NSUInteger tag;
@end


@interface SAImageTitleTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) SAImageTitleTableViewCellModel *model;
@end

NS_ASSUME_NONNULL_END
