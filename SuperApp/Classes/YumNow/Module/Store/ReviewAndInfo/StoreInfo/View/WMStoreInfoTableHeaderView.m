//
//  WMStoreInfoTableHeaderView.m
//  SuperApp
//
//  Created by Chaos on 2020/6/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreInfoTableHeaderView.h"
#import "WMPromotionLabel.h"
#import "WMStoreDetailRspModel.h"
#import <YYText.h>

/// viewModel
#import "WMStoreInfoViewModel.h"


@interface WMStoreInfoTableHeaderView ()

/// 头像
@property (nonatomic, strong) UIImageView *iconView;
/// 名称
@property (nonatomic, strong) SALabel *nameLabel;
/// 评分
@property (nonatomic, strong) YYLabel *reviewsLabel;
/// 距离和配送
@property (nonatomic, strong) YYLabel *distanceAndDeliveryLabel;
/// 门店头像边框图层
@property (nonatomic, strong) CAShapeLayer *storeIVBorderLayer;
/// 极速服务标签
@property (nonatomic, strong) WMUIButton *fastServiceBTN;
@end


@implementation WMStoreInfoTableHeaderView

- (void)hd_setupViews {
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.reviewsLabel];
    [self addSubview:self.distanceAndDeliveryLabel];
    [self addSubview:self.fastServiceBTN];

    @HDWeakify(self);
    self.iconView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.storeIVBorderLayer) {
            [self.storeIVBorderLayer removeFromSuperlayer];
            self.storeIVBorderLayer = nil;
        }
        self.storeIVBorderLayer = [view setRoundedCorners:UIRectCornerAllCorners radius:3 borderWidth:1 borderColor:HDAppTheme.color.G4];
    };
}

- (void)updateConstraints {
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kRealHeight(20));
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.width.height.mas_equalTo(kRealHeight(50));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.left.equalTo(self.iconView.mas_right).offset(kRealWidth(7));
        make.right.lessThanOrEqualTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
    }];

    [self.reviewsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealHeight(6));
    }];

    [self.distanceAndDeliveryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.iconView.mas_bottom).offset(kRealHeight(9));
        make.top.greaterThanOrEqualTo(self.reviewsLabel.mas_bottom).offset(kRealHeight(9));
        make.left.equalTo(self.iconView.mas_left);
    }];

    [self.fastServiceBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceAndDeliveryLabel);
        make.left.equalTo(self.distanceAndDeliveryLabel.mas_right).offset(kRealWidth(10));
        make.bottom.equalTo(self.mas_bottom);
    }];

    [super updateConstraints];
}

- (void)setViewModel:(WMStoreInfoViewModel *)viewModel {
    _viewModel = viewModel;

    [HDWebImageManager setImageWithURL:self.viewModel.iconUrl placeholderImage:HDHelper.circlePlaceholderImage imageView:self.iconView];
    self.nameLabel.text = self.viewModel.name;
    self.reviewsLabel.attributedText = self.viewModel.reviewsDesc;
    NSMutableAttributedString *delyStr = NSMutableAttributedString.new;
    [delyStr appendAttributedString:self.viewModel.discountAndDelievry];
    if (viewModel.repModel.slowPayMark.boolValue) {
        WMUIButton *fastBTN = [WMPromotionLabel createFastServiceBtn];
        NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                          attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                             alignToFont:[UIFont systemFontOfSize:0]
                                                                                               alignment:YYTextVerticalAlignmentCenter];
        [delyStr appendAttributedString:spaceText];
        NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:fastBTN contentMode:UIViewContentModeCenter attachmentSize:fastBTN.frame.size
                                                                                          alignToFont:fastBTN.titleLabel.font
                                                                                            alignment:YYTextVerticalAlignmentCenter];
        [delyStr appendAttributedString:objStr];
    }
    self.distanceAndDeliveryLabel.attributedText = delyStr;
    self.fastServiceBTN.hidden = YES;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.layer.masksToBounds = YES;
        _iconView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5.f];
        };
    }
    return _iconView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[SALabel alloc] init];
        _nameLabel.textColor = HDAppTheme.color.G1;
        _nameLabel.font = HDAppTheme.font.standard1Bold;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (YYLabel *)reviewsLabel {
    if (!_reviewsLabel) {
        _reviewsLabel = [[YYLabel alloc] init];
        _reviewsLabel.numberOfLines = 0;
    }
    return _reviewsLabel;
}

- (YYLabel *)distanceAndDeliveryLabel {
    if (!_distanceAndDeliveryLabel) {
        _distanceAndDeliveryLabel = [[YYLabel alloc] init];
        _distanceAndDeliveryLabel.numberOfLines = 0;
    }
    return _distanceAndDeliveryLabel;
}

- (WMUIButton *)fastServiceBTN {
    if (!_fastServiceBTN) {
        _fastServiceBTN = [WMPromotionLabel createFastServiceBtn];
    }
    return _fastServiceBTN;
}

@end
