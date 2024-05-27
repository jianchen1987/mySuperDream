//
//  PNWalletHomeBannerCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWalletHomeBannerCell.h"
#import "PNWalletHomeBannerModel.h"


@interface PNWalletHomeBannerCell ()
@property (nonatomic, strong) UIImageView *bannerImgView;
@end


@implementation PNWalletHomeBannerCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bannerImgView];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.bannerImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-10));
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNWalletHomeBannerModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:model.imgUrl placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(345), kRealWidth(108)) logoWidth:kRealWidth(80)]
                             imageView:self.bannerImgView];

    [self setNeedsFocusUpdate];
}

#pragma mark
- (UIImageView *)bannerImgView {
    if (!_bannerImgView) {
        _bannerImgView = [[UIImageView alloc] init];
        _bannerImgView.userInteractionEnabled = YES;
        _bannerImgView.clipsToBounds = YES;
        _bannerImgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
    }
    return _bannerImgView;
}
@end
