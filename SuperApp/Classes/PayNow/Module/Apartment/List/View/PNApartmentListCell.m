//
//  PNApartmentListCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentListCell.h"


@interface PNApartmentListCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) HDUIButton *selectBtn;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *contentLabel;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, strong) SALabel *amountLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) HDUIButton *clickBtn;
@end


@implementation PNApartmentListCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.statusLabel];
    [self.bgView addSubview:self.amountLabel];
    [self.bgView addSubview:self.arrowImgView];

    [self.contentView addSubview:self.clickBtn];
}

- (void)updateConstraints {
    if (!self.selectBtn.hidden) {
        [self.selectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];

        [self.selectBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.selectBtn.hidden) {
            make.left.mas_equalTo(self.selectBtn.mas_right);
        } else {
            make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        }
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(8));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(16));
        make.right.mas_equalTo(self.statusLabel.mas_left).offset(-kRealWidth(12));
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.arrowImgView.hidden) {
            make.right.mas_equalTo(self.arrowImgView.mas_left).offset(-kRealWidth(4));
        } else {
            make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        }

        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(20));
    }];

    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(8));
        make.right.mas_equalTo(self.amountLabel.mas_left).offset(-kRealWidth(16));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(16));
    }];

    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusLabel);
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(4));
    }];

    if (!self.arrowImgView.hidden) {
        [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
            make.size.mas_equalTo(self.arrowImgView.image.size);
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
        }];
    }

    if (!self.clickBtn.hidden) {
        [self.clickBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }

    [self.statusLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];


    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNApartmentListItemModel *)model {
    _model = model;

    self.titleLabel.text = model.merchantName;
    self.statusLabel.text = [PNCommonUtils getApartmentStatusName:model.paymentStatus];
    self.amountLabel.text = [model.paymentAmount thousandSeparatorAmount];

    self.selectBtn.selected = model.isSelected;

    if (self.cellType == PNApartmentListCellType_MoreSelect) {
        //是否当前支付币种
        if (WJIsStringEmpty(self.currency)) {
            self.selectBtn.enabled = YES;
            self.clickBtn.enabled = YES;
        } else {
            if ([model.currency isEqualToString:self.currency]) {
                self.selectBtn.enabled = YES;
                self.clickBtn.enabled = YES;
            } else {
                self.selectBtn.enabled = NO;
                self.clickBtn.enabled = NO;
            }
        }
    }

    if (self.cellType == PNApartmentListCellType_Default) {
        self.selectBtn.hidden = YES;
        self.arrowImgView.hidden = NO;
        self.clickBtn.hidden = NO;
        self.contentLabel.text = model.paymentItems;
    } else if (self.cellType == PNApartmentListCellType_MoreSelect) {
        self.selectBtn.hidden = NO;
        self.arrowImgView.hidden = YES;
        self.clickBtn.hidden = NO;
        self.contentLabel.text = model.paymentItems;
    } else if (self.cellType == PNApartmentListCellType_OrderList) {
        self.selectBtn.hidden = YES;
        self.arrowImgView.hidden = NO;
        self.clickBtn.hidden = YES;
        self.contentLabel.text = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTime.floatValue / 1000]];
    } else { /// PNApartmentListCellType_OnlyShow
        self.selectBtn.hidden = YES;
        self.arrowImgView.hidden = YES;
        self.clickBtn.hidden = YES;
        self.contentLabel.text = model.paymentItems;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (HDUIButton *)selectBtn {
    if (!_selectBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_transfer_agreement_unselect"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_transfer_agreement_selected"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"pn_transfer_agreement_disabled"] forState:UIControlStateDisabled];
        button.imageEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
        button.hidden = YES;

        _selectBtn = button;
    }
    return _selectBtn;
}

- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)contentLabel {
    if (!_contentLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        _contentLabel = label;
    }
    return _contentLabel;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard11;
        _statusLabel = label;
    }
    return _statusLabel;
}

- (SALabel *)amountLabel {
    if (!_amountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        _amountLabel = label;
    }
    return _amountLabel;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_icon_black_arrow"];
        imageView.hidden = YES;
        _arrowImgView = imageView;
    }
    return _arrowImgView;
}

- (HDUIButton *)clickBtn {
    if (!_clickBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.hidden = YES;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.selectBtn.selected = !self.selectBtn.selected;
            self.model.isSelected = self.selectBtn.selected;
            !self.selectBtnBlock ?: self.selectBtnBlock(self.model);
        }];

        _clickBtn = button;
    }
    return _clickBtn;
}
@end
