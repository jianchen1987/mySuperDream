//
//  CMSThreeImage7x3ScrolledCardCell.m
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSThreeImage7x3ScrolledCardCell.h"
#import "CMSThreeImage7x3ItemConfig.h"

static CGFloat const kStoreImageH2W = 150.0 / 355.0;


@interface CMSThreeImage7x3ScrolledCardCell ()

/// 背景图
@property (nonatomic, strong) UIImageView *storeBgIV;
/// logo
@property (nonatomic, strong) UIImageView *storeLogoIV;
/// 门店名
@property (nonatomic, strong) UILabel *storeNameLB;

@end


@implementation CMSThreeImage7x3ScrolledCardCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.storeBgIV];
    [self.contentView addSubview:self.storeLogoIV];
    [self.contentView addSubview:self.storeNameLB];
}

- (void)updateConstraints {
    [self.storeBgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(kStoreImageH2W);
    }];

    [self.storeLogoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.storeBgIV.mas_right).offset(-kRealWidth(5));
        make.bottom.equalTo(self.storeBgIV.mas_bottom).offset(kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(30), kRealWidth(30)));
    }];

    [self.storeNameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.storeBgIV.mas_bottom).offset(kRealWidth(13));
        make.bottom.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (void)setModel:(CMSThreeImage7x3ItemConfig *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.imageUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(123), kRealWidth(123))] imageView:self.storeBgIV];
    [HDWebImageManager setImageWithURL:model.logoUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(30), kRealWidth(30)) logoWidth:15] imageView:self.storeLogoIV];
    self.storeNameLB.text = model.title;
    self.storeNameLB.textColor = [UIColor hd_colorWithHexString:model.titleColor];
    self.storeNameLB.font = [UIFont systemFontOfSize:model.titleFont];

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
/** @lazy storeBgIV */
- (UIImageView *)storeBgIV {
    if (!_storeBgIV) {
        _storeBgIV = [[UIImageView alloc] init];
        _storeBgIV.contentMode = UIViewContentModeScaleAspectFill;
        _storeBgIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 10;
            view.layer.masksToBounds = YES;
        };
    }
    return _storeBgIV;
}
/** @lazy storelogoIV */
- (UIImageView *)storeLogoIV {
    if (!_storeLogoIV) {
        _storeLogoIV = [[UIImageView alloc] init];
        _storeLogoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 3;
            view.layer.masksToBounds = YES;
            view.layer.borderWidth = 1;
            view.layer.borderColor = UIColor.whiteColor.CGColor;
        };
    }
    return _storeLogoIV;
}
/** @lazy storeNameLB */
- (UILabel *)storeNameLB {
    if (!_storeNameLB) {
        _storeNameLB = [[UILabel alloc] init];
        _storeNameLB.font = HDAppTheme.font.standard3;
        _storeNameLB.textColor = HDAppTheme.color.G1;
        _storeNameLB.numberOfLines = 0;
        _storeNameLB.textAlignment = NSTextAlignmentLeft;
    }
    return _storeNameLB;
}
@end
