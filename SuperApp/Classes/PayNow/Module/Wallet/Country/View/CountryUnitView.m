//
//  CountryUnitView.m
//  customer
//
//  Created by 谢 on 2019/1/4.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "CountryUnitView.h"
#import "CountryModel.h"
#import "HDAppTheme.h"
#import "Masonry.h"


@interface CountryUnitView ()
@property (nonatomic, strong) UILabel *nameLB; ///< 名称
@end


@implementation CountryUnitView
#pragma mark - life cycle
- (void)commonInit {
    _nameLB = [[UILabel alloc] init];
    _nameLB.textColor = UIColor.whiteColor;
    _nameLB.font = HDAppTheme.PayNowFont.standard15;
    _nameLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLB];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(5);
    }];
}

#pragma mark - getters and setters
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;

    if (isSelected) {
        self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    } else {
        self.backgroundColor = [UIColor hd_colorWithHexString:@"#ACACAC"];
    }
}

- (void)setModel:(CountryModel *)model {
    _model = model;

    _nameLB.text = model.countryName;

    [self setNeedsUpdateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (_isSelected) {
        self.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    } else {
        self.backgroundColor = [UIColor hd_colorWithHexString:@"#ACACAC"];
    }

    [self setRoundedCorners:UIRectCornerAllCorners radius:self.height * 0.5];
}
@end
