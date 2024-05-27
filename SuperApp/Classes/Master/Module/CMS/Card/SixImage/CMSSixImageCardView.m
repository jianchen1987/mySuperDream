//
//  CMSSixImageCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSSixImageCardView.h"
#import "CMSSixImageCardItemView.h"
#import "CMSSixImageItemConfig.h"


@interface CMSSixImageCardView ()

@property (nonatomic, strong) UIView *sixBgView;
@property (nonatomic, strong) NSArray<CMSSixImageItemConfig *> *dataSource;

@end


@implementation CMSSixImageCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.containerView addSubview:self.sixBgView];
}

- (void)updateConstraints {
    [self.sixBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.containerView).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.containerView).offset(kRealWidth(10));
        make.bottom.equalTo(self.containerView).offset(-kRealWidth(10));
    }];
    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    CGFloat availableWidth = self.config.maxLayoutWidth - UIEdgeInsetsGetHorizontalValue(self.config.getContentEdgeInsets) - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
    CGFloat cellWidth = (availableWidth - kRealWidth(10) * 2) / 3.0;

    height += kRealWidth(20); // top + bottom
    if (self.dataSource.count > 3) {
        NSArray *firstLineArr = [self.dataSource subarrayWithRange:NSMakeRange(0, 3)];
        BOOL hasText = [self checkBannerListHasText:firstLineArr];
        if (hasText) {
            height += kRealWidth(30); // text
        }
        NSArray *lastArr = [self.dataSource subarrayWithRange:NSMakeRange(3, self.dataSource.count - 3)];
        BOOL secondHasText = [self checkBannerListHasText:lastArr];
        if (secondHasText) {
            height += kRealWidth(30); // text
        }
        height += cellWidth * 2 + kRealWidth(15); // cell + margin
    } else {
        BOOL hasText = [self checkBannerListHasText:self.dataSource];
        if (hasText) {
            height += kRealWidth(30); // text
        }
        height += cellWidth; // cell
    }
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

- (void)configSubView {
    [self.sixBgView hd_removeAllSubviews];
    CGFloat HMargin = kRealWidth(10);
    CGFloat VMargin = kRealWidth(15);
    CGFloat width = (kScreenWidth - UIEdgeInsetsGetHorizontalValue(self.config.getContentEdgeInsets) - kRealWidth(30) - HMargin * 2) / 3;
    CGFloat firstLineViewHeight = width;
    CGFloat secondLineViewHeight = width;
    if (self.dataSource.count > 3) {
        NSArray *firstLineArr = [self.dataSource subarrayWithRange:NSMakeRange(0, 3)];
        BOOL hasText = [self checkBannerListHasText:firstLineArr];
        if (hasText) {
            firstLineViewHeight += kRealWidth(30);
        }
        NSArray *lastArr = [self.dataSource subarrayWithRange:NSMakeRange(3, self.dataSource.count - 3)];
        BOOL secondHasText = [self checkBannerListHasText:lastArr];
        if (secondHasText) {
            secondLineViewHeight += kRealWidth(30);
        }
    } else {
        BOOL hasText = [self checkBannerListHasText:self.dataSource];
        if (hasText) {
            firstLineViewHeight += kRealWidth(30);
        }
    }
    if (!HDIsArrayEmpty(self.dataSource)) {
        for (int i = 0; i < self.dataSource.count; i++) {
            CMSSixImageCardItemView *itemView = [[CMSSixImageCardItemView alloc] init];
            itemView.tag = i;
            [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)]];
            itemView.model = self.dataSource[i];
            CGFloat height = firstLineViewHeight;
            if (i >= 3) {
                height = secondLineViewHeight;
            }
            NSInteger row = i / 3;
            NSInteger col = i % 3;
            CGFloat x = (width + HMargin) * col;
            CGFloat y = (firstLineViewHeight + VMargin) * row;
            [self.sixBgView addSubview:itemView];

            [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.sixBgView).offset(x);
                make.top.equalTo(self.sixBgView).offset(y);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
                if (i == self.dataSource.count - 1) {
                    make.bottom.equalTo(self.sixBgView);
                }
            }];
        }
    }
    [self setNeedsUpdateConstraints];
}

- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSSixImageItemConfig.class json:self.config.getAllNodeContents];
    [self configSubView];
}

- (void)clickItem:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    SACMSNode *node = self.config.nodes[index];
    CMSSixImageItemConfig *itemConfig = self.dataSource[index];
    !self.clickNode ?: self.clickNode(self, node, itemConfig.link, [NSString stringWithFormat:@"node@%zd", index]);
}

///验证卡片数据源是否配置有文本
- (BOOL)checkBannerListHasText:(NSArray *)list {
    BOOL hasText = NO;
    if (!HDIsArrayEmpty(list)) {
        for (CMSSixImageItemConfig *item in list) {
            if (HDIsStringNotEmpty(item.title)) {
                hasText = YES;
                break;
            }
        }
    }
    return hasText;
}

#pragma mark - lazy load
- (UIView *)sixBgView {
    if (!_sixBgView) {
        _sixBgView = UIView.new;
        _sixBgView.backgroundColor = UIColor.clearColor;
    }
    return _sixBgView;
}

@end
