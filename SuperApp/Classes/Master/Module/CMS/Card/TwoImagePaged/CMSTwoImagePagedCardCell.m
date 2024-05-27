//
//  CMSTwoImageScrolledCardCell.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSTwoImagePagedCardCell.h"
#import "CMSTwoImagePagedCardCellConfig.h"
#import "CMSTwoImagePagedItemConfig.h"
#import "CMSTwoImagePagedCellItemView.h"


@interface CMSTwoImagePagedCardCell ()

/// view数组
@property (nonatomic, strong) NSMutableArray *viewArray;
/// 容器
@property (nonatomic, strong) UIView *containerView;

@end


@implementation CMSTwoImagePagedCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.containerView];
}

- (CMSTwoImagePagedCellItemView *)createIcon:(CMSTwoImagePagedItemConfig *)model {
    CMSTwoImagePagedCellItemView *view = [[CMSTwoImagePagedCellItemView alloc] init];
    view.model = model;
    @HDWeakify(self);
    view.clickedBlock = ^(CMSTwoImagePagedItemConfig *_Nonnull model) {
        @HDStrongify(self);
        !self.clickedBlock ?: self.clickedBlock(model.node, model.link);
    };
    [self.containerView addSubview:view];

    return view;
}

- (void)updateConstraints {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(self.config.cellEdge.top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-self.config.cellEdge.bottom);
    }];

    __block UIView *lastView = nil;
    [self.viewArray enumerateObjectsUsingBlock:^(CMSTwoImagePagedCellItemView *_Nonnull view, NSUInteger idx, BOOL *_Nonnull stop) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView);
            make.bottom.equalTo(self.containerView);
            if (!lastView) {
                make.left.equalTo(self.containerView.mas_left);
            } else {
                make.left.equalTo(lastView.mas_right).offset(kRealWidth(10));
                make.width.equalTo(lastView);
            }
            if (idx == self.viewArray.count - 1) {
                make.right.equalTo(self.contentView);
            }
        }];
        lastView = view;
    }];

    [super updateConstraints];
}

- (void)setConfig:(CMSTwoImagePagedCardCellConfig *)config {
    _config = config;

    @HDWeakify(self);
    [self.viewArray enumerateObjectsUsingBlock:^(CMSTwoImagePagedCellItemView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        @HDStrongify(self);
        if (self.config.list.count > idx) {
            obj.hidden = NO;
            obj.model = self.config.list[idx];
        } else {
            obj.hidden = YES;
        }
    }];

    [self setNeedsUpdateConstraints];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            [tempArr addObject:[self createIcon:nil]];
        }
        _viewArray = tempArr.copy;
    }
    return _viewArray;
}
@end
