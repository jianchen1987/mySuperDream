//
//  TNPaymentMethodCell.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/9/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNPaymentMethodCell.h"
#import "SAAppSwitchManager.h"
#import "SACacheManager.h"
#import "SAInternationalizationModel.h"
#import "SAQueryAvaliableChannelRspModel.h"
#import "TNPaymentMethodView.h"


@interface TNPaymentMethodCell ()
@property (nonatomic, strong) UIView *paymentView;
@end


@implementation TNPaymentMethodCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.paymentView];
}
- (void)setDataSource:(NSArray<TNPaymentMethodModel *> *)dataSource {
    _dataSource = dataSource;
    if (HDIsArrayEmpty(dataSource)) {
        return;
    }
    [self.paymentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView = nil;
    for (int i = 0; i < dataSource.count; i++) {
        TNPaymentMethodModel *model = dataSource[i];
        //创建支付方式视图
        TNPaymentMethodView *payView = [[TNPaymentMethodView alloc] init];
        payView.tag = i;
        payView.model = model;
        [self.paymentView addSubview:payView];
        [payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.paymentView);
            if (lastView == nil) {
                make.top.equalTo(self.paymentView.mas_top);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i == dataSource.count - 1) {
                make.bottom.equalTo(self.paymentView.mas_bottom);
            }
        }];
        lastView = payView;
        @HDWeakify(self);
        payView.clickPaymentCallBack = ^(TNPaymentMethodModel *_Nonnull payMethodModel) {
            @HDStrongify(self);
            [self clickPaymentHandle:payMethodModel];
        };
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.paymentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    [super updateConstraints];
}
- (void)clickPaymentHandle:(TNPaymentMethodModel *)model {
    if (self.selectedItemHandler) {
        self.selectedItemHandler(model);
    }
}
- (UIView *)paymentView {
    if (!_paymentView) {
        _paymentView = [[UIView alloc] init];
    }
    return _paymentView;
}
@end


@implementation TNPaymentMethodCellModel

@end
