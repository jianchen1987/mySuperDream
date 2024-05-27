//
//  TNHomeViewScrollLabelCell.m
//  SuperApp
//
//  Created by Chaos on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNHomeViewScrollLabelCell.h"
#import "SAInfoView.h"
#import "SAInternationalizationModel.h"
#import "TNHomeViewScrollItemView.h"
#import "TNScrollContentModel.h"
#import "TNScrollContentRspModel.h"
#import <HDUIKit/HDMarqueeLabel.h>
#import <YYText.h>


@interface TNHomeViewScrollLabelCell ()

/// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 按钮数组
@property (nonatomic, copy) NSArray *buttonArray;
/// allTextWidth
@property (nonatomic, assign) CGFloat textWidth;

@end


@implementation TNHomeViewScrollLabelCell

- (void)hd_setupViews {
    self.textWidth = 0;
    self.scrollView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:247 / 255.0 blue:232 / 255.0 alpha:1.0];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.bgView];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.contentView);
        make.height.mas_equalTo(self.model.cellHeight);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];

    //    CGFloat subViewsWidth = 0;
    //    for (UIView *view in self.bgView.subviews) {
    //        [view setNeedsLayout];
    //        [view layoutIfNeeded];
    //        subViewsWidth += kRealWidth(15) + CGRectGetWidth(view.frame);
    //    }
    CGFloat leftPadding = 0;
    if (self.textWidth < kScreenWidth) {
        leftPadding = (kScreenWidth - self.textWidth) / 2.0;
    } else {
        leftPadding = HDAppTheme.value.padding.left;
    }

    UIView *lastView;
    for (UIView *view in self.bgView.subviews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(kRealWidth(15));
            } else {
                make.left.equalTo(self.bgView.mas_left).offset(leftPadding);
            }
            make.top.bottom.equalTo(self.bgView);
            make.height.equalTo(self.bgView.mas_height);

            if ([view isEqual:self.bgView.subviews.lastObject]) {
                make.right.equalTo(self.bgView.mas_right);
            }
        }];
        lastView = view;
    }

    //    if (CGRectGetWidth(self.bgView.frame) < kScreenWidth) {
    //        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //            make.top.equalTo(self.scrollView);
    //            make.height.equalTo(self.scrollView);
    //            make.centerX.equalTo(self.contentView.mas_centerX);
    //        }];
    //    }

    [super updateConstraints];
}
// 重写优先约束属性
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}
#pragma mark - private methods
- (void)configShowItem {
    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    @HDWeakify(self);
    [self.model.list enumerateObjectsUsingBlock:^(TNScrollContentModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        @HDStrongify(self);
        [self createInfoViewWithModel:obj];
    }];

    [self setNeedsUpdateConstraints];
}

- (void)createInfoViewWithModel:(TNScrollContentModel *)model {
    TNHomeViewScrollItemView *view = [[TNHomeViewScrollItemView alloc] initWithFrame:CGRectMake(0, 0, kRealWidth(100), 20)];
    view.model = model;

    [self.bgView addSubview:view];
}

#pragma mark - setter
- (void)setModel:(TNScrollContentRspModel *)model {
    _model = model;

    // 计算宽度，不足一屏的时候居中
    for (TNScrollContentModel *textModel in model.list) {
        CGRect textRect = [textModel.text.desc boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName: HDAppTheme.font.standard3}
                                                            context:nil];
        self.textWidth += kRealWidth(15) + kRealWidth(19) + CGRectGetWidth(textRect);
    }
    [self configShowItem];
}

#pragma mark - lazy load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:247 / 255.0 blue:232 / 255.0 alpha:1.0];
        _scrollView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _scrollView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:247 / 255.0 blue:232 / 255.0 alpha:1.0];
    }
    return _bgView;
}

@end
