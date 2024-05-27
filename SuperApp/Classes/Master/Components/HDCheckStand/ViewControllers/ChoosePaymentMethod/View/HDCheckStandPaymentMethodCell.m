//
//  HDCheckStandPaymentMethodCell.m
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckStandPaymentMethodCell.h"
#import "HDCheckStandPaymentMethodView.h"


@interface HDCheckStandPaymentMethodCell ()
///< view
@property (nonatomic, strong) HDCheckStandPaymentMethodView *paymentMethodView;
@end


@implementation HDCheckStandPaymentMethodCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.paymentMethodView];
}

#pragma mark - setter
- (void)setModel:(HDCheckStandPaymentMethodCellModel *)model {
    _model = model;
    self.paymentMethodView.model = model;

    [self setNeedsUpdateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.paymentMethodView setSelected:selected animated:animated];
    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.paymentMethodView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
/** @lazy paymentMethodView */
- (HDCheckStandPaymentMethodView *)paymentMethodView {
    if (!_paymentMethodView) {
        _paymentMethodView = [[HDCheckStandPaymentMethodView alloc] init];
        _paymentMethodView.clickedHandler = ^(HDCheckStandPaymentMethodView *_Nonnull view, HDCheckStandPaymentMethodCellModel *_Nonnull model) {

        };
    }
    return _paymentMethodView;
}

@end
