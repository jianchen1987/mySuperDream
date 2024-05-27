//
//  WMReviewFilterView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMReviewFilterView.h"


@interface WMReviewFilterButton : HDUIGhostButton
@end


@implementation WMReviewFilterButton
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (selected) {
        [self setTitleColor:HDAppTheme.color.mainColor forState:UIControlStateNormal];
        self.hd_borderColor = HDAppTheme.color.mainColor;
        self.hd_borderWidth = 1;
        self.hd_borderLocation = HDViewBorderLocationInside;
        self.hd_borderPosition = HDViewBorderPositionTop | HDViewBorderPositionBottom | HDViewBorderPositionLeft | HDViewBorderPositionRight;
        self.backgroundColor = [HDAppTheme.color.mainColor colorWithAlphaComponent:0.1];
    } else {
        [self setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        self.hd_borderWidth = 0;
        self.backgroundColor = HDAppTheme.color.G5;
    }
}
@end


@interface WMReviewFilterView ()
/// 容器
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 是否有内容按钮
@property (nonatomic, strong) HDUIButton *hasContentButton;
/// 底部分割线
@property (nonatomic, strong) UIView *sepLine;
/// 当前 config
@property (nonatomic, strong) WMReviewFilterButtonConfig *config;
/// 当前选中按钮
@property (nonatomic, strong) WMReviewFilterButton *selectedButton;
@end


@implementation WMReviewFilterView

#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    self.shouldLayoutSizeFittingSize = true;
    self.showBottomSepLine = false;

    [self addSubview:self.floatLayoutView];
    [self addSubview:self.hasContentButton];
    [self addSubview:self.sepLine];
}

#pragma mark - event response
- (void)clickedHasContentButtonHandler:(HDUIButton *)button {
    button.selected = !button.isSelected;

    !self.clickedHasContentButtonBlock ?: self.clickedHasContentButtonBlock(button.isSelected);
}

- (void)clickedButtonHandler:(WMReviewFilterButton *)button {
    if (button.isSelected)
        return;

    button.selected = true;
    self.selectedButton.selected = false;
    self.selectedButton = button;

    WMReviewFilterButtonConfig *config = button.hd_associatedObject;
    self.config = config;

    !self.clickedFilterButtonBlock ?: self.clickedFilterButtonBlock(button, config);
}

#pragma mark - public methods
- (void)reloadData {
    for (WMReviewFilterButton *button in self.floatLayoutView.subviews) {
        if ([button isKindOfClass:WMReviewFilterButton.class]) {
            NSUInteger index = [self.floatLayoutView.subviews indexOfObject:button];
            if (self.dataSource.count > index) {
                WMReviewFilterButtonConfig *config = self.dataSource[index];
                [button setTitle:config.title forState:UIControlStateNormal];
                button.hd_associatedObject = config;
                [button sizeToFit];
            }
        }
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - setter
- (void)setDataSource:(NSArray<WMReviewFilterButtonConfig *> *)dataSource {
    _dataSource = dataSource;

    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    WMReviewFilterButton *selectedButton;
    for (WMReviewFilterButtonConfig *config in dataSource) {
        WMReviewFilterButton *button = WMReviewFilterButton.new;
        [button setTitle:config.title forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        button.backgroundColor = HDAppTheme.color.G5;
        [button sizeToFit];
        button.hd_associatedObject = config;
        [button addTarget:self action:@selector(clickedButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.floatLayoutView addSubview:button];
        if (config.isSelected) {
            selectedButton = button;
        }
    }
    if (selectedButton) {
        [selectedButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    [self setNeedsUpdateConstraints];
}

- (void)setShowBottomSepLine:(BOOL)showBottomSepLine {
    _showBottomSepLine = showBottomSepLine;

    self.sepLine.hidden = !showBottomSepLine;

    [self setNeedsUpdateConstraints];
}

- (void)setDefaultHasContentButtonStatus:(BOOL)defaultHasContentButtonStatus {
    _defaultHasContentButtonStatus = defaultHasContentButtonStatus;

    self.hasContentButton.selected = self.defaultHasContentButtonStatus;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat floatLayoutViewWidth = kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
        make.top.equalTo(self).offset(kRealWidth(10));
        make.centerX.equalTo(self);
        make.size.mas_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(floatLayoutViewWidth, CGFLOAT_MAX)]);
    }];
    [self.hasContentButton sizeToFit];
    [self.hasContentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.hasContentButton.bounds.size);
        make.left.equalTo(self.floatLayoutView);
        make.top.equalTo(self.floatLayoutView.mas_bottom).offset(kRealWidth(15));
        if (self.sepLine.isHidden) {
            make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(5));
        }
    }];

    [self.sepLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.sepLine.isHidden) {
            make.top.equalTo(self.hasContentButton.mas_bottom).offset(kRealWidth(5));
            make.height.mas_equalTo(6);
            make.left.width.bottom.equalTo(self);
        }
    }];

    if (self.shouldLayoutSizeFittingSize) {
        CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.frame = CGRectMake(0, 0, kScreenWidth, size.height);
    }

    [super updateConstraints];
}

#pragma mark - getter
- (BOOL)hasContentButtonSelected {
    return self.hasContentButton.isSelected;
}

#pragma mark - lazy load

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = HDFloatLayoutView.new;
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 10);
    }
    return _floatLayoutView;
}

- (HDUIButton *)hasContentButton {
    if (!_hasContentButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard4;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 0);
        [button setTitle:WMLocalizedString(@"has_content", @"有评论内容") forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_coupon_oneclick_protocol_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_coupon_oneclick_protocol_sel"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickedHasContentButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        _hasContentButton = button;
    }
    return _hasContentButton;
}

- (UIView *)sepLine {
    if (!_sepLine) {
        UIView *view = UIView.new;
        view.backgroundColor = HDAppTheme.color.G5;
        view.hidden = !self.showBottomSepLine;
        _sepLine = view;
    }
    return _sepLine;
}
@end
