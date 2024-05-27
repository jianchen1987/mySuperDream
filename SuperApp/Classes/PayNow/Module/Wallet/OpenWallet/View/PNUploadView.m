//
//  PNUploadView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUploadView.h"
#import "PNWalletUploadImageItemView.h"


@interface PNUploadView ()
@property (nonatomic, strong) UIImageView *tipsIconImgView;
@property (nonatomic, strong) SALabel *tipsLabel;
@property (nonatomic, strong) SALabel *bottomTipsLabel;

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, strong) PNWalletUploadImageItemView *demo1View;
@property (nonatomic, strong) PNWalletUploadImageItemView *demo2View;
@property (nonatomic, strong) PNWalletUploadImageItemView *uploadView;
@end


@implementation PNUploadView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.tipsIconImgView];
    [self.scrollViewContainer addSubview:self.tipsLabel];
    [self.scrollViewContainer addSubview:self.bottomTipsLabel];

    /// 距离左边 距离右边  两张图片之间 的间距都是15
    self.imageWidth = (kScreenWidth - (kRealWidth(15) * 3)) / 2.f;
    [self.scrollViewContainer addSubview:self.demo1View];
    [self.scrollViewContainer addSubview:self.demo2View];
    [self.scrollViewContainer addSubview:self.uploadView];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.tipsIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.tipsIconImgView.image.size);
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(18));
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipsIconImgView.mas_right).offset(kRealWidth(5));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(16));
    }];

    /**
     目前只有 只有两种布局样式
     */

    [self.demo1View mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.demoArray.count == 1) {
            make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(15));
            make.width.equalTo(@(self.imageWidth));
            make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(15));
        } else {
            make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
            make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(15));
            make.width.equalTo(@(self.imageWidth));
        }
    }];

    if (!self.demo2View.hidden) {
        [self.demo2View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(15));
            make.width.equalTo(@(self.imageWidth));
            make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(15));
        }];
    }

    [self.uploadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.demoArray.count <= 1) {
            make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
            make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(15));
            make.width.equalTo(@(self.imageWidth));
        } else {
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
            make.width.equalTo(@(self.imageWidth));
            make.top.mas_equalTo(self.demo1View.mas_bottom).offset(kRealWidth(15));
        }
    }];

    [self.bottomTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));

        make.top.mas_equalTo(self.uploadView.mas_bottom).offset(kRealWidth(30));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setDemoArray:(NSMutableArray *)demoArray {
    _demoArray = demoArray;

    ///目前示例照最多两个
    if (_demoArray.count == 1) {
        self.demo1View.hidden = NO;
        self.demo1View.title = PNLocalizedString(@"Sample", @"拍照示例");
        self.demo1View.placeholderImage = [UIImage imageNamed:_demoArray[0]];
    } else if (_demoArray.count == 2) {
        self.demo1View.hidden = NO;
        self.demo2View.hidden = NO;

        self.demo1View.placeholderImage = [UIImage imageNamed:_demoArray[0]];
        self.demo2View.placeholderImage = [UIImage imageNamed:_demoArray[1]];

        self.demo1View.title = PNLocalizedString(@"Sample", @"拍照示例");
        self.demo2View.title = PNLocalizedString(@"Sample", @"拍照示例");
    }

    [self setNeedsUpdateConstraints];
}

- (void)setViewType:(PNUploadImageType)viewType {
    _viewType = viewType;

    if (self.viewType == PNUploadImageType_Avatar) {
        self.tipsLabel.text = PNLocalizedString(@"nbc_upload_photo_tips", @"根据NBC要求，请上传您本人照片，仅用于身份验证，CoolCash保障您的信息安全。");
        self.bottomTipsLabel.text = [NSString stringWithFormat:@"%@\n%@", PNLocalizedString(@"Photo_format", @"照片格式：PNG/JPEG/GIF"), PNLocalizedString(@"Photo_size", @"照片大小：最大5M")];
        self.uploadView.needCrop = YES;
        self.uploadView.cropMode = SAImageCropModeSquare;
    } else {
        self.tipsLabel.text = PNLocalizedString(@"nbc_upload_photo_in_hand_tips", @"请您手持证件拍照，确保手持的证件与已上传的证件一致，确保您的头像与证件信息清晰可见。");
        self.bottomTipsLabel.text = PNLocalizedString(@"photo_only_security", @"照片信息仅用于身份验证，Coolcash保障您的信息安全。");
        self.uploadView.needCrop = NO;
    }

    [self.uploadView setImageView:self.imageURLStr];
}
#pragma mark
- (UIImageView *)tipsIconImgView {
    if (!_tipsIconImgView) {
        _tipsIconImgView = [[UIImageView alloc] init];
        _tipsIconImgView.image = [UIImage imageNamed:@"pn_tips_info_icon"];
    }
    return _tipsIconImgView;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[SALabel alloc] init];
        _tipsLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        _tipsLabel.font = HDAppTheme.PayNowFont.standard12;
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}

- (SALabel *)bottomTipsLabel {
    if (!_bottomTipsLabel) {
        _bottomTipsLabel = [[SALabel alloc] init];
        _bottomTipsLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        _bottomTipsLabel.font = HDAppTheme.PayNowFont.standard12;
        _bottomTipsLabel.numberOfLines = 0;
    }
    return _bottomTipsLabel;
}

- (PNWalletUploadImageItemView *)uploadView {
    if (!_uploadView) {
        _uploadView = [[PNWalletUploadImageItemView alloc] init];
        _uploadView.onlyShow = NO;
        _uploadView.placeholderImage = [UIImage imageNamed:@"pn_photo_add"];
        _uploadView.title = PNLocalizedString(@"Photo_legal_in_hand", @"手持证件照");

        @HDWeakify(self);
        _uploadView.buttonEnableBlock = ^(BOOL enabled, NSString *_Nonnull imageURL) {
            @HDStrongify(self);
            self.imageURLStr = imageURL;
            !self.buttonEnableBlock ?: self.buttonEnableBlock(enabled, imageURL);
        };
    }
    return _uploadView;
}

- (PNWalletUploadImageItemView *)demo1View {
    if (!_demo1View) {
        _demo1View = [[PNWalletUploadImageItemView alloc] init];
        _demo1View.hidden = YES;
        _demo1View.onlyShow = YES;
    }
    return _demo1View;
}

- (PNWalletUploadImageItemView *)demo2View {
    if (!_demo2View) {
        _demo2View = [[PNWalletUploadImageItemView alloc] init];
        _demo2View.hidden = YES;
        _demo2View.onlyShow = YES;
    }
    return _demo2View;
}

@end
