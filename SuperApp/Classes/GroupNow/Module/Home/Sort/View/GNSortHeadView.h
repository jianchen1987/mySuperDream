//
//  GNSortHeadView.h
//  SuperApp
//
//  Created by wmz on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNClassificationModel.h"
#import "GNCollectionView.h"
#import "GNView.h"
#import "SACollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GNSortHeadViewDelegate <NSObject>
///点击
- (void)clickItem:(GNClassificationModel *)model;
@end


@interface GNSortHeadView : GNView
///代理
@property (nonatomic, weak) id delegate;
///数据源
@property (nonatomic, copy) NSArray<GNClassificationModel *> *dataSource;
/// collectionView
@property (nonatomic, strong) GNCollectionView *collectionView;
/// lineView
@property (nonatomic, strong) UIView *bottomLine;
/// topOffset
@property (nonatomic, assign) CGFloat topOffset;
/// maxOffset
@property (nonatomic, assign) CGFloat maxOffset;
/// dataSource 数据源
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray<GNClassificationModel *> *)dataSource;
@end


@interface GNClassCodeItemCell : SACollectionViewCell
/// image
@property (nonatomic, strong) UIImageView *imageIV;

@end
NS_ASSUME_NONNULL_END
