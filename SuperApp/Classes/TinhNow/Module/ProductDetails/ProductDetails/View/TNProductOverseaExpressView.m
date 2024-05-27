//
//  TNProductOverseaExpressView.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductOverseaExpressView.h"
#import "TNDeliverFlowModel.h"


@interface TNProductOverseaExpressView ()
/// 发货地国家
@property (strong, nonatomic) HDUIButton *sendLocationBtn;
/// 物流
@property (strong, nonatomic) HDUIButton *expressBtn;
/// 收货国家
@property (strong, nonatomic) HDUIButton *receiptBtn;
/// 横线1
@property (strong, nonatomic) UIImageView *line1;
/// 横线2
@property (strong, nonatomic) UIImageView *line2;
@end


@implementation TNProductOverseaExpressView
- (void)hd_setupViews {
    [self addSubview:self.sendLocationBtn];
    [self addSubview:self.expressBtn];
    [self addSubview:self.receiptBtn];
    [self addSubview:self.line1];
    [self addSubview:self.line2];
}
- (void)updateConstraints {
    [self.expressBtn sizeToFit];
    [self.expressBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.line1 sizeToFit];
    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.expressBtn.mas_centerY);
        make.right.equalTo(self.expressBtn.mas_left).offset(-kRealWidth(20));
        //        make.height.mas_equalTo(0.5);
        //        make.width.mas_equalTo(kRealWidth(40));
    }];
    [self.sendLocationBtn sizeToFit];
    [self.sendLocationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.expressBtn.mas_centerY);
        make.right.equalTo(self.line1.mas_left).offset(-kRealWidth(25));
    }];
    [self.line2 sizeToFit];
    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.expressBtn.mas_centerY);
        make.left.equalTo(self.expressBtn.mas_right).offset(kRealWidth(20));
        //        make.height.mas_equalTo(0.5);
        //        make.width.mas_equalTo(kRealWidth(40));
    }];
    [self.receiptBtn sizeToFit];
    [self.receiptBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.expressBtn.mas_centerY);
        make.left.equalTo(self.line2.mas_right).offset(kRealWidth(25));
    }];
    [super updateConstraints];
}
- (void)setModel:(TNDeliverFlowModel *)model {
    _model = model;
    [self.sendLocationBtn setTitle:HDIsStringNotEmpty(model.departTxt) ? model.departTxt : TNLocalizedString(@"SMSpgXLZ", @"中国") forState:UIControlStateNormal];
    [self.expressBtn setTitle:HDIsStringNotEmpty(model.interShippingTxt) ? model.interShippingTxt : TNLocalizedString(@"YJJEc1MY", @"国际物流") forState:UIControlStateNormal];
    [self.receiptBtn setTitle:HDIsStringNotEmpty(model.arriveTxt) ? model.arriveTxt : TNLocalizedString(@"vH61oOX8", @"柬埔寨") forState:UIControlStateNormal];
}
/** @lazy sendLocationBtn */
- (HDUIButton *)sendLocationBtn {
    if (!_sendLocationBtn) {
        _sendLocationBtn = [[HDUIButton alloc] init];
        _sendLocationBtn.imagePosition = HDUIButtonImagePositionTop;
        _sendLocationBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _sendLocationBtn.spacingBetweenImageAndTitle = 5;
        [_sendLocationBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_sendLocationBtn setImage:[UIImage imageNamed:@"tn-location_send"] forState:UIControlStateNormal];
    }
    return _sendLocationBtn;
}
/** @lazy expressBtn */
- (HDUIButton *)expressBtn {
    if (!_expressBtn) {
        _expressBtn = [[HDUIButton alloc] init];
        _expressBtn.imagePosition = HDUIButtonImagePositionTop;
        _expressBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _expressBtn.spacingBetweenImageAndTitle = 5;
        [_expressBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_expressBtn setImage:[UIImage imageNamed:@"tn-internation-express"] forState:UIControlStateNormal];
    }
    return _expressBtn;
}
/** @lazy sendLocationBtn */
- (HDUIButton *)receiptBtn {
    if (!_receiptBtn) {
        _receiptBtn = [[HDUIButton alloc] init];
        _receiptBtn.imagePosition = HDUIButtonImagePositionTop;
        _receiptBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        _receiptBtn.spacingBetweenImageAndTitle = 5;
        [_receiptBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        [_receiptBtn setImage:[UIImage imageNamed:@"tn-location_recive"] forState:UIControlStateNormal];
    }
    return _receiptBtn;
}
/** @lazy line1 */
- (UIImageView *)line1 {
    if (!_line1) {
        _line1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_product_express_path"]];
    }
    return _line1;
}
/** @lazy line2 */
- (UIImageView *)line2 {
    if (!_line2) {
        _line2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_product_express_path"]];
    }
    return _line2;
}
@end
