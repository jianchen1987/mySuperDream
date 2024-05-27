//
//  SAChooseZoneHeaderView.m
//  SuperApp
//
//  Created by Chaos on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAChooseZoneHeaderView.h"
#import "SAAddressZoneModel.h"


@interface SAChooseZoneHeaderView ()

/// 定位图标
@property (nonatomic, strong) UIImageView *locationIV;
/// 定位城市
@property (nonatomic, strong) UILabel *locationLB;
/// 线
@property (nonatomic, strong) UIView *lineView;
/// 热门城市标题
@property (nonatomic, strong) UILabel *hotCityTitleLB;
/// 热门城市
@property (nonatomic, strong) HDFloatLayoutView *cityFloatLayoutView;
/// 选择地区标题
@property (nonatomic, strong) UILabel *chooseZoneTitleLB;

@end


@implementation SAChooseZoneHeaderView

- (void)hd_setupViews {
    [self addSubview:self.locationIV];
    [self addSubview:self.locationLB];
    [self addSubview:self.lineView];
    [self addSubview:self.hotCityTitleLB];
    [self addSubview:self.cityFloatLayoutView];
    [self addSubview:self.chooseZoneTitleLB];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.locationIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self).offset(kRealWidth(20));
        make.size.mas_equalTo(self.locationIV.image.size);
    }];
    [self.locationLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationIV.mas_right).offset(kRealWidth(10));
        make.centerY.equalTo(self.locationIV);
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.locationIV.mas_bottom).offset(kRealWidth(18));
        make.height.mas_equalTo(PixelOne);
    }];
    [self.hotCityTitleLB sizeToFit];
    [self.hotCityTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.hotCityTitleLB.isHidden) {
            make.left.equalTo(self.locationIV);
            make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(15));
            make.size.mas_equalTo(self.hotCityTitleLB.size);
        }
    }];
    [self.cityFloatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.cityFloatLayoutView.isHidden) {
            make.left.equalTo(self.hotCityTitleLB);
            make.top.equalTo(self.hotCityTitleLB.mas_bottom).offset(kRealWidth(5));
            make.centerX.equalTo(self);
            make.size.mas_equalTo([self.cityFloatLayoutView sizeThatFits:CGSizeMake(kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding), MAXFLOAT)]);
        }
    }];
    [self.chooseZoneTitleLB sizeToFit];
    [self.chooseZoneTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationIV);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(self.chooseZoneTitleLB.size);
        if (self.cityFloatLayoutView.isHidden) {
            make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(15));
        } else {
            make.top.equalTo(self.cityFloatLayoutView.mas_bottom).offset(kRealWidth(15));
        }
    }];

    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(0, 0, kScreenWidth, size.height);

    [super updateConstraints];
}

#pragma mark - event response
- (void)clickLocationCityHandler {
    if (HDIsObjectNil(self.locationModel)) {
        return;
    }
    !self.chooseCityBlock ?: self.chooseCityBlock(self.locationModel);
}

- (void)clickHotCityHandler:(UIButton *)button {
    NSInteger index = button.tag;
    if (index >= self.hotCitys.count) {
        return;
    }
    SAAddressZoneModel *model = self.hotCitys[index];
    !self.chooseCityBlock ?: self.chooseCityBlock(model);
}

#pragma mark - setter
- (void)setLocationModel:(SAAddressZoneModel *)locationModel {
    _locationModel = locationModel;
    self.locationLB.text = [NSString stringWithFormat:@"%@ %@", SALocalizedString(@"FIu1dUpO", @"当前定位城市"), locationModel.message.desc];
}

- (void)setHotCitys:(NSArray<SAAddressZoneModel *> *)hotCitys {
    _hotCitys = hotCitys;
    [self.cityFloatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.cityFloatLayoutView.hidden = self.hotCityTitleLB.hidden = HDIsArrayEmpty(hotCitys);
    for (SAAddressZoneModel *zoneModel in hotCitys) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = HDAppTheme.color.G5;
        button.layer.cornerRadius = 5;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(5), kRealWidth(23), kRealWidth(5), kRealWidth(23));
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitle:zoneModel.message.desc forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickHotCityHandler:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = [hotCitys indexOfObject:zoneModel];
        [self.cityFloatLayoutView addSubview:button];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)locationIV {
    if (!_locationIV) {
        _locationIV = UIImageView.new;
        _locationIV.image = [UIImage imageNamed:@"address_icon"];
    }
    return _locationIV;
}
- (UILabel *)locationLB {
    if (!_locationLB) {
        _locationLB = UILabel.new;
        _locationLB.text = SALocalizedString(@"ZErdi1op", @"定位中...");
        _locationLB.textColor = HDAppTheme.color.G1;
        _locationLB.font = HDAppTheme.font.standard3;
        _locationLB.userInteractionEnabled = true;
        [_locationLB addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLocationCityHandler)]];
    }
    return _locationLB;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.color.G4;
    }
    return _lineView;
}
- (UILabel *)hotCityTitleLB {
    if (!_hotCityTitleLB) {
        _hotCityTitleLB = UILabel.new;
        _hotCityTitleLB.text = SALocalizedString(@"5WYTmohJ", @"热门城市");
        _hotCityTitleLB.textColor = HDAppTheme.color.G3;
        _hotCityTitleLB.font = HDAppTheme.font.standard3;
        _hotCityTitleLB.hidden = true;
    }
    return _hotCityTitleLB;
}
- (UILabel *)chooseZoneTitleLB {
    if (!_chooseZoneTitleLB) {
        _chooseZoneTitleLB = UILabel.new;
        _chooseZoneTitleLB.text = SALocalizedString(@"6S5clihu", @"请选择所在地区");
        _chooseZoneTitleLB.textColor = HDAppTheme.color.G3;
        _chooseZoneTitleLB.font = HDAppTheme.font.standard3;
    }
    return _chooseZoneTitleLB;
}
- (HDFloatLayoutView *)cityFloatLayoutView {
    if (!_cityFloatLayoutView) {
        _cityFloatLayoutView = [[HDFloatLayoutView alloc] init];
        _cityFloatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        _cityFloatLayoutView.hidden = true;
    }
    return _cityFloatLayoutView;
}

@end
