//
//  WMStoreProductCellStoreInfoView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductCellStoreInfoView.h"


@interface WMStoreProductCellStoreInfoView ()
/// 门店图片
@property (nonatomic, strong) UIImageView *storeImageView;
/// 门店信息右边容器
@property (nonatomic, strong) UIView *storeInfoRightContainer;
/// 名称
@property (nonatomic, strong) SALabel *storeNameLabel;
/// 门店品类
@property (nonatomic, strong) SALabel *storeDescLabel;
@end


@implementation WMStoreProductCellStoreInfoView

#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.storeImageView];
    [self addSubview:self.storeInfoRightContainer];
    [self addSubview:self.storeNameLabel];
    [self addSubview:self.storeDescLabel];

    self.backgroundColor = HDAppTheme.color.G5;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:5];
    };
    self.storeImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:5];
    };
}

#pragma mark - public methods
- (void)updateStoreImageWithImageURL:(NSString *)imageURL storeName:(NSString *)storeName storeDesc:(NSString *)storeDesc {
    self.storeImageView.hidden = HDIsStringEmpty(imageURL);
    if (!self.storeImageView.isHidden) {
        [HDWebImageManager setImageWithURL:imageURL placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(70, 54)] imageView:self.storeImageView];
    }
    self.storeNameLabel.text = storeName;
    self.storeDescLabel.hidden = HDIsStringEmpty(storeDesc);
    if (!self.storeDescLabel.isHidden) {
        self.storeDescLabel.text = storeDesc;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.storeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeImageView.isHidden) {
            make.left.equalTo(self).offset(kRealWidth(5));
            make.width.mas_equalTo(kRealWidth(71));
            make.height.equalTo(self.storeImageView.mas_width).multipliedBy(54 / 71.0);
            make.centerY.equalTo(self);
            make.top.greaterThanOrEqualTo(self).offset(kRealWidth(5));
        }
    }];

    [self.storeInfoRightContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeNameLabel);
        if (self.storeDescLabel.isHidden) {
            make.bottom.equalTo(self.storeNameLabel);
        } else {
            make.bottom.equalTo(self.storeDescLabel);
        }
        make.right.equalTo(self);
        if (self.storeImageView.isHidden) {
            make.left.equalTo(self).offset(kRealWidth(10));
        } else {
            make.left.equalTo(self.storeImageView.mas_right).offset(kRealWidth(10));
        }
        make.centerY.equalTo(self);
    }];

    [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self).offset(kRealWidth(10));
        make.left.equalTo(self.storeInfoRightContainer);
        make.right.equalTo(self.storeInfoRightContainer).offset(-kRealWidth(10));
        if (self.storeDescLabel.isHidden) {
            make.bottom.equalTo(self).offset(-kRealWidth(10));
        }
    }];

    [self.storeDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeDescLabel.isHidden) {
            make.left.equalTo(self.storeInfoRightContainer);
            make.right.equalTo(self.storeInfoRightContainer).offset(-kRealWidth(10));
            make.top.equalTo(self.storeNameLabel.mas_bottom).offset(3);
            make.bottom.lessThanOrEqualTo(self).offset(-kRealWidth(10));
        }
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)storeImageView {
    if (!_storeImageView) {
        _storeImageView = UIImageView.new;
        _storeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _storeImageView.clipsToBounds = true;
    }
    return _storeImageView;
}

- (UIView *)storeInfoRightContainer {
    if (!_storeInfoRightContainer) {
        _storeInfoRightContainer = UIView.new;
    }
    return _storeInfoRightContainer;
}

- (SALabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = ({
            SALabel *label = SALabel.new;
            label.textColor = HDAppTheme.color.G1;
            label.font = HDAppTheme.font.standard3;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.numberOfLines = 1;
            label;
        });
    }
    return _storeNameLabel;
}

- (SALabel *)storeDescLabel {
    if (!_storeDescLabel) {
        _storeDescLabel = ({
            SALabel *label = SALabel.new;
            label.textColor = HDAppTheme.color.G3;
            label.font = HDAppTheme.font.standard5;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.numberOfLines = 1;
            label;
        });
    }
    return _storeDescLabel;
}
@end
