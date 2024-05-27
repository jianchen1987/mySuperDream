//
//  TNOrderDetailContactCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNOrderDetailContactCell.h"
#import "HDAppTheme+TinhNow.h"


@interface TNOrderDetailContactCell ()
/// 联系商家
@property (nonatomic, strong) HDUIButton *customerServiceBtn;
/// 联系电话
@property (nonatomic, strong) HDUIButton *phoneBtn;
///
@property (strong, nonatomic) UIView *lineView;
@end


@implementation TNOrderDetailContactCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.phoneBtn];
    [self.contentView addSubview:self.customerServiceBtn];
    [self.contentView addSubview:self.lineView];
}
- (void)updateConstraints {
    [self.customerServiceBtn sizeToFit];
    [self.customerServiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kRealWidth(50));
        make.width.equalTo(self.phoneBtn.mas_width);
    }];

    [self.phoneBtn sizeToFit];
    [self.phoneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.contentView);
        make.right.equalTo(self.customerServiceBtn.mas_left);
        make.height.mas_equalTo(kRealWidth(50));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.width.mas_equalTo(1);
    }];
    [super updateConstraints];
}
- (void)setModel:(TNOrderDetailContactCellModel *)model {
    _model = model;
}
- (HDUIButton *)customerServiceBtn {
    if (!_customerServiceBtn) {
        _customerServiceBtn = [[HDUIButton alloc] init];
        [_customerServiceBtn setTitleColor:HexColor(0x5D667F) forState:UIControlStateNormal];
        _customerServiceBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _customerServiceBtn.spacingBetweenImageAndTitle = 5;
        [_customerServiceBtn setTitle:TNLocalizedString(@"tn_order_details_cusomter", @"商家客服") forState:0];
        [_customerServiceBtn setImage:[UIImage imageNamed:@"tn_order_detail_chat"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_customerServiceBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.customerServiceButtonClickedHander) {
                self.customerServiceButtonClickedHander(self.model.storeNo);
            }
        }];
    }
    return _customerServiceBtn;
}

- (HDUIButton *)phoneBtn {
    if (!_phoneBtn) {
        _phoneBtn = [[HDUIButton alloc] init];
        [_phoneBtn setTitleColor:HexColor(0x5D667F) forState:UIControlStateNormal];
        _phoneBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        [_phoneBtn setTitle:TNLocalizedString(@"tn_order_details_phone", @"联系电话") forState:0];
        [_phoneBtn setImage:[UIImage imageNamed:@"tn_order_detail_call"] forState:UIControlStateNormal];
        _phoneBtn.spacingBetweenImageAndTitle = 5;
        @HDWeakify(self);
        [_phoneBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.phoneButtonClickedHander) {
                self.phoneButtonClickedHander();
            }
        }];
    }
    return _phoneBtn;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.cD6DBE8;
    }
    return _lineView;
}
@end


@implementation TNOrderDetailContactCellModel

@end
