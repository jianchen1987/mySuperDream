//
//  TNCMSCollectionViewCell.m
//  SuperApp
//
//  Created by Chaos on 2021/7/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACMSCollectionViewCell.h"
#import "CMSPlayerCardView.h"
#import "SACMSNode.h"


@implementation SACMSCollectionViewCellModel
@end


@interface SACMSCollectionViewCell ()

@property (nonatomic, strong) SACMSCardView *cardView;

@end


@implementation SACMSCollectionViewCell

- (void)updateConstraints {
    if (self.cardView) {
        [self.cardView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.mas_equalTo([self.cardView heightOfCardView]);
        }];
    }
    [super updateConstraints];
}

- (void)setModel:(SACMSCollectionViewCellModel *)model {
    _model = model;

    self.cardView = model.cardView;
    [self.contentView hd_removeAllSubviews];
    [self.contentView addSubview:self.cardView];
    [self setNeedsUpdateConstraints];
}

- (void)startPlayer {
    if (![self.cardView isKindOfClass:CMSPlayerCardView.class])
        return;
    [(CMSPlayerCardView *)self.cardView startPlayer];
}

- (void)stopPlayer {
    if (![self.cardView isKindOfClass:CMSPlayerCardView.class])
        return;
    [(CMSPlayerCardView *)self.cardView stopPlayer];
}

@end


@implementation SACMSSkeletonCollectionViewCell

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    NSMutableArray *arr = [NSMutableArray array];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(self.model.cellHeight - 30);
        make.height.hd_equalTo(self.model.cellHeight - 30);
        make.left.hd_equalTo(15);
        make.top.hd_equalTo(15);
    }];
    r1.skeletonCornerRadius = 10;
    [arr addObject:r1];

    CGFloat width = CGRectGetWidth(self.frame);
    HDSkeletonLayer *label = [[HDSkeletonLayer alloc] init];
    [label hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(width - self.model.cellHeight - 30);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(r1.hd_top + 5);
        make.left.hd_equalTo(r1.hd_right + 15);
    }];
    [arr addObject:label];

    label = [[HDSkeletonLayer alloc] init];
    [label hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(width / 3.0);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(r1.hd_top + 30);
        make.left.hd_equalTo(r1.hd_right + 15);
    }];
    [arr addObject:label];

    return arr;
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.clearColor;
}

@end


@implementation SACMSSkeletonCollectionViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellHeight = 150;
    }
    return self;
}
@end


@implementation SACMSPlaceholderCollectionViewCell

@end


@implementation SACMSPlaceholderCollectionViewCellModel

@end


@interface SACMSCustomCollectionCell ()
///< 自定义视图
@property (nonatomic, strong) UIView *customView;

@end


@implementation SACMSCustomCollectionCell
- (void)updateConstraints {
    if (self.customView) {
        [self.customView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.mas_equalTo(self.model.height);
        }];
    }
    [super updateConstraints];
}

- (void)setModel:(SACMSCustomCollectionCellModel *)model {
    _model = model;

    //        if (![self.customView isEqual:model.view]) {
    self.customView = model.view;
    [self.contentView hd_removeAllSubviews];
    [self.contentView addSubview:self.customView];
    //        }
    //    [self.customView setNeedsLayout];
    [self setNeedsUpdateConstraints];
}

@end


@implementation SACMSCustomCollectionCellModel

@end
