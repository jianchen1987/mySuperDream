//
//  SASearchFindCell.m
//  SuperApp
//
//  Created by Tia on 2022/12/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASearchFindCell.h"
#import "HDFloatLayoutView.h"

static const NSInteger maxRow = 2;


@interface SASearchFindCell ()
/// 搜索发现
@property (nonatomic, strong) SALabel *titleLabel;
/// tagView
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 展开按钮
@property (nonatomic, strong) HDUIGhostButton *moreBtn;
/// 最大边距
@property (nonatomic, assign) CGFloat maxWidth;

@end


@implementation SASearchFindCell

- (void)hd_setupViews {
    self.maxWidth = kScreenWidth - kRealWidth(12) * 2;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.floatLayoutView];
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(margin);
        make.right.mas_equalTo(-margin);
        make.height.mas_equalTo(margin * 2);
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
        CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(self.maxWidth, CGFLOAT_MAX)];
        make.size.mas_equalTo(size);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(14));
    }];

    [super updateConstraints];
}

#pragma mark private method
- (void)addTagItemViews {
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (SAImageLabelCollectionViewCellModel *model in self.dataSource) {
        HDUIGhostButton *button = HDUIGhostButton.new;
        [button setTitleColor:HDAppTheme.color.sa_C333 forState:UIControlStateNormal];
        [button setTitle:model.title forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.sa_standard14;
        button.backgroundColor = [HDAppTheme.color sa_colorWithHexString:@"#F6F6F6"];
        button.titleEdgeInsets = UIEdgeInsetsMake(6, 12, 6, 12);
        [button sizeToFit];
        button.hd_associatedObject = model;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickItemBlock ?: self.clickItemBlock(model.title);
        }];
        [self.floatLayoutView addSubview:button];
    }
}

#pragma mark setter
- (void)setDataSource:(NSArray<SAImageLabelCollectionViewCellModel *> *)dataSource {
    _dataSource = dataSource;
    if (!HDIsArrayEmpty(dataSource)) {
        [self addTagItemViews];
        NSInteger row = [self.floatLayoutView fowardingTotalRowCountWithMaxSize:CGSizeMake(self.maxWidth, CGFLOAT_MAX)];
        if (row > maxRow) { //当前行数超过2行才显示更多按钮
            self.floatLayoutView.defaultShowAll = self.isShowAll;
            [_floatLayoutView setCustomMoreView:self.moreBtn];
        }
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark lazy
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.text = SALocalizedString(@"search_suggested", @"猜你想搜");
        label.font = HDAppTheme.font.sa_standard14B;
        label.textColor = HDAppTheme.color.sa_C333;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 12, 4);
        _floatLayoutView.maxRowCount = maxRow;
    }
    return _floatLayoutView;
}

- (HDUIGhostButton *)moreBtn {
    if (!_moreBtn) {
        HDUIGhostButton *view = HDUIGhostButton.new;
        view.imagePosition = HDUIButtonImagePositionBottom;
        view.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        //        view.backgroundColor = UIColor.orangeColor;
        [view sizeToFit];
        [view setImage:[UIImage imageNamed:@"search_icon_down"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"search_icon_close"] forState:UIControlStateSelected];
        @HDWeakify(self);
        [view addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.reloadCellBlock ?: self.reloadCellBlock();
        }];
        _moreBtn = view;
    }
    return _moreBtn;
}

@end
