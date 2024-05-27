//
//  SASearchLocationView.m
//  SuperApp
//
//  Created by Tia on 2023/7/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SASearchLocationView.h"
#import "SAAddressModel.h"
#import "SACacheManager.h"
#import "SAAddressCacheAdaptor.h"


@interface SASearchLocationView ()
/// 左按钮
@property (nonatomic, strong) UIButton *leftButton;
/// 详细地址后箭头
@property (nonatomic, strong) UIImageView *arrowIV;

@end


@implementation SASearchLocationView

- (void)hd_setupViews {
    [self addSubview:self.leftButton];
    [self addSubview:self.detailAddressLB];
    [self addSubview:self.arrowIV];

    [self addGestureRecognizer:self.hd_tapRecognizer];

    [self updateCurrentAdddress];
}

- (void)updateConstraints {
    [self.leftButton sizeToFit];
    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(0);
    }];

    [self.detailAddressLB size];
    [self.detailAddressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftButton.mas_right);
        make.centerY.equalTo(self);
    }];

    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.arrowIV.image.size);
        make.centerY.equalTo(self);
        make.left.equalTo(self.detailAddressLB.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(-12);
    }];

    [super updateConstraints];
}

#pragma mark - public methods
- (void)updateCurrentAdddress {
    SAAddressModel *addressModel = [SAAddressCacheAdaptor getAddressModelForClientType:SAClientTypeYumNow];
    self.arrowIV.image = [UIImage imageNamed:@"yn_home_down"];
    if (!addressModel) {
        // 默认金边
        addressModel = SAAddressModel.new; /// wm_location_fail
        addressModel.address = SALocalizedString(@"search_location_fail", @"定位失败");
        self.arrowIV.image = [UIImage imageNamed:@"icon_search_refresh"];
    }
    self.detailAddressLB.text = HDIsStringEmpty(addressModel.shortName) ? addressModel.fullAddress : addressModel.shortName;
}

#pragma mark - event response
- (void)hd_clickedViewHandler {
    !self.clickedHandler ?: self.clickedHandler();
}

#pragma mark - lazy load
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 8);
        [_leftButton setImage:[UIImage imageNamed:@"icon_navi_back_black"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_leftButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedBackHandler ?: self.clickedBackHandler();
        }];
    }
    return _leftButton;
}

- (SALabel *)detailAddressLB {
    if (!_detailAddressLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.sa_standard14SB;
        label.textColor = UIColor.sa_C333;
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"辽宁省";
        _detailAddressLB = label;
    }
    return _detailAddressLB;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_home_down"]];
        _arrowIV = imageView;
    }
    return _arrowIV;
}

@end
