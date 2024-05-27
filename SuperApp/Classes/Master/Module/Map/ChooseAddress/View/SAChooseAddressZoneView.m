//
//  SAChooseAreaView.m
//  SuperApp
//
//  Created by Chaos on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAChooseAddressZoneView.h"
#import "SAAddressModel.h"


@interface SAChooseAddressZoneView ()

/// 城市名
@property (nonatomic, strong) SALabel *cityLB;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowIV;

@end


@implementation SAChooseAddressZoneView

- (void)hd_setupViews {
    [self addSubview:self.cityLB];
    [self addSubview:self.arrowIV];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.cityLB sizeToFit];
    [self.cityLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(kRealWidth(8));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(self.cityLB.width);
    }];
    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityLB.mas_right).offset(kRealWidth(5));
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.size.mas_equalTo(self.arrowIV.image.size);
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(SAAddressModel *)model {
    _model = model;
    if (!HDIsObjectNil(model)) {
        self.cityLB.text = HDIsStringEmpty(model.subLocality) ? model.city : model.subLocality;
    } else {
        self.cityLB.text = SALocalizedString(@"Gox2YsVC", @"选择地区");
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SALabel *)cityLB {
    if (!_cityLB) {
        _cityLB = SALabel.new;
        _cityLB.textColor = HDAppTheme.color.G1;
        _cityLB.font = HDAppTheme.font.standard3;
        _cityLB.text = SALocalizedString(@"Gox2YsVC", @"选择地区");
    }
    return _cityLB;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        _arrowIV = UIImageView.new;
        _arrowIV.image = [UIImage imageNamed:@"arrow_down"];
    }
    return _arrowIV;
}

@end
