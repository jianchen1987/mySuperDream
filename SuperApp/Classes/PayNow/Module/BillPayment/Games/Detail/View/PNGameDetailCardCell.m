//
//  PNGameDetailCardCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameDetailCardCell.h"
#import "PNView.h"
//兑换卡片视图
@interface PNGameExchangeCardView : PNView
/// 点卡数量
@property (strong, nonatomic) UILabel *diamondLabel;
///
@property (strong, nonatomic) SAOperationButton *groupTagBtn;
/// 选中图片
@property (strong, nonatomic) UIImageView *selectedImageView;
///
@property (strong, nonatomic) UIStackView *stackView;
/// 销售价
@property (strong, nonatomic) UILabel *priceLabel;
/// 市场价
@property (strong, nonatomic) UILabel *marketLabel;
/// 边框
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
///
@property (strong, nonatomic) PNGameItemModel *model;
/// 点击回调
@property (nonatomic, copy) void (^itemClickCallBack)(PNGameItemModel *model);
//更新选中UI
- (void)updateSelectedStateUI;
@end


@implementation PNGameExchangeCardView
- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.diamondLabel];
    [self addSubview:self.selectedImageView];
    [self addSubview:self.groupTagBtn];
    [self addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.priceLabel];
    [self.stackView addArrangedSubview:self.marketLabel];

    @HDWeakify(self);
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.shapeLayer) {
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
        }
        UIColor *color = self.model.isSelected ? HDAppTheme.PayNowColor.mainThemeColor : [UIColor clearColor];
        self.shapeLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:8 borderWidth:1 borderColor:color];
    };

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick)];
    [self addGestureRecognizer:tap];
}
- (void)itemClick {
    if (self.model.isSelected) {
        return;
    }
    self.model.isSelected = !self.model.isSelected;
    !self.itemClickCallBack ?: self.itemClickCallBack(self.model);
}
- (void)setModel:(PNGameItemModel *)model {
    _model = model;
    self.diamondLabel.text = model.name;
    self.priceLabel.text = model.amount.thousandSeparatorAmount;
    if (!HDIsObjectNil(model.amountBeforeDiscount) && HDIsStringNotEmpty(model.amountBeforeDiscount.amount)) {
        NSAttributedString *originalPrice = [[NSAttributedString alloc] initWithString:model.amountBeforeDiscount.thousandSeparatorAmount attributes:@{
            NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Heavy" size:12],
            NSForegroundColorAttributeName: HDAppTheme.PayNowColor.cCCCCCC,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: HDAppTheme.PayNowColor.cCCCCCC
        }];
        self.marketLabel.attributedText = originalPrice;
    }
    [self.groupTagBtn setTitle:model.group forState:UIControlStateNormal];
    [self updateSelectedStateUI];
    [self setNeedsUpdateConstraints];
}
//更新选中状态UI
- (void)updateSelectedStateUI {
    if (self.model.isSelected) {
        self.shapeLayer.strokeColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
        self.stackView.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.priceLabel.textColor = [UIColor whiteColor];
        self.selectedImageView.hidden = NO;
    } else {
        self.shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.stackView.backgroundColor = [HDAppTheme.PayNowColor.mainThemeColor colorWithAlphaComponent:0.06];
        self.priceLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.selectedImageView.hidden = YES;
    }
}
- (void)updateConstraints {
    [self.selectedImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(self.selectedImageView.image.size);
    }];
    [self.diamondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kRealHeight(12));
        make.left.right.equalTo(self);
    }];
    [self.groupTagBtn sizeToFit];
    [self.groupTagBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.diamondLabel.mas_bottom).offset(kRealHeight(8));
    }];
    [self.priceLabel sizeToFit];
    [self.marketLabel sizeToFit];
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.groupTagBtn.mas_bottom).offset(kRealHeight(8));
        make.height.mas_equalTo(kRealHeight(26));
    }];

    [super updateConstraints];
}
/** @lazy diamondLabel */
- (UILabel *)diamondLabel {
    if (!_diamondLabel) {
        _diamondLabel = [[UILabel alloc] init];
        _diamondLabel.font = [HDAppTheme.PayNowFont fontSemibold:14];
        _diamondLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _diamondLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _diamondLabel;
}
/** @lazy selectedImageView */
- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pn_game_card_selected"]];
        [_selectedImageView sizeToFit];
    }
    return _selectedImageView;
}
/** @lazy groupTagBtn */
- (SAOperationButton *)groupTagBtn {
    if (!_groupTagBtn) {
        _groupTagBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        _groupTagBtn.userInteractionEnabled = NO;
        [_groupTagBtn setTitle:PNLocalizedString(@"", @"Group") forState:UIControlStateNormal];
        [_groupTagBtn applyHollowPropertiesWithTintColor:HDAppTheme.PayNowColor.mainThemeColor];
        _groupTagBtn.titleEdgeInsets = UIEdgeInsetsMake(3, 7, 3, 7);
        _groupTagBtn.titleLabel.font = HDAppTheme.PayNowFont.standard11;
    }
    return _groupTagBtn;
}
/** @lazy stackView */
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.backgroundColor = [HDAppTheme.PayNowColor.mainThemeColor colorWithAlphaComponent:0.06];
        _stackView.spacing = 4;
        _stackView.distribution = UIStackViewDistributionFillEqually;
    }
    return _stackView;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Heavy" size:12];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
/** @lazy marketLabel */
- (UILabel *)marketLabel {
    if (!_marketLabel) {
        _marketLabel = [[UILabel alloc] init];
        _marketLabel.textColor = HDAppTheme.PayNowColor.cCCCCCC;
        _marketLabel.font = [HDAppTheme.PayNowFont standard12];
    }
    return _marketLabel;
}
@end


@interface PNGameDetailCardCell ()
///
@property (strong, nonatomic) UIView *bgView;
/// 标题
@property (strong, nonatomic) UILabel *nameLabel;
/// 卡片背景视图
@property (strong, nonatomic) HDFloatLayoutView *floatLayoutView;

@end


@implementation PNGameDetailCardCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.floatLayoutView];
}
- (void)setModel:(PNGameDetailRspModel *)model {
    _model = model;
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!HDIsArrayEmpty(model.item)) {
        for (PNGameItemModel *item in model.item) {
            PNGameExchangeCardView *cardView = [[PNGameExchangeCardView alloc] init];
            cardView.model = item;
            CGFloat width = (kScreenWidth - kRealWidth(36)) / 2;
            CGSize size = [cardView systemLayoutSizeFittingSize:CGSizeMake(width, MAXFLOAT)];
            cardView.size = CGSizeMake(width, size.height);
            @HDWeakify(self);
            cardView.itemClickCallBack = ^(PNGameItemModel *item) {
                @HDStrongify(self);
                [model.item enumerateObjectsUsingBlock:^(PNGameItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if (item != obj) {
                        obj.isSelected = NO;
                    }
                }];
                [self.floatLayoutView.subviews enumerateObjectsUsingBlock:^(__kindof PNGameExchangeCardView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    [obj updateSelectedStateUI];
                }];
                !self.itemClickCallBack ?: self.itemClickCallBack(item);
            };
            [self.floatLayoutView addSubview:cardView];
        }
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.bgView.mas_top).offset(kRealHeight(16));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
    }];
    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealHeight(12));
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-kRealHeight(12));
        make.size.mas_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(kScreenWidth - kRealWidth(24), CGFLOAT_MAX)]);
    }];
    [super updateConstraints];
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    }
    return _bgView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [HDAppTheme.PayNowFont fontSemibold:16];
        _nameLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _nameLabel.text = PNLocalizedString(@"pn_selected_product", @"Select Produce");
    }
    return _nameLabel;
}
/** @lazy floatLayoutView */
- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, kRealWidth(12), kRealHeight(8), 0);
        _floatLayoutView.maximumItemSize = CGSizeMake((kScreenWidth - kRealWidth(36)) / 2, kRealHeight(90));
    }
    return _floatLayoutView;
}
@end
