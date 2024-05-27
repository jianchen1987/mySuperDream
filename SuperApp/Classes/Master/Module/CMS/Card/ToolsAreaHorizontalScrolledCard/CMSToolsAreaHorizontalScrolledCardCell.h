//
//  CMSToolsAreaHorizontalScrolledCardCell.h
//  SuperApp
//
//  Created by seeu on 2022/4/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACollectionViewCell.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN
@class CMSToolsAreaHorizontalScrolledCardCellModel;


@interface CMSToolsAreaHorizontalScrolledCardCell : SACollectionViewCell

///< model
@property (nonatomic, strong) CMSToolsAreaHorizontalScrolledCardCellModel *model;

@end


@interface CMSToolsAreaHorizontalScrolledCardCellModel : SAModel
///< 图标
@property (nonatomic, copy) NSString *imageUrl;
///< 标题
@property (nonatomic, copy) NSString *title;
///< 标题颜色
@property (nonatomic, copy) NSString *titleColor;
///< 标题大小
@property (nonatomic, assign) NSUInteger titleFont;
///< 跳转链接
@property (nonatomic, copy) NSString *link;
///< 大小
@property (nonatomic, assign) CGSize cellSize;
@end

NS_ASSUME_NONNULL_END
