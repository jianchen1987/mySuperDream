//
//  GNStoreDetailTimeTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreDetailTimeTableViewCell.h"


@interface GNStoreDetailTimeTableViewCell ()
/// 箭头
@property (nonatomic, strong) HDUIButton *rightBtn;
/// 左边图标
@property (nonatomic, strong) UIImageView *leftIV;
/// 文本
@property (nonatomic, strong) HDLabel *addressLB;

@end


@implementation GNStoreDetailTimeTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.leftIV];
    [self.contentView addSubview:self.addressLB];
}

- (void)updateConstraints {
    [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(15), kRealWidth(15)));
        make.right.mas_offset(-HDAppTheme.value.gn_marginL);
    }];

    [self.leftIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(HDAppTheme.value.gn_marginL);
        make.size.mas_equalTo(CGSizeMake(kRealHeight(20), kRealHeight(20)));
        make.centerY.mas_offset(0);
    }];

    [self.addressLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftIV.mas_right).offset(HDAppTheme.value.gn_offset);
        make.top.mas_offset(kRealHeight(15));
        make.right.equalTo(self.rightBtn.mas_left).offset(-HDAppTheme.value.gn_marginL);
        make.bottom.mas_offset(-kRealHeight(15));
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.addressLB.text = HDIsStringNotEmpty(data.title) ? data.title : @"";
    self.addressLB.numberOfLines = data.numOfLines;
    self.leftIV.image = data.image ?: [UIImage imageNamed:@"gn_store_time"];
    self.lineView.hidden = data.lineHidden;
    self.rightBtn.hidden = data.lineHidden;
}

- (HDLabel *)addressLB {
    if (!_addressLB) {
        _addressLB = HDLabel.new;
        _addressLB.numberOfLines = 0;
        _addressLB.font = [HDAppTheme.font gn_12];
    }
    return _addressLB;
}

- (UIImageView *)leftIV {
    if (!_leftIV) {
        _leftIV = UIImageView.new;
    }
    return _leftIV;
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"gn_order_more"] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r = [[HDSkeletonLayer alloc] init];
    [r hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kRealHeight(30));
        make.height.hd_equalTo(kRealHeight(30));
        make.top.hd_equalTo(kRealHeight(15));
        make.left.hd_equalTo(HDAppTheme.value.gn_marginL);
    }];
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_width - HDAppTheme.value.gn_marginL * 2);
        make.height.hd_equalTo(kRealHeight(30));
        make.top.hd_equalTo(kRealHeight(15));
        make.left.hd_equalTo(r.hd_right + HDAppTheme.value.gn_marginL);
    }];
    return @[r, r0];
}

+ (CGFloat)skeletonViewHeight {
    return kRealHeight(60);
}

@end
