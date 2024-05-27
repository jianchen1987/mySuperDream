//
//  SAAddOrModifyAddressLocationView.m
//  SuperApp
//
//  Created by Chaos on 2021/3/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressLocationView.h"
#import "SAAddressModel.h"
#import "SAAddressZoneModel.h"
#import "SAChooseZoneDTO.h"


@interface SAAddOrModifyAddressLocationView ()

/// 短地址
@property (nonatomic, strong) SALabel *shortNameLB;
/// 详细地址
@property (nonatomic, strong) SALabel *addressLB;
/// 定位view
@property (nonatomic, strong) UIView *locationView;
/// 定位图标
@property (nonatomic, strong) UIImageView *locationIV;
/// 使用当前定位
@property (nonatomic, strong) SALabel *locationLB;
/// DTO
@property (nonatomic, strong) SAChooseZoneDTO *zoneDTO;

@end


@implementation SAAddOrModifyAddressLocationView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLocationViewHandler)]];
    [self addSubview:self.shortNameLB];
    [self addSubview:self.addressLB];
    [self addSubview:self.locationView];
    [self.locationView addSubview:self.locationIV];
    [self.locationView addSubview:self.locationLB];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.shortNameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self).offset(kRealWidth(12));
        make.centerX.equalTo(self);
    }];
    [self.addressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.shortNameLB);
        make.top.equalTo(self.shortNameLB.mas_bottom).offset(kRealWidth(9));
    }];
    [self.locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.addressLB.mas_bottom).offset(kRealWidth(15));
        make.bottom.equalTo(self).offset(-kRealWidth(15));
    }];
    [self.locationIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationView);
        make.centerY.equalTo(self.locationView);
        make.top.greaterThanOrEqualTo(self.locationView);
        make.bottom.lessThanOrEqualTo(self.locationView);
    }];
    [self.locationLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationIV.mas_right).offset(kRealWidth(5));
        make.right.equalTo(self.locationView);
        make.centerY.equalTo(self.locationView);
        make.top.greaterThanOrEqualTo(self.locationView);
        make.bottom.lessThanOrEqualTo(self.locationView);
    }];
    [super updateConstraints];
}

#pragma mark - event response
- (void)clickLocationViewHandler {
    [self showloading];
    @HDWeakify(self);
    [self.zoneDTO fuzzyQueryZoneListWithProvince:self.addressModel.city district:self.addressModel.subLocality commune:nil latitude:self.addressModel.lat longitude:self.addressModel.lon
        success:^(SAAddressZoneModel *_Nonnull zoneModel) {
            @HDStrongify(self);
            [self dismissLoading];
            [self parseAddressZoneModel:zoneModel];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
            HDLog(@"获取地址编码失败");
        }];
}

#pragma mark - private methods
- (void)parseAddressZoneModel:(SAAddressZoneModel *)addressZoneModel {
    if (HDIsObjectNil(addressZoneModel)) {
        HDLog(@"获取地址编码失败");
        return;
    }
    SAAddressZoneModel *currentZoneModel = addressZoneModel;
    while (!HDIsObjectNil(currentZoneModel)) {
        if (currentZoneModel.zlevel == SAAddressZoneLevelProvince) {
            self.addressModel.provinceCode = currentZoneModel.code;
        } else if (currentZoneModel.zlevel == SAAddressZoneLevelDistrict) {
            self.addressModel.districtCode = currentZoneModel.code;
        }
        currentZoneModel = currentZoneModel.children.firstObject;
    }
    !self.chooseLocationAddress ?: self.chooseLocationAddress(self.addressModel);
}

#pragma mark - setter
- (void)setAddressModel:(SAAddressModel *)addressModel {
    _addressModel = addressModel;

    self.shortNameLB.text = addressModel.shortName;
    self.addressLB.text = addressModel.fullAddress;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SALabel *)shortNameLB {
    if (!_shortNameLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.G1;
        label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _shortNameLB = label;
    }
    return _shortNameLB;
}
- (SALabel *)addressLB {
    if (!_addressLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.G1;
        label.font = HDAppTheme.font.standard3;
        _addressLB = label;
    }
    return _addressLB;
}
- (UIView *)locationView {
    if (!_locationView) {
        _locationView = UIView.new;
    }
    return _locationView;
}
- (UIImageView *)locationIV {
    if (!_locationIV) {
        _locationIV = UIImageView.new;
        _locationIV.image = [UIImage imageNamed:@"ic_complete_address"];
    }
    return _locationIV;
}
- (SALabel *)locationLB {
    if (!_locationLB) {
        SALabel *label = SALabel.new;
        label.text = SALocalizedString(@"vqbvbYvq", @"使用当前定位");
        label.textColor = HDAppTheme.color.C1;
        label.font = HDAppTheme.font.standard4;
        _locationLB = label;
    }
    return _locationLB;
}
- (SAChooseZoneDTO *)zoneDTO {
    if (!_zoneDTO) {
        _zoneDTO = SAChooseZoneDTO.new;
    }
    return _zoneDTO;
}

@end
