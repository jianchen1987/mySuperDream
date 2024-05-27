//
//  GNStoreMapFootView.m
//  SuperApp
//
//  Created by wmz on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreMapFootView.h"
#import "GNStoreDetailModel.h"


@interface GNStoreMapFootView ()
@property (nonatomic, strong) HDLabel *nameLB;         /// name
@property (nonatomic, strong) HDLabel *addressLB;      /// address
@property (nonatomic, strong) HDUIButton *locationBtn; /// 导航
@property (nonatomic, strong) HDUIButton *callBtn;     /// 拨号
@end


@implementation GNStoreMapFootView

- (void)hd_setupViews {
    [self addSubview:self.nameLB];
    [self addSubview:self.addressLB];
    [self addSubview:self.locationBtn];
    [self addSubview:self.callBtn];
    [self addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
    }];

    [self.addressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.top.equalTo(self.nameLB.mas_bottom).offset(HDAppTheme.value.gn_marginT);
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(HDAppTheme.value.pixelOne);
        make.top.equalTo(self.addressLB.mas_bottom).offset(HDAppTheme.value.gn_marginT);
    }];

    [self.locationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.width.mas_equalTo(kScreenWidth * 0.5);
        make.height.mas_equalTo(kRealHeight(48));
        make.left.mas_offset(0);
        make.bottom.mas_equalTo(0);
    }];

    [self.callBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.locationBtn);
        make.right.mas_offset(0);
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNStoreDetailModel *)data {
    self.nameLB.text = [NSString stringWithFormat:@"%@ (%@)", data.storeName.desc, data.classificationName.desc];
    self.addressLB.text = data.address;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = HDLabel.new;
        _nameLB.numberOfLines = 2;
    }
    return _nameLB;
}

- (HDLabel *)addressLB {
    if (!_addressLB) {
        _addressLB = HDLabel.new;
        _addressLB.numberOfLines = 5;
    }
    return _addressLB;
}

- (HDUIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setImage:[UIImage imageNamed:@"gn_storeinfo_daohang"] forState:UIControlStateNormal];
        _locationBtn.titleLabel.font = [HDAppTheme.font forSize:13.0];
        [_locationBtn setTitle:GNLocalizedString(@"gn_store_navigation", @"导航") forState:UIControlStateNormal];
        [_locationBtn setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        _locationBtn.imagePosition = HDUIButtonImagePositionLeft;
        _locationBtn.spacingBetweenImageAndTitle = kRealHeight(5);
        @HDWeakify(self)[_locationBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"navigationAction"];
        }];
    }
    return _locationBtn;
}
- (HDUIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _callBtn.titleLabel.font = [HDAppTheme.font forSize:13.0];
        [_callBtn setImage:[UIImage imageNamed:@"gn_storeinfo_call"] forState:UIControlStateNormal];
        [_callBtn setTitle:GNLocalizedString(@"gn_store_call", @"拨号") forState:UIControlStateNormal];
        [_callBtn setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
        _callBtn.imagePosition = HDUIButtonImagePositionLeft;
        _callBtn.spacingBetweenImageAndTitle = kRealHeight(5);
        @HDWeakify(self)[_callBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[GNEvent eventResponder:self target:btn key:@"callAction"];
        }];
    }
    return _callBtn;
}

@end
