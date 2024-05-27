//
//  GNStroreNoDataCell.m
//  SuperApp
//
//  Created by wmz on 2021/9/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStroreNoDataCell.h"
#import "GNCellModel.h"


@interface GNStroreNoDataCell ()

@property (nonatomic, strong) HDLabel *titleLB;

@property (nonatomic, strong) UIImageView *imageV;

@end


@implementation GNStroreNoDataCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kRealHeight(40));
        make.width.mas_equalTo(230 / 375.0 * 375);
        make.height.mas_equalTo(kRealHeight(154));
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.imageV.mas_bottom).offset(HDAppTheme.value.gn_marginT);
        make.bottom.mas_equalTo(-kRealHeight(74));
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
    }];
    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.imageV.image = data.image;
    self.titleLB.text = data.title;
    self.lineView.hidden = YES;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.numberOfLines = 0;
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = UIImageView.new;
    }
    return _imageV;
}

@end
