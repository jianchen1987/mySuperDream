//
//  TNPaymentMethodView.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/9/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNPaymentMethodView.h"
#import "SAInternationalizationModel.h"
#import "SAPaymentMarketTipsView.h"
#import "TNGuideViewController.h"
#import "TNPaymentMethodModel.h"


@interface TNPaymentMethodView ()

/// 名称按钮  可能会带图片
@property (strong, nonatomic) HDUIButton *nameBtn;
/// 描述文本
@property (strong, nonatomic) UILabel *descLabel;
///< 支付营销信息
@property (nonatomic, strong) SAPaymentMarketTipsView *marketingInfoView;
/// 选中按钮
@property (strong, nonatomic) UIImageView *selectImageView;
/// 箭头图片
@property (strong, nonatomic) UIImageView *arrowImageView;
/// 选择值视图
@property (strong, nonatomic) UILabel *valueLabel;
/// 选择值icon
@property (nonatomic, strong) UIImageView *valueIconImgView;

@end


@implementation TNPaymentMethodView
- (void)hd_setupViews {
    [self addSubview:self.nameBtn];
    [self addSubview:self.marketingInfoView];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.valueLabel];
    [self addSubview:self.valueIconImgView];
    [self addSubview:self.descLabel];
    [self addSubview:self.selectImageView];

    [self.nameBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.valueLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}
- (void)updateConstraints {
    [self.nameBtn sizeToFit];
    [self.nameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(38));
        make.top.equalTo(self.mas_top).offset(kRealWidth(12));
        if (self.marketingInfoView.isHidden && self.descLabel.isHidden) {
            make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(12));
        }
    }];
    if (!self.arrowImageView.isHidden) {
        [self.arrowImageView sizeToFit];
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameBtn.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
            make.size.mas_equalTo(self.arrowImageView.image.size);
        }];
    }
    if (!self.valueLabel.isHidden) {
        [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameBtn.mas_centerY);
            make.right.equalTo(self.arrowImageView.mas_left).offset(-kRealWidth(5));
            make.left.greaterThanOrEqualTo(self.nameBtn.mas_right).offset(kRealWidth(10));
        }];
    }

    if (!self.valueIconImgView.isHidden) {
        [self.valueIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.valueLabel.mas_left).offset(-kRealWidth(5));
            make.centerY.mas_equalTo(self.valueLabel.mas_centerY);
            make.height.equalTo(@(20));
            make.width.mas_equalTo(self.valueIconImgView.mas_height).multipliedBy(self.valueIconImgView.image.size.width / self.valueIconImgView.image.size.height);
        }];
    }

    if (!self.marketingInfoView.isHidden) {
        [self.marketingInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameBtn.mas_leading).offset(-HDAppTheme.value.padding.left);
            make.top.equalTo(self.nameBtn.mas_bottom).offset(kRealWidth(8));
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
    }

    if (!self.descLabel.isHidden) {
        [self.descLabel sizeToFit];
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameBtn.mas_leading);
            make.top.equalTo(self.nameBtn.mas_bottom).offset(kRealWidth(8));
            make.right.lessThanOrEqualTo(self.selectImageView.mas_left).offset(-kRealWidth(15));
            make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(12));
        }];
    }

    if (!self.selectImageView.isHidden) {
        [self.selectImageView sizeToFit];
        [self.selectImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
        }];
    }

    [super updateConstraints];
}
- (void)setModel:(TNPaymentMethodModel *)model {
    _model = model;
    [self.nameBtn setTitle:model.name.desc forState:UIControlStateNormal];
    if (model.isSelected == YES) {
        self.selectImageView.image = [UIImage imageNamed:@"tinhnow-selected"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"tinhnow-unSelected"];
    }

    if ([model.method isEqualToString:TNPaymentMethodOnLine]) { //在线支付
        self.marketingInfoView.hidden = NO;
        self.valueLabel.hidden = NO;
        self.arrowImageView.hidden = NO;
        self.selectImageView.hidden = YES;
        if (!HDIsObjectNil(model.selectedOnlineMethodType) && model.isSelected) {
            self.valueLabel.text = model.selectedOnlineMethodType.toolName;
            self.valueLabel.textColor = HDAppTheme.TinhNowColor.G1;
            if (HDIsStringNotEmpty(model.selectOnlineMethodTypeImageName)) {
                self.valueIconImgView.hidden = NO;
                self.valueIconImgView.image = [UIImage imageNamed:model.selectOnlineMethodTypeImageName];
            } else {
                self.valueIconImgView.hidden = YES;
            }
        } else {
            self.valueLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
            self.valueLabel.text = TNLocalizedString(@"tn_please_selected_payment", @"请选择支付方式");
        }
        if (!HDIsArrayEmpty(model.marktingInfos)) {
            self.marketingInfoView.hidden = NO;
            self.marketingInfoView.marketingInfo = model.marktingInfos;
        } else {
            self.marketingInfoView.hidden = YES;
        }
    } else {
        self.marketingInfoView.hidden = YES;
        self.valueLabel.hidden = YES;
        self.valueIconImgView.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.selectImageView.hidden = NO;
    }

    if ([model.method isEqualToString:TNPaymentMethodOffLine]) { //货到付款提示文本
        self.descLabel.text = model.desc;
        if (model.isSelected) {
            self.descLabel.hidden = NO;
        } else {
            self.descLabel.hidden = YES;
        }
    } else {
        self.descLabel.text = nil;
        self.descLabel.hidden = YES;
    }

    if ([model.method isEqualToString:TNPaymentMethodTransfer]) { //线下转账要展示问号按钮
        [self.nameBtn setImage:[UIImage imageNamed:@"tinhnow_doubt"] forState:UIControlStateNormal];
        self.nameBtn.userInteractionEnabled = YES;
    } else {
        [self.nameBtn setImage:nil forState:UIControlStateNormal];
        self.nameBtn.userInteractionEnabled = NO;
    }
    [self setNeedsUpdateConstraints];
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    !self.clickPaymentCallBack ?: self.clickPaymentCallBack(self.model);
}
- (HDUIButton *)nameBtn {
    if (!_nameBtn) {
        _nameBtn = [[HDUIButton alloc] init];
        _nameBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard15M;
        [_nameBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _nameBtn.spacingBetweenImageAndTitle = 8;
        _nameBtn.imagePosition = HDUIButtonImagePositionRight;
        _nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _nameBtn.adjustsButtonWhenHighlighted = NO;
        [_nameBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            TNGuideViewController *vc = [[TNGuideViewController alloc] init];
            [SAWindowManager navigateToViewController:vc];
        }];
    }
    return _nameBtn;
}
/** @lazy selectImageView */
- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"tinhnow-unSelected"];
    }
    return _selectImageView;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:10];
        _descLabel.textColor = HDAppTheme.TinhNowColor.G3;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
}
/** @lazy valueLabel */
- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = HDAppTheme.TinhNowFont.standard12;
        _valueLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _valueLabel.numberOfLines = 2;
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel;
}
- (UIImageView *)valueIconImgView {
    if (!_valueIconImgView) {
        _valueIconImgView = [[UIImageView alloc] init];
        _valueIconImgView.hidden = YES;
    }
    return _valueIconImgView;
}
- (SAPaymentMarketTipsView *)marketingInfoView {
    if (!_marketingInfoView) {
        _marketingInfoView = SAPaymentMarketTipsView.new;
        _marketingInfoView.hidden = YES;
        _marketingInfoView.userInteractionEnabled = YES;
    }
    return _marketingInfoView;
}
@end
