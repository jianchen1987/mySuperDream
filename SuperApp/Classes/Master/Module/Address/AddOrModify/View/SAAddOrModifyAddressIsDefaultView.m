//
//  SAAddOrModifyAddressIsDefaultView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressIsDefaultView.h"


@interface SAAddOrModifyAddressIsDefaultView ()
/// 是否默认
@property (nonatomic, strong) UISwitch *isDefaultAddressSwitch;
@end


@implementation SAAddOrModifyAddressIsDefaultView

- (void)hd_setupViews {
    self.titleLB.text = SALocalizedString(@"set_as_default_address", @"设置为默认地址");

    [self addSubview:self.isDefaultAddressSwitch];
    [super hd_setupViews];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.centerY.equalTo(self.isDefaultAddressSwitch);
    }];

    [self.isDefaultAddressSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self).offset(-kRealWidth(10));
        make.top.equalTo(self).offset(kRealWidth(15));
    }];
}

#pragma mark - setter
- (void)setIsDefault:(BOOL)isDefault {
    _isDefault = isDefault;

    self.isDefaultAddressSwitch.on = isDefault;
}

#pragma mark - lazy load
- (UISwitch *)isDefaultAddressSwitch {
    if (!_isDefaultAddressSwitch) {
        _isDefaultAddressSwitch = UISwitch.new;
    }
    return _isDefaultAddressSwitch;
}

@end
