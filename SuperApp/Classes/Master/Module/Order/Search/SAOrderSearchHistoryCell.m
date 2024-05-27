//
//  SAOrderSearchHistoryCell.m
//  SuperApp
//
//  Created by Tia on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderSearchHistoryCell.h"


@interface SAOrderSearchHistoryCell ()
/// 最近搜索
@property (nonatomic, strong) SALabel *titleLabel;

@property (nonatomic, strong) UIButton *delBtn;
/// tagView
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 最大边距
@property (nonatomic, assign) CGFloat maxWidth;

@end


@implementation SAOrderSearchHistoryCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = self.backgroundColor = UIColor.clearColor;

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.delBtn];
    [self.contentView addSubview:self.floatLayoutView];
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);

    [self.delBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.mas_equalTo(-margin);
        make.centerY.equalTo(self.titleLabel);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(margin * 2);
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat floatLayoutViewWidth = self.frame.size.width - 2 * 10;
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14);
        make.left.equalTo(self.titleLabel);
        make.right.mas_equalTo(-margin);
        make.size.mas_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(floatLayoutViewWidth, CGFLOAT_MAX)]);
        make.bottom.mas_equalTo(-14);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

#pragma mark - private methods
- (void)reloadDataWithDataSource:(NSArray *)dataSource {
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (NSString *title in dataSource) {
        HDUIGhostButton *button = HDUIGhostButton.new;
        [button setTitleColor:HDAppTheme.color.sa_C333 forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard14;
        button.backgroundColor = UIColor.whiteColor;
        button.titleEdgeInsets = UIEdgeInsetsMake(6, 12, 6, 12);
        [button sizeToFit];
        button.hd_associatedObject = title;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickItemBlock ?: self.clickItemBlock(title);
        }];
        [self.floatLayoutView addSubview:button];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark setter
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self reloadDataWithDataSource:dataSource];
}

#pragma mark - lazy load
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.text = SALocalizedString(@"oc_search_history", @"历史搜索");
        label.font = HDAppTheme.font.sa_standard14B;
        label.textColor = HDAppTheme.color.sa_C333;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIButton *)delBtn {
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setImage:[UIImage imageNamed:@"search_icon_del"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_delBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clearAllHistoryBlock ?: self.clearAllHistoryBlock();
        }];
    }
    return _delBtn;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 12, 4);
        _floatLayoutView.maxRowCount = 0;
    }
    return _floatLayoutView;
}

@end
