//
//  CMSParentChildKingKongAreaCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSParentChildKingKongAreaCardView.h"
#import "CMSParentChildKingKongItemConfig.h"
#import "CMSToolsAreaCardNode.h"

/// cell 高
#define kKingKongAreaCellH (kRealWidth(164))
/// 左边大图高度
#define kKingKongAreaLeftBigViewH kRealWidth(144)
/// 左边大图宽度
#define kKingKongAreaLeftBigViewW kRealWidth(123)


@interface CMSParentChildKingKongAreaCardView ()

@property (nonatomic, strong) SDAnimatedImageView *leftBigView;
@property (nonatomic, strong) HDGridView *gridView;
@property (nonatomic, strong) NSArray<CMSToolsAreaItemConfig *> *dataSource;

@end


@implementation CMSParentChildKingKongAreaCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.leftBigView];
    [self.containerView addSubview:self.gridView];
}

- (void)updateConstraints {
    [self.leftBigView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self.containerView).offset(kRealWidth(8));
        make.width.mas_equalTo(kKingKongAreaLeftBigViewW);
        make.height.mas_equalTo(kKingKongAreaLeftBigViewH);
        make.bottom.equalTo(self.containerView).offset(-kRealWidth(8));
    }];
    [self.gridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBigView.mas_right).offset(kRealWidth(4));
        make.bottom.equalTo(self.containerView);
        make.top.equalTo(self.leftBigView);
        make.right.equalTo(self.containerView).offset(-HDAppTheme.value.padding.right);
    }];
    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    height += kRealWidth(16) + kKingKongAreaLeftBigViewH;
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

#pragma mark - private methods
- (void)openRouteWithModel:(CMSToolsAreaItemConfig *)model index:(NSUInteger)index {
    SACMSNode *node = self.config.nodes[index];
    NSString *url = model.link;
    !self.clickNode ?: self.clickNode(self, node, url, [NSString stringWithFormat:@"node@%zd", index]);
}

- (void)reloadData {
    [self.gridView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.leftBigView.image = nil;

    if (HDIsArrayEmpty(self.dataSource))
        return;

    [HDWebImageManager setGIFImageWithURL:self.dataSource.firstObject.imageUrl
                         placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kKingKongAreaLeftBigViewW, kKingKongAreaLeftBigViewH) logoWidth:kKingKongAreaLeftBigViewW * 0.5]
                                imageView:self.leftBigView];

    for (int i = 1; i < MIN(7, self.dataSource.count); i++) {
        CMSToolsAreaItemConfig *model = self.dataSource[i];
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

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSParentChildKingKongItemConfig.class json:self.config.getAllNodeContents];
    [self reloadData];
}

#pragma mark - event response
- (void)clickLeftBigImageHandler {
    [self openRouteWithModel:self.dataSource.firstObject index:0];
}

#pragma mark - lazy load
- (SDAnimatedImageView *)leftBigView {
    if (!_leftBigView) {
        _leftBigView = SDAnimatedImageView.new;
        _leftBigView.userInteractionEnabled = true;
        _leftBigView.contentMode = UIViewContentModeScaleAspectFit;
        [_leftBigView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftBigImageHandler)]];
    }
    return _leftBigView;
}

- (HDGridView *)gridView {
    if (!_gridView) {
        _gridView = [[HDGridView alloc] init];
        _gridView.columnCount = 3;
        _gridView.edgeInsets = UIEdgeInsetsZero;
        _gridView.subViewHMargin = kRealWidth(4);
    }
    return _gridView;
}

@end
