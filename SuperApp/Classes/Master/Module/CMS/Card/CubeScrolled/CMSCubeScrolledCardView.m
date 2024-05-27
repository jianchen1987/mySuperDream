//
//  CMSSquareImageScrolledCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSCubeScrolledCardView.h"
#import "CMSCubeScrolledCardItemView.h"
#import "CMSCubeScrolledItemConfig.h"


@interface CMSCubeScrolledCardView ()

@property (nonatomic, strong) NSArray<CMSCubeScrolledItemConfig *> *dataSource;

@end


@implementation CMSCubeScrolledCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.alwaysBounceVertical = false;
    [self.containerView addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(kRealWidth(10));
        make.bottom.equalTo(self.containerView).offset(-kRealWidth(10));
        make.left.equalTo(self.containerView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.containerView).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(kRealWidth(70));
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;

    height += kRealWidth(20) + kRealWidth(70);
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

- (void)configSubView {
    [self.scrollViewContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (HDIsArrayEmpty(self.dataSource)) {
        return;
    }
    UIView *lastView = nil;
    for (int i = 0; i < self.dataSource.count; i++) {
        CMSCubeScrolledCardItemView *itemView = [[CMSCubeScrolledCardItemView alloc] init];
        itemView.tag = i;
        [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)]];
        itemView.model = self.dataSource[i];
        [self.scrollViewContainer addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView == nil) {
                make.left.equalTo(self.scrollViewContainer);
            } else {
                make.left.equalTo(lastView.mas_right).offset(kRealWidth(7));
            }
            make.top.bottom.equalTo(self.scrollViewContainer);
            if (i == self.dataSource.count - 1) {
                make.right.equalTo(self.scrollViewContainer);
            }
            make.width.mas_equalTo(kRealWidth(70));
        }];
        lastView = itemView;
    }
    [self setNeedsUpdateConstraints];
}

- (void)clickItem:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    SACMSNode *node = self.config.nodes[index];
    CMSCubeScrolledItemConfig *itemConfig = self.dataSource[index];
    !self.clickNode ?: self.clickNode(self, node, itemConfig.link, [NSString stringWithFormat:@"node@%zd", index]);
}

- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSCubeScrolledItemConfig.class json:self.config.getAllNodeContents];
    [self configSubView];
}

@end
