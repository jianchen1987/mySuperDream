//
//  TNProductDetailsActivityCell.m
//  SuperApp
//
//  Created by xixi on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDetailsActivityCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNProductActivityModel.h"
#import "UIView+FrameChangedHandler.h"


@interface TNProductDetailsActivityCell ()
///
@property (nonatomic, strong) UIView *acTitleBgView;
///
@property (nonatomic, strong) UILabel *acTitleLabel;
///
@property (nonatomic, strong) UIView *acPriceBgView;
///
@property (nonatomic, strong) UILabel *acPriceLabel;
///
@property (nonatomic, strong) UILabel *showDetailsLabel;
///
@property (nonatomic, strong) UIImageView *arrowImgView;
///
@property (nonatomic, strong) UIView *line;
@end


@implementation TNProductDetailsActivityCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}
- (void)hd_setupViews {
    [self.contentView addSubview:self.acTitleBgView];
    [self.acTitleBgView addSubview:self.acTitleLabel];
    [self.contentView addSubview:self.acPriceBgView];
    [self.acPriceBgView addSubview:self.acPriceLabel];
    [self.contentView addSubview:self.showDetailsLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.acTitleLabel sizeToFit];
    [self.acTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.acTitleBgView.mas_left).offset(10.f);
        make.right.mas_equalTo(self.acTitleBgView.mas_right).offset(-10.f);
        make.top.mas_equalTo(self.acTitleBgView.mas_top).offset(3.f);
        make.bottom.mas_equalTo(self.acTitleBgView.mas_bottom).offset(-3.f);
        make.height.equalTo(@(20.0));
    }];

    [self.acTitleBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];

    [self.acPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.acPriceBgView.mas_left).offset(10.f);
        make.right.mas_equalTo(self.acPriceBgView.mas_right).offset(-10.f);
        make.top.mas_equalTo(self.acPriceBgView.mas_top).offset(3.f);
        make.bottom.mas_equalTo(self.acPriceBgView.mas_bottom).offset(-3.f);
        make.height.equalTo(@(20.0));
    }];

    [self.acPriceBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.acTitleBgView.mas_right);
        make.top.mas_equalTo(self.acTitleBgView.mas_top);
        make.bottom.mas_equalTo(self.acTitleBgView.mas_bottom);
    }];

    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowImgView.image.size);
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
    }];

    [self.showDetailsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-10.f);
        make.centerY.equalTo(self.contentView);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(PixelOne));
        make.left.mas_equalTo(self.contentView.mas_left).offset(15.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1.f);
    }];

    [super updateConstraints];
}

- (void)setModel:(TNProductActivityModel *)model {
    _model = model;
    if (_model.type == 0) {
        self.acTitleLabel.text = TNLocalizedString(@"tn_product_bargain_discount", @"砍价特惠");
    } else {
        self.acTitleLabel.text = TNLocalizedString(@"tn_product_pintuan_discount", @"拼团特惠");
    }
    if (!HDIsObjectNil(_model.price)) {
        self.acPriceLabel.text = [NSString stringWithFormat:@"%@%@", _model.price.thousandSeparatorAmount, TNLocalizedString(@"tn_bargain_take_away", @"拿走")];
    } else {
        self.acPriceLabel.text = [NSString stringWithFormat:@"%@%@", @"", TNLocalizedString(@"tn_bargain_take_away", @"拿走")];
    }
}

#pragma mark -
- (UILabel *)acTitleLabel {
    if (!_acTitleLabel) {
        _acTitleLabel = [[UILabel alloc] init];
        _acTitleLabel.textColor = HDAppTheme.TinhNowColor.cFF8824;
        _acTitleLabel.font = [HDAppTheme.TinhNowFont fontRegular:14.0];
    }
    return _acTitleLabel;
}

- (UIView *)acTitleBgView {
    if (!_acTitleBgView) {
        _acTitleBgView = [[UIView alloc] init];
        _acTitleBgView.backgroundColor = HDAppTheme.TinhNowColor.cFFF3E8;
        _acTitleBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft radius:10.f];
        };
    }
    return _acTitleBgView;
}

- (UILabel *)acPriceLabel {
    if (!_acPriceLabel) {
        _acPriceLabel = [[UILabel alloc] init];
        _acPriceLabel.textColor = [UIColor whiteColor];
        _acPriceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    }
    return _acPriceLabel;
}

- (UIView *)acPriceBgView {
    if (!_acPriceBgView) {
        _acPriceBgView = [[UIView alloc] init];
        _acPriceBgView.backgroundColor = HDAppTheme.TinhNowColor.R2;
        _acPriceBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomRight radius:10.f];
        };
    }
    return _acPriceBgView;
}

- (UILabel *)showDetailsLabel {
    if (!_showDetailsLabel) {
        _showDetailsLabel = [[UILabel alloc] init];
        _showDetailsLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
        _showDetailsLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _showDetailsLabel.text = TNLocalizedString(@"tn_bargain_see_detail", @"查看详情");
    }
    return _showDetailsLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImgView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.TinhNowColor.lineColor;
    }
    return _line;
}

@end


@implementation TNProductDetailsActivityCellModel

@end
