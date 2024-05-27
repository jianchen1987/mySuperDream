//
//  TNSearchRankCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSearchRankCell.h"
#import "HDFloatLayoutView.h"
#import "SATableView.h"
#import "TNSearchRankSubItemView.h"


@interface TNSearchRankCell ()
@property (nonatomic, strong) UIImageView *topBgImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
@end


@implementation TNSearchRankCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.floatLayoutView];
    [self.topBgImgView addSubview:self.titleLabel];
    [self.contentView addSubview:self.topBgImgView];
}

- (void)updateConstraints {
    [self.topBgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@((kScreenWidth - kRealWidth(30)) * 50.0 / 345.0));
        make.left.right.top.equalTo(self.contentView);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBgImgView.mas_left).offset(kRealWidth(15));
        make.centerY.mas_equalTo(self.topBgImgView.mas_centerY);
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBgImgView.mas_left);
        make.right.mas_equalTo(self.topBgImgView.mas_right);
        make.top.mas_equalTo(self.topBgImgView.mas_bottom).offset(-kRealWidth(3));
        CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(kScreenWidth - kRealWidth(30), CGFLOAT_MAX)];
        make.size.mas_equalTo(CGSizeMake(size.width, size.height + kRealWidth(5)));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];

    [super updateConstraints];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

#pragma mark
- (void)setDataArray:(NSArray<TNSearchRankAndDiscoveryItemModel *> *)dataArray {
    _dataArray = dataArray;

    [self addTagItemViews];
    [self.floatLayoutView setNeedsLayout];
    [self.floatLayoutView layoutIfNeeded];

    [self setNeedsUpdateConstraints];
}

- (void)addTagItemViews {
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.dataArray.count; i++) {
        TNSearchRankSubItemView *itemView = [[TNSearchRankSubItemView alloc] init];
        TNSearchRankAndDiscoveryItemModel *model = [self.dataArray objectAtIndex:i];
        itemView.model = model;
        itemView.size = [itemView getSizeFits];
        @HDWeakify(self);
        itemView.btnClickBlock = ^(TNSearchRankAndDiscoveryItemModel *_Nonnull model) {
            @HDStrongify(self);
            !self.clickItemBlock ?: self.clickItemBlock(model.value);
        };

        [self.floatLayoutView addSubview:itemView];
    }
}

#pragma mark
- (UIImageView *)topBgImgView {
    if (!_topBgImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"tinhnow_search_bg_rank"];
        imageView.layer.masksToBounds = YES;
        _topBgImgView = imageView;
    }
    return _topBgImgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HexColor(0xFF8818);
        label.font = HDAppTheme.TinhNowFont.standard15;
        label.text = TNLocalizedString(@"tn_search_rank", @"搜索排行");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        _floatLayoutView.maxRowCount = 0;
        _floatLayoutView.layer.cornerRadius = kRealWidth(8);
        //        _floatLayoutView.layer.borderWidth = 1;
        //        _floatLayoutView.layer.borderColor = HDAppTheme.TinhNowColor.lineColor.CGColor;
        //        _floatLayoutView.layer.masksToBounds = YES;
        _floatLayoutView.hd_borderPosition = HDViewBorderPositionLeft | HDViewBorderPositionRight | HDViewBorderPositionBottom;
        _floatLayoutView.hd_borderColor = HDAppTheme.TinhNowColor.lineColor;
        //        _floatLayoutView.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:kRealWidth(8) borderWidth:1 borderColor:HDAppTheme.TinhNowColor.lineColor];
        //        };
    }
    return _floatLayoutView;
}

@end
