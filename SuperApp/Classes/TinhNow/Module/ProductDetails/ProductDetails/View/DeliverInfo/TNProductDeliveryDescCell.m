//
//  TNProductDeliveryDescCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//  配送说明cell

#import "TNProductDeliveryDescCell.h"
#import "TNProductOverseaExpressView.h"


@interface TNProductDeliveryDescCell ()
/// 标题
@property (strong, nonatomic) HDLabel *titleLB;
/// 配送流程图
@property (strong, nonatomic) TNProductOverseaExpressView *expressView;
@end


@implementation TNProductDeliveryDescCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.expressView];
}
- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
    }];
    [self.expressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(60));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
- (void)setModel:(TNDeliverFlowModel *)model {
    _model = model;
    self.expressView.model = model;
}
/** @lazy titleLB */
- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[HDLabel alloc] init];
        _titleLB.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLB.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLB.text = TNLocalizedString(@"Y8E5EdDp", @"配送说明");
    }
    return _titleLB;
}
/** @lazy overseaExpressView */
- (TNProductOverseaExpressView *)expressView {
    if (!_expressView) {
        _expressView = [[TNProductOverseaExpressView alloc] init];
    }
    return _expressView;
}
@end
