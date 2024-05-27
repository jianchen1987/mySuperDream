//
//  TNBargainGoodInfoCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainGoodInfoCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNBargainRuleViewController.h"
#import "TNEnum.h"


@interface TNBargainGoodInfoCell ()
/// 颜色块
@property (strong, nonatomic) UIView *colorBgView;
/// 卡片背景
@property (strong, nonatomic) UIView *cardBgView;
/// 商品图片
@property (strong, nonatomic) UIImageView *goodsImageView;
/// 价格
@property (nonatomic, strong) UILabel *priceLabel;
///  原价
@property (nonatomic, strong) UILabel *originalPriceLabel;
/// 产品名称
@property (nonatomic, strong) UILabel *productNameLabel;
/// 查看详情
@property (strong, nonatomic) HDUIButton *watchDetailBtn;
/// 流式布局容器
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
@end


@implementation TNBargainGoodInfoCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
    [self.contentView addSubview:self.colorBgView];
    [self.contentView addSubview:self.cardBgView];
    [self.cardBgView addSubview:self.goodsImageView];
    [self.cardBgView addSubview:self.priceLabel];
    [self.cardBgView addSubview:self.originalPriceLabel];
    [self.cardBgView addSubview:self.productNameLabel];
    [self.cardBgView addSubview:self.watchDetailBtn];
    [self.cardBgView addSubview:self.floatLayoutView];
}
- (void)updateConstraints {
    [self.colorBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(130));
    }];
    [self.cardBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardBgView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.cardBgView.mas_left).offset(kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(110), kRealWidth(110)));
        if (self.floatLayoutView.isHidden) {
            make.bottom.equalTo(self.cardBgView.mas_bottom).offset(-kRealWidth(10));
        }
    }];
    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(kRealWidth(10));
        make.right.lessThanOrEqualTo(self.cardBgView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.goodsImageView.mas_top);
    }];

    [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
        make.left.equalTo(self.goodsImageView.mas_right).offset(kRealWidth(10));
    }];
    [self.watchDetailBtn sizeToFit];
    [self.watchDetailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.originalPriceLabel.mas_centerY);
        make.right.equalTo(self.cardBgView.mas_right).offset(-kRealWidth(15));
    }];

    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(kRealWidth(10));
        make.bottom.equalTo(self.originalPriceLabel.mas_top).offset(-kRealWidth(10));
    }];
    if (!self.floatLayoutView.isHidden) {
        [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
            CGFloat width = kScreenWidth - 2 * kRealWidth(15);
            make.top.equalTo(self.goodsImageView.mas_bottom).offset(kRealWidth(10));
            make.left.equalTo(self.cardBgView.mas_left).offset(kRealWidth(10));
            make.right.equalTo(self.cardBgView.mas_right).offset(-kRealWidth(10));
            CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
            make.bottom.equalTo(self.cardBgView.mas_bottom).offset(-kRealWidth(10));
        }];
    }
    [super updateConstraints];
}
- (void)setModel:(TNBargainDetailModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.images placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(110), kRealWidth(110))] imageView:self.goodsImageView];
    self.priceLabel.text = model.bargainDetailsCount.lowestMoney.thousandSeparatorAmount;
    if (HDIsStringNotEmpty(model.goodsPriceMoney.thousandSeparatorAmount)) {
        NSAttributedString *originalPrice = [[NSAttributedString alloc] initWithString:model.goodsPriceMoney.thousandSeparatorAmount attributes:@{
            NSFontAttributeName: self.originalPriceLabel.font,
            NSForegroundColorAttributeName: self.originalPriceLabel.textColor,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: self.originalPriceLabel.textColor
        }];
        self.originalPriceLabel.attributedText = originalPrice;
    }
    self.productNameLabel.text = model.goodsName;
    if (HDIsStringNotEmpty(model.goodsSpec)) {
        [self.floatLayoutView hd_removeAllSubviews];
        NSData *data = [model.goodsSpec dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSArray *specArr = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!HDIsArrayEmpty(specArr)) {
            self.floatLayoutView.hidden = NO;
            for (NSString *tag in specArr) {
                HDLabel *tagLabel = [[HDLabel alloc] init];
                tagLabel.text = tag;
                tagLabel.font = HDAppTheme.TinhNowFont.standard13;
                tagLabel.textColor = HDAppTheme.TinhNowColor.C1;
                tagLabel.textAlignment = NSTextAlignmentCenter;
                tagLabel.backgroundColor = [UIColor whiteColor];
                tagLabel.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(17), kRealWidth(8), kRealWidth(17));
                tagLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
                    [view setRoundedCorners:UIRectCornerAllCorners radius:4 borderWidth:1 borderColor:HDAppTheme.TinhNowColor.C1];
                };
                [self.floatLayoutView addSubview:tagLabel];
            }
        } else {
            self.floatLayoutView.hidden = YES;
        }
    }
    if (self.isFromHelpBargain) {
        self.watchDetailBtn.hidden = YES;
    } else {
        self.watchDetailBtn.hidden = NO;
    }
    [self setNeedsUpdateConstraints];
}
//前往商品详情
- (void)gotoGoodDetail {
    if (self.isFromHelpBargain) {
        //来自帮砍页面 就进入规则页面
        //        TNBargainRuleViewController *vc = [[TNBargainRuleViewController alloc] initWithRouteParameters:@{}];
        //        [SAWindowManager navigateToViewController:vc];
    } else {
        [[HDMediator sharedInstance]
            navigaveTinhNowBargainProductDetailViewController:@{@"activityId": self.model.activityId, @"taskId": self.model.taskId, @"price": self.model.goodsPriceMoney.thousandSeparatorAmount}];
    }
}
/** @lazy colorBgView */
- (UIView *)colorBgView {
    if (!_colorBgView) {
        _colorBgView = [[UIView alloc] init];
        _colorBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FD2638"] toColor:[UIColor hd_colorWithHexString:@"#FD8A54"]
                                        startPoint:CGPointMake(0.04950455576181412, 0.031982421875)
                                          endPoint:CGPointMake(0.987311840057373, 0.7791576981544495)];
        };
    }
    return _colorBgView;
}
/** @lazy cardBgView */
- (UIView *)cardBgView {
    if (!_cardBgView) {
        _cardBgView = [[UIView alloc] init];
        _cardBgView.backgroundColor = [UIColor whiteColor];
        _cardBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoGoodDetail)];
        [_cardBgView addGestureRecognizer:tap];
    }
    return _cardBgView;
}
/** @lazy goodsImageView */
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
    }
    return _goodsImageView;
}
/** @lazy priceRangLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:20];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.C3;
    }
    return _priceLabel;
}
/** @lazy productName */
- (UILabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.font = HDAppTheme.TinhNowFont.standard12;
        _originalPriceLabel.textColor = HDAppTheme.TinhNowColor.G3;
    }
    return _originalPriceLabel;
}
/** @lazy productName */
- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc] init];
        _productNameLabel.font = [UIFont boldSystemFontOfSize:15];
        _productNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _productNameLabel.numberOfLines = 3;
    }
    return _productNameLabel;
}

/** @lazy discountLabel */
- (HDUIButton *)watchDetailBtn {
    if (!_watchDetailBtn) {
        _watchDetailBtn = [[HDUIButton alloc] init];
        [_watchDetailBtn setTitle:[NSString stringWithFormat:@"%@ >", TNLocalizedString(@"tn_bargain_see_detail", @"查看详情")] forState:UIControlStateNormal];
        [_watchDetailBtn setTitleColor:HDAppTheme.TinhNowColor.G3 forState:UIControlStateNormal];
        _watchDetailBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _watchDetailBtn.userInteractionEnabled = NO;
    }
    return _watchDetailBtn;
}
/** @lazy floatLayoutView */
- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, kRealWidth(12), kRealWidth(10));
        _floatLayoutView.minimumItemSize = CGSizeMake(kRealWidth(40), kRealWidth(28));
    }
    return _floatLayoutView;
}
@end
