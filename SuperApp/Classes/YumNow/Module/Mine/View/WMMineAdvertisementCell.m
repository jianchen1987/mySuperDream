//
//  WMMineAdvertisementCell.m
//  SuperApp
//
//  Created by Chaos on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMMineAdvertisementCell.h"
#import "SAWindowItemModel.h"
#import "WMMineAdvertisementModel.h"


@interface WMMineAdvertisementCell ()

/// 图标
@property (nonatomic, strong) UIImageView *iconView;
/// 高宽比
@property (nonatomic, assign) CGFloat advertisementHeight2WidthScale;

@end


@implementation WMMineAdvertisementCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconView];
}

- (void)updateConstraints {
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(self.advertisementHeight2WidthScale);
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
    }];

    [super updateConstraints];
}

- (void)setModel:(WMMineAdvertisementModel *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:self.model.model.bannerUrl placeholderImage:nil imageView:self.iconView];
    self.advertisementHeight2WidthScale = self.model.advertisementHeight2WidthScale;

    [self setNeedsUpdateConstraints];
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
    }
    return _iconView;
}

@end
