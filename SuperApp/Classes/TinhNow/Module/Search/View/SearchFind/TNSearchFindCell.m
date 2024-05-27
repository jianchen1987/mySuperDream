//
//  TNSearchFindCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSearchFindCell.h"
#import "HDFloatLayoutView.h"
#import "TNSearchFindSubItemView.h"

static const NSInteger maxRow = 2;


@interface TNSearchFindCell ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
@property (nonatomic, strong) HDUIButton *showBtn;
@property (nonatomic, assign) CGFloat maxWidth;
@end


@implementation TNSearchFindCell

- (void)hd_setupViews {
    self.maxWidth = kScreenWidth - kRealWidth(30);
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.floatLayoutView];
    [self.contentView addSubview:self.showBtn];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
        CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(self.maxWidth, CGFLOAT_MAX)];
        make.size.mas_equalTo(size);
        if (self.showBtn.isHidden) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        }
    }];

    if (!self.showBtn.isHidden) {
        //        [self.showBtn sizeToFit];
        [self.showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.floatLayoutView.mas_bottom).offset(kRealWidth(10));
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
    }

    [super updateConstraints];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = self.maxWidth;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

#pragma mark
- (void)setDataArray:(NSArray<TNSearchRankAndDiscoveryItemModel *> *)dataArray {
    _dataArray = dataArray;

    if (!HDIsArrayEmpty(dataArray)) {
        [self addTagItemViews];

        if (self.showBtn.isSelected) {
            self.floatLayoutView.maxRowCount = 0;
        } else {
            NSInteger row = [self.floatLayoutView fowardingTotalRowCountWithMaxSize:CGSizeMake(self.maxWidth, CGFLOAT_MAX)];
            if (row > maxRow) {
                self.floatLayoutView.maxRowCount = maxRow;
                self.showBtn.hidden = NO;
            } else {
                self.showBtn.hidden = YES;
            }
        }

        [self setNeedsUpdateConstraints];
    }
}

- (void)addTagItemViews {
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.dataArray.count; i++) {
        TNSearchFindSubItemView *itemView = [[TNSearchFindSubItemView alloc] init];
        TNSearchRankAndDiscoveryItemModel *model = [self.dataArray objectAtIndex:i];
        itemView.model = model;
        itemView.size = [itemView getSizeFits];

        @HDWeakify(self);
        itemView.btnClickBlock = ^(TNSearchRankAndDiscoveryItemModel *_Nonnull model) {
            @HDStrongify(self);
            if (model.pageLink && HDIsStringNotEmpty(model.pageLinkApp)) {
                [SAWindowManager openUrl:model.pageLinkApp withParameters:@{}];
            } else {
                !self.clickItemBlock ?: self.clickItemBlock(model.value);
            }
        };

        [self.floatLayoutView addSubview:itemView];
    }
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.text = TNLocalizedString(@"tn_search_find", @"搜索发现");
        label.font = HDAppTheme.TinhNowFont.standard15B;
        label.textColor = HDAppTheme.TinhNowColor.c343B4D;

        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        _floatLayoutView.maxRowCount = maxRow;
    }
    return _floatLayoutView;
}

- (HDUIButton *)showBtn {
    if (!_showBtn) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:TNLocalizedString(@"Y6ARiDuW", @"查看全部") forState:UIControlStateNormal];
        [btn setTitleColor:HexColor(0xFF8818) forState:UIControlStateNormal];
        btn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        btn.imagePosition = HDUIButtonImagePositionRight;
        btn.spacingBetweenImageAndTitle = kRealWidth(5);
        [btn setImage:[UIImage imageNamed:@"tinhnow_shrink_arrow"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"tinhnow_expand_arrow"] forState:UIControlStateNormal];
        btn.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), kRealWidth(20), kRealWidth(10), kRealWidth(20));
        btn.hidden = YES;
        @HDWeakify(self);
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.selected;
            if (btn.isSelected) {
                [btn setTitle:TNLocalizedString(@"tn_store_less", @"收起") forState:UIControlStateNormal];
            } else {
                [btn setTitle:TNLocalizedString(@"Y6ARiDuW", @"查看全部") forState:UIControlStateNormal];
            }
            /// 需要reload , 不然cell 的布局有问题
            !self.reloadCellBlock ?: self.reloadCellBlock();
        }];
        _showBtn = btn;
    }
    return _showBtn;
}
@end
