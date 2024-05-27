//
//  SAAddOrModifyAddressView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressView.h"
#import "SACompleteAddressTipsView.h"


@interface SAAddOrModifyAddressView ()
/// 地址
@property (nonatomic, weak) SALabel *addressLB;
/// 完善地址信息提示
@property (nonatomic, strong) SACompleteAddressTipsView *tipsView;
@end


@implementation SAAddOrModifyAddressView

- (void)hd_setupViews {
    self.titleLB.text = SALocalizedString(@"address", @"地址");

    [self addSubview:self.addressLB];
    [self addSubview:self.tipsView];

    [super hd_setupViews];
}

- (void)updateConstraints {
    [self.addressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(15));
        make.left.equalTo(self.titleLB.mas_right);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        if (self.tipsView.isHidden) {
            make.bottom.equalTo(self).offset(-kRealWidth(15));
        }
    }];
    [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipsView.isHidden) {
            make.left.right.equalTo(self.addressLB);
            make.top.equalTo(self.addressLB.mas_bottom).offset(kRealWidth(8));
            make.bottom.equalTo(self).offset(-kRealWidth(8));
        }
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setAddressModel:(SAAddressModel *)addressModel {
    _addressModel = addressModel;

    self.addressLB.text = addressModel.address;

    BOOL needCompleteAddress = [addressModel isNeedCompleteAddress];
    self.tipsView.hidden = !needCompleteAddress;
    self.addressLB.textColor = needCompleteAddress ? HDAppTheme.color.G3 : HDAppTheme.color.G1;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SALabel *)addressLB {
    if (!_addressLB) {
        SALabel *label = SALabel.new;
        label.text = SALocalizedString(@"choose_receiving_address", @"选择收货地址");
        label.textColor = HDAppTheme.color.G3;
        label.font = HDAppTheme.font.standard3;
        label.numberOfLines = 0;
        _addressLB = label;
    }
    return _addressLB;
}

- (SACompleteAddressTipsView *)tipsView {
    if (!_tipsView) {
        _tipsView = SACompleteAddressTipsView.new;
        _tipsView.hidden = true;
    }
    return _tipsView;
}

@end
