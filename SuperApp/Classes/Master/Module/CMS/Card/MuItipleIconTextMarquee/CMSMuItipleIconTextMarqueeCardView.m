//
//  CMSTextScrolledCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSMuItipleIconTextMarqueeCardView.h"
#import "CMSMuItipleIconTextMarqueeCardItemView.h"
#import "CMSMuItipleIconTextMarqueeItemConfig.h"


@interface CMSMuItipleIconTextMarqueeCardView ()

/// 按钮数组
@property (nonatomic, copy) NSArray *buttonArray;
/// allTextWidth
@property (nonatomic, assign) CGFloat textWidth;

@property (nonatomic, strong) NSArray<CMSMuItipleIconTextMarqueeItemConfig *> *dataSource;

@end


@implementation CMSMuItipleIconTextMarqueeCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    self.textWidth = 0;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.alwaysBounceVertical = false;
    [self.containerView addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.height.width.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(40));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];

    CGFloat leftPadding = 0;
    if (self.textWidth < kScreenWidth) {
        leftPadding = (kScreenWidth - self.textWidth) / 2.0;
    } else {
        leftPadding = HDAppTheme.value.padding.left;
    }

    UIView *lastView;
    for (UIView *view in self.scrollViewContainer.subviews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(kRealWidth(15));
            } else {
                make.left.equalTo(self.scrollViewContainer.mas_left).offset(leftPadding);
            }
            make.top.bottom.equalTo(self.scrollViewContainer);
            make.height.equalTo(self.scrollViewContainer.mas_height);

            if ([view isEqual:self.scrollViewContainer.subviews.lastObject]) {
                make.right.equalTo(self.scrollViewContainer.mas_right);
            }
        }];
        lastView = view;
    }

    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    height += kRealWidth(40);
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);
    return height;
}

// 重写优先约束属性
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.containerView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
#pragma mark - private methods
- (void)configShowItem {
    [self.scrollViewContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    @HDWeakify(self);
    [self.dataSource enumerateObjectsUsingBlock:^(CMSMuItipleIconTextMarqueeItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        @HDStrongify(self);
        [self createInfoViewWithModel:obj];
    }];

    [self setNeedsUpdateConstraints];
}

- (void)createInfoViewWithModel:(CMSMuItipleIconTextMarqueeItemConfig *)model {
    CMSMuItipleIconTextMarqueeCardItemView *view = [[CMSMuItipleIconTextMarqueeCardItemView alloc] init];
    view.model = model;
    @HDWeakify(self);
    view.clickView = ^(CMSMuItipleIconTextMarqueeItemConfig *_Nonnull config, NSString *_Nullable link) {
        @HDStrongify(self);
        NSUInteger idx = [self.dataSource indexOfObject:config];
        self.clickNode(self, self.config.nodes[idx], link, [NSString stringWithFormat:@"node@%zd", idx]);
    };
    [self.scrollViewContainer addSubview:view];
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSMuItipleIconTextMarqueeItemConfig.class json:config.getAllNodeContents];
    // 计算宽度，不足一屏的时候居中
    for (CMSMuItipleIconTextMarqueeItemConfig *textModel in self.dataSource) {
        CGRect textRect = [textModel.title boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:textModel.titleFont]}
                                                        context:nil];
        self.textWidth += kRealWidth(15) + kRealWidth(19) + CGRectGetWidth(textRect);
    }
    [self configShowItem];
}

@end
