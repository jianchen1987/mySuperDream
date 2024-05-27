//
//  CMSToolsAreaCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSToolsAreaCardView.h"
#import "CMSToolsAreaCardNode.h"
#import "CMSToolsAreaItemConfig.h"

#define kHomeToolCellHeight kRealHeight(80)
#define KHomeToolCellMarginTop kRealWidth(15)
#define kHomeToolCellLineMargin kRealHeight(5)


@interface CMSToolsAreaCardView ()

@property (nonatomic, strong) HDGridView *gridView;
@property (nonatomic, strong) NSArray<CMSToolsAreaItemConfig *> *dataSource;

@end


@implementation CMSToolsAreaCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.gridView];
}

- (void)updateConstraints {
    [self.gridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView).offset(KHomeToolCellMarginTop);
        make.height.mas_equalTo(kHomeToolCellHeight * ceilf(self.dataSource.count / 4.0) + kHomeToolCellLineMargin);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-5);
    }];
    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;

    height += (kHomeToolCellHeight * ceilf(self.dataSource.count / 4.0) + kHomeToolCellLineMargin);
    height += KHomeToolCellMarginTop + 5;
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSToolsAreaItemConfig.class json:self.config.getAllNodeContents];
    [self reloadData];
}

#pragma mark - private methods
- (void)reloadData {
    [self.gridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (HDIsArrayEmpty(self.dataSource))
        return;
    self.gridView.columnCount = MIN(self.dataSource.count, 4);
    for (CMSToolsAreaItemConfig *model in self.dataSource) {
        CMSToolsAreaCardNode *view = CMSToolsAreaCardNode.new;
        view.model = model;
        @HDWeakify(self);
        view.clickHandler = ^(CMSToolsAreaItemConfig *_Nonnull model) {
            @HDStrongify(self);
            [self openRouteWithModel:model index:[self.dataSource indexOfObject:model]];
        };
        [self.gridView addSubview:view];
    }

    [self setNeedsUpdateConstraints];
}

- (void)openRouteWithModel:(CMSToolsAreaItemConfig *)model index:(NSUInteger)index {
    SACMSNode *node = self.config.nodes[index];
    NSString *url = model.link;
    !self.clickNode ?: self.clickNode(self, node, url, [NSString stringWithFormat:@"node@%zd", index]);
}

#pragma mark - lazy load
- (HDGridView *)gridView {
    if (!_gridView) {
        _gridView = HDGridView.new;
        _gridView.rowHeight = kHomeToolCellHeight;
        _gridView.edgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        _gridView.subViewVMargin = kHomeToolCellLineMargin;
    }
    return _gridView;
}
@end
