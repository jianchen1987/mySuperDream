//
//  CMSFourImageScrolledCardCell.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSFourImageScrolledCardCell.h"
#import "CMSFourImageScrolledCardCellConfig.h"
#import "CMSFourImageScrolledItemConfig.h"
#import "CMSFourImageScrolledCellItemView.h"


@interface CMSFourImageScrolledCardCell ()

/// 容器
@property (nonatomic, strong) UIView *containerView;

@end


@implementation CMSFourImageScrolledCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.containerView];
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.containerView.subviews sa_distributeSudokuViewsWithFixedLineSpacing:10 fixedInteritemSpacing:10 columnCount:2 heightToWidthScale:109 / 162.5 topSpacing:0 bottomSpacing:0 leadSpacing:0
                                                                  tailSpacing:0];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setConfig:(CMSFourImageScrolledCardCellConfig *)config {
    _config = config;

    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < 4; i++) {
        if (config.list.count > i) {
            CMSFourImageScrolledCellItemView *view = CMSFourImageScrolledCellItemView.new;
            CMSFourImageScrolledItemConfig *item = config.list[i];
            view.model = item;
            @HDWeakify(self);
            view.clickedBlock = ^(CMSFourImageScrolledItemConfig *_Nonnull model) {
                @HDStrongify(self);
                !self.clickedBlock ?: self.clickedBlock(model.node, model.link);
            };
            [self.containerView addSubview:view];
        } else {
            [self.containerView addSubview:UIView.new];
        }
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
@end
