//
//  SASocialShareGenerateImageView.m
//  SuperApp
//
//  Created by Chaos on 2021/1/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SASocialShareGenerateImageView.h"


@interface SASocialShareGenerateImageView ()

/// 分享模型
@property (nonatomic, strong) SAShareWebpageObject *shareObject;

/// 顶部视图
@property (nonatomic, strong) UIView *topView;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 顶部logo
@property (nonatomic, strong) UIImageView *topLogoIV;
/// 图片
@property (nonatomic, strong) UIImageView *shareIV;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 底部视图
@property (nonatomic, strong) UIView *bottomView;
/// WOWNOW logo
@property (nonatomic, strong) UIImageView *logoIV;
/// WOWNOW
@property (nonatomic, strong) SALabel *wownowLB;
/// X
@property (nonatomic, strong) UIImageView *andIV;
/// 二维码视图
@property (nonatomic, strong) UIView *qrCodeView;
/// 二维码
@property (nonatomic, strong) UIImageView *qrCodeIV;
/// 长按扫描进入
@property (nonatomic, strong) SALabel *qrCodeTitleLB;

@end


@implementation SASocialShareGenerateImageView

- (instancetype)initWithShareObject:(SAShareWebpageObject *)shareObject {
    if (self = [super init]) {
        self.shareObject = shareObject;
    }
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.topView];
    [self.topView addSubview:self.titleLB];
    [self.topView addSubview:self.topLogoIV];
    [self addSubview:self.shareIV];
    [self addSubview:self.descLB];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.logoIV];
    [self.bottomView addSubview:self.wownowLB];
    [self.bottomView addSubview:self.andIV];
    [self.bottomView addSubview:self.qrCodeView];
    [self.qrCodeView addSubview:self.qrCodeIV];
    [self.bottomView addSubview:self.qrCodeTitleLB];
}

- (void)updateConstraints {
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.width.mas_equalTo(kScreenWidth * 0.85);
        make.height.mas_equalTo(80);
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topView);
        make.left.equalTo(self.topView).offset(kRealWidth(12));
    }];
    [self.topLogoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.topView).offset(kRealWidth(12));
    }];
    [self.shareIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
        if (self.shareIV.image) {
            make.height.equalTo(self.shareIV.mas_width).multipliedBy(self.shareIV.image.size.height / self.shareIV.image.size.width);
        } else {
            make.height.equalTo(self.shareIV.mas_width).multipliedBy(136.0 / 322.0);
        }
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.descLB.hidden) {
            make.centerX.equalTo(self);
            make.left.equalTo(self).offset(kRealWidth(17));
            make.top.equalTo(self.shareIV.mas_bottom).offset(kRealWidth(12));
        }
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        UIView *view = self.descLB.isHidden ? self.shareIV : self.descLB;
        make.centerX.equalTo(self);
        make.top.equalTo(view.mas_bottom).offset(kRealWidth(20));
        make.bottom.equalTo(self).offset(-kRealWidth(22));
    }];
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView);
        make.left.greaterThanOrEqualTo(self.bottomView);
        make.width.height.mas_equalTo(kRealWidth(72));
    }];
    [self.wownowLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoIV);
        make.top.equalTo(self.logoIV.mas_bottom).offset(kRealWidth(4));
        make.bottom.lessThanOrEqualTo(self.bottomView);
        make.left.greaterThanOrEqualTo(self.bottomView);
    }];
    [self.andIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoIV);
        make.left.equalTo(self.logoIV.mas_right).offset(kRealWidth(23));
    }];
    [self.qrCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView);
        make.left.equalTo(self.andIV.mas_right).offset(kRealWidth(23));
        make.width.height.mas_equalTo(kRealWidth(72));
        make.right.lessThanOrEqualTo(self.bottomView);
    }];
    [self.qrCodeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kRealWidth(3), kRealWidth(3), kRealWidth(3), kRealWidth(3)));
    }];
    [self.qrCodeTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrCodeView);
        make.top.equalTo(self.qrCodeView.mas_bottom).offset(kRealWidth(4));
        make.right.lessThanOrEqualTo(self.bottomView);
        make.bottom.lessThanOrEqualTo(self.bottomView);
        make.width.mas_lessThanOrEqualTo(kRealWidth(100));
    }];
    [super updateConstraints];
}

- (void)setShareObject:(SAShareWebpageObject *)shareObject {
    _shareObject = shareObject;

    self.titleLB.text = shareObject.title;
    if ([shareObject.thumbImage isKindOfClass:NSString.class]) {
        [HDWebImageManager setImageWithURL:shareObject.thumbImage placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(322, 136) logoWidth:80] imageView:self.shareIV
                                 completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                     [self setNeedsUpdateConstraints];
                                 }];
    } else {
        self.shareIV.image = shareObject.thumbImage;
    }
    if (HDIsStringEmpty(shareObject.descr)) {
        self.descLB.hidden = true;
    } else {
        self.descLB.text = shareObject.descr;
        self.descLB.hidden = false;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *qrCodeImage = [HDCodeGenerator qrCodeImageForStr:shareObject.webpageUrl size:CGSizeMake(72, 72) level:HDInputCorrectionLevelL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.qrCodeIV.image = qrCodeImage;
        });
    });
    [self setNeedsUpdateConstraints];
}

- (UIImage *)generateImageWithChannel:(SAShareChannel)channel {
    if ([channel isEqualToString:SAShareChannelFacebook] || [channel isEqualToString:SAShareChannelMessenger]) {
        NSString *url = HDIsStringNotEmpty(self.shareObject.facebookWebpageUrl) ? self.shareObject.facebookWebpageUrl : self.shareObject.webpageUrl;
        self.qrCodeIV.image = [HDCodeGenerator qrCodeImageForStr:url size:CGSizeMake(72, 72) level:HDInputCorrectionLevelL];
    }
    return [super generateImageWithChannel:channel];
}

#pragma mark - lazy load
- (UIView *)topView {
    if (!_topView) {
        _topView = UIView.new;
        _topView.backgroundColor = HDAppTheme.color.sa_C1;
    }
    return _topView;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        label.numberOfLines = 2;
        _titleLB = label;
    }
    return _titleLB;
}

- (UIImageView *)topLogoIV {
    if (!_topLogoIV) {
        _topLogoIV = UIImageView.new;
        _topLogoIV.image = [UIImage imageNamed:@"wownow_translucent_logo"];
    }
    return _topLogoIV;
}

- (UIImageView *)shareIV {
    if (!_shareIV) {
        _shareIV = UIImageView.new;
        _shareIV.contentMode = UIViewContentModeScaleAspectFill;
        _shareIV.layer.masksToBounds = true;
    }
    return _shareIV;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.G1;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 2;
        _descLB = label;
    }
    return _descLB;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
    }
    return _bottomView;
}

- (UIImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = UIImageView.new;
        _logoIV.image = [UIImage imageNamed:@"pn_wownow"];
        _logoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _logoIV;
}

- (SALabel *)wownowLB {
    if (!_wownowLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.sa_C1;
        label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        label.text = SALocalizedString(@"zVW93gJW", @"WOWNOW");
        _wownowLB = label;
    }
    return _wownowLB;
}

- (UIImageView *)andIV {
    if (!_andIV) {
        _andIV = UIImageView.new;
        _andIV.image = [UIImage imageNamed:@"share_and"];
    }
    return _andIV;
}

- (UIView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = UIView.new;
        _qrCodeView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8 borderWidth:1 borderColor:HDAppTheme.color.sa_C1];
        };
    }
    return _qrCodeView;
}

- (UIImageView *)qrCodeIV {
    if (!_qrCodeIV) {
        _qrCodeIV = UIImageView.new;
    }
    return _qrCodeIV;
}

- (SALabel *)qrCodeTitleLB {
    if (!_qrCodeTitleLB) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.color.sa_C1;
        label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        label.text = SALocalizedString(@"XBJcpM9Z", @"长按扫描进入");
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _qrCodeTitleLB = label;
    }
    return _qrCodeTitleLB;
}

@end
