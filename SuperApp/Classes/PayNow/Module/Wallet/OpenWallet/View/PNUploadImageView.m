//
//  PNUploadImageView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNUploadImageView.h"
#import "PNUploadImageDTO.h"
#import "SAImageAccessor.h"


@interface PNUploadImageView () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat imageWidth;

@property (nonatomic, strong) UIImageView *tipsIconImgView;
@property (nonatomic, strong) SALabel *tipsLabel;
@property (nonatomic, strong) SALabel *leftTitleLabel;
@property (nonatomic, strong) SALabel *rightTitleLabel;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) HDUIButton *deleteBtn;
@property (nonatomic, strong) SALabel *photoFormatLabel;
@property (nonatomic, strong) SALabel *photoSizeLabel;

@property (nonatomic, strong) SAImageAccessor *imageAccessor;
/// 上传图片 VM
@property (nonatomic, strong) PNUploadImageDTO *uploadImageDTO;
@end


@implementation PNUploadImageView

- (void)hd_setupViews {
    /// 距离左边 距离右边  两张图片之间 的间距都是15
    self.imageWidth = (kScreenWidth - (kRealWidth(15) * 3)) / 2.f;
    [self removeGestureRecognizer:self.hd_tapRecognizer];
    [self addSubview:self.tipsIconImgView];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.leftTitleLabel];
    [self addSubview:self.leftImgView];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.rightTitleLabel];
    [self addSubview:self.rightImgView];
    [self addSubview:self.photoFormatLabel];
    [self addSubview:self.photoSizeLabel];
}

- (void)updateConstraints {
    [self.tipsIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.tipsIconImgView.image.size);
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(18));
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipsIconImgView.mas_right).offset(kRealWidth(5));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
    }];

    [self.leftTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(15));
        make.right.mas_equalTo(self.leftImgView.mas_right);
    }];

    [self.leftImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.size.mas_equalTo(@(CGSizeMake(self.imageWidth, self.imageWidth)));
        make.top.mas_equalTo(self.leftTitleLabel.mas_bottom).offset(kRealWidth(10));
    }];

    [self.rightImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImgView.mas_right).offset(kRealWidth(15));
        make.size.mas_equalTo(@(CGSizeMake(self.imageWidth, self.imageWidth)));
        make.top.mas_equalTo(self.leftImgView.mas_top);
    }];

    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.deleteBtn.imageView.image.size);
        make.top.mas_equalTo(self.leftImgView.mas_top);
        make.right.mas_equalTo(self.leftImgView.mas_right);
    }];

    [self.rightTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightImgView.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.leftTitleLabel.mas_top);
    }];

    if (!self.photoFormatLabel.hidden) {
        [self.photoFormatLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
            make.top.mas_equalTo(self.leftImgView.mas_bottom).offset(kRealWidth(15));
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        }];
    }

    [self.photoSizeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.photoFormatLabel.mas_bottom).offset(kRealWidth(10));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setViewType:(PNUploadImageType)viewType {
    _viewType = viewType;
    if (viewType == PNUploadImageType_Avatar) {
        self.leftTitleLabel.text = PNLocalizedString(@"User_Photo", @"用户照片");
        self.rightImgView.image = [UIImage imageNamed:@"pn_user_avater_demo"];
        self.rightTitleLabel.text = PNLocalizedString(@"Sample", @"拍照示例");
        self.tipsLabel.text = PNLocalizedString(@"nbc_upload_photo_tips", @"根据NBC要求，请上传您本人照片，仅用于身份验证，CoolCash保障您的信息安全。");
        self.photoFormatLabel.text = PNLocalizedString(@"Photo_format", @"照片格式：PNG/JPEG/GIF");
        self.photoSizeLabel.text = PNLocalizedString(@"Photo_size", @"照片大小：最大5M");
    } else {
        self.leftTitleLabel.text = PNLocalizedString(@"Photo_legal_in_hand", @"手持证件照");
        self.rightImgView.image = [UIImage imageNamed:@"pn_user_in_hand_demo"];
        self.rightTitleLabel.text = PNLocalizedString(@"Sample", @"拍照示例");
        self.tipsLabel.text = PNLocalizedString(@"nbc_upload_photo_in_hand_tips", @"请您手持证件拍照，确保手持的证件与已上传的证件一致，确保您的头像与证件信息清晰可见。");
        self.photoFormatLabel.text = @"";
        self.photoSizeLabel.text = PNLocalizedString(@"photo_only_security", @"照片信息仅用于身份验证，Coolcash保障您的信息安全。");
    }
    [self setNeedsUpdateConstraints];
}

- (void)setLeftImageURLStr:(NSString *)leftImageURLStr {
    _leftImageURLStr = leftImageURLStr;
    if (WJIsStringNotEmpty(leftImageURLStr)) {
        self.deleteBtn.hidden = NO;
        [HDWebImageManager setImageWithURL:self.leftImageURLStr placeholderImage:nil imageView:self.leftImgView];
        !self.buttonEnableBlock ?: self.buttonEnableBlock(YES);
    } else {
        self.deleteBtn.hidden = YES;
        self.leftImgView.image = [UIImage imageNamed:@"pn_photo_add"];
        !self.buttonEnableBlock ?: self.buttonEnableBlock(NO);
    }
}

#pragma mark
- (void)handlerChooseHeadImage {
    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    SAImageAccessorCompletionBlock block = ^(UIImage *_Nullable image, NSError *_Nullable error) {
        if (image) {
            [self uploadImage:image];
        }
    };

    // clang-format off
    HDActionSheetViewButton *takePhotoBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Take_photo", @"立即拍照") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        
        if (self.viewType == PNUploadImageType_Avatar) {
            // 用户头像
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto cropMode:SAImageCropModeSquare completion:block];
        } else {
            // 手持
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto needCrop:NO completion:block];
        }
    }];
    HDActionSheetViewButton *chooseImageBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Upload_from_gallery", @"从相册上传") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        if (self.viewType == PNUploadImageType_Avatar) {
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos cropMode:SAImageCropModeSquare completion:block];
        } else {
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos needCrop:NO completion:block];
        }
    }];
    // clang-format on
    [sheetView addButtons:@[takePhotoBTN, chooseImageBTN]];
    [sheetView show];
}

- (void)uploadImage:(UIImage *)image {
    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self];

    [self.uploadImageDTO uploadImages:@[image] progress:^(NSProgress *_Nonnull progress) {
        hd_dispatch_main_async_safe(^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray<NSString *> *_Nonnull imageURLArray) {
        hd_dispatch_main_async_safe(^{
            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            if (imageURLArray.count > 0) {
                HDLog(@"结果：%@", imageURLArray.firstObject);
                self.leftImageURLStr = imageURLArray.firstObject;
            }
        });
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        HDLog(@"上传失败error: %@", error);
        [hud hideAnimated:true];
    }];
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
        _tipsLabel.userInteractionEnabled = YES;
    }
    return _tipsLabel;
}

- (SALabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        _leftTitleLabel = [[SALabel alloc] init];
        _leftTitleLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _leftTitleLabel.font = HDAppTheme.PayNowFont.standard15B;
        _leftTitleLabel.numberOfLines = 0;
    }
    return _leftTitleLabel;
}

- (UIImageView *)leftImgView {
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.userInteractionEnabled = YES;
        _leftImgView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImgView.image = [UIImage imageNamed:@"pn_photo_add"];
        _leftImgView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerChooseHeadImage)];
        tap.delegate = self;
        [_leftImgView addGestureRecognizer:tap];
    }
    return _leftImgView;
}

- (SALabel *)rightTitleLabel {
    if (!_rightTitleLabel) {
        _rightTitleLabel = [[SALabel alloc] init];
        _rightTitleLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _rightTitleLabel.font = HDAppTheme.PayNowFont.standard15B;
        _rightTitleLabel.numberOfLines = 0;
    }
    return _rightTitleLabel;
}

- (UIImageView *)rightImgView {
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImgView.clipsToBounds = YES;
    }
    return _rightImgView;
}

- (SALabel *)photoFormatLabel {
    if (!_photoFormatLabel) {
        _photoFormatLabel = [[SALabel alloc] init];
        _photoFormatLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        _photoFormatLabel.font = HDAppTheme.PayNowFont.standard12;
        _photoFormatLabel.numberOfLines = 0;
    }
    return _photoFormatLabel;
}

- (SALabel *)photoSizeLabel {
    if (!_photoSizeLabel) {
        _photoSizeLabel = [[SALabel alloc] init];
        _photoSizeLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        _photoSizeLabel.font = HDAppTheme.PayNowFont.standard12;
        _photoSizeLabel.numberOfLines = 0;
    }
    return _photoSizeLabel;
}

- (HDUIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.hidden = YES;
        [_deleteBtn setImage:[UIImage imageNamed:@"pn_photo_delete_icon"] forState:0];
        @HDWeakify(self);
        [_deleteBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            self.leftImageURLStr = @"";
        }];
    }
    return _deleteBtn;
}

- (SAImageAccessor *)imageAccessor {
    return _imageAccessor ?: ({ _imageAccessor = [[SAImageAccessor alloc] initWithSourceViewController:self.viewController needCrop:true]; });
}

- (PNUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = PNUploadImageDTO.new; });
}
@end
