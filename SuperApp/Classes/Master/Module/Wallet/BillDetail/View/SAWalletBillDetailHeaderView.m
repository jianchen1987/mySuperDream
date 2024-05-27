//
//  SAWalletBillDetailHeaderView.m
//  SuperApp
//
//  Created by VanJay on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletBillDetailHeaderView.h"


@interface SAWalletBillDetailHeaderView ()
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
@end


@implementation SAWalletBillDetailHeaderView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.titleLB];
    [self addSubview:self.descLB];
}

#pragma mark - public methods
- (void)updateTitle:(NSString *)title desc:(NSString *)desc {
    self.titleLB.text = title;
    self.descLB.text = desc;
    if ([desc hasPrefix:@"+"]) {
        self.descLB.textColor = [UIColor hd_colorWithHexString:@"#FD7127"];
    } else {
        self.descLB.textColor = [UIColor hd_colorWithHexString:@"#343B4D"];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(30));
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.equalTo(self);
    }];

    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(10));
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kRealWidth(15));
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:30];
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _descLB = label;
    }
    return _descLB;
}
@end
