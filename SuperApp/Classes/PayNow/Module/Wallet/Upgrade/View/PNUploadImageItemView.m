//
//  PNUploadImageItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUploadImageItemView.h"
#import "PNUploadImageDTO.h"
#import "PNUtilMacro.h"
#import "SAImageAccessor.h"
#import "UIView+HD_Extension.h"


@interface PNUploadImageItemView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) HDUIButton *clickBtn;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) HDUIButton *deleteBtn;

@property (nonatomic, strong) SALabel *tipsLabel;

@property (nonatomic, strong) CAShapeLayer *border;

@property (nonatomic, strong) SAImageAccessor *imageAccessor;

@property (nonatomic, strong) PNUploadImageDTO *uploadImageDTO;

@end


@implementation PNUploadImageItemView

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self addSubview:self.imgView];
    [self addSubview:self.iconImgView];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.clickBtn];
    [self addSubview:self.deleteBtn];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(kRealWidth(-15));
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(5));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-5));
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(kRealWidth(10));
    }];

    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(5));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-5));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(5));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(-5));
    }];

    [self.clickBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(5));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-5));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(5));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(-5));
    }];

    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.deleteBtn.imageView.image.size);
        make.top.mas_equalTo(self.bgView.mas_top);
        make.right.mas_equalTo(self.bgView.mas_right);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setTipsStr:(NSString *)tipsStr {
    _tipsStr = tipsStr;
    self.tipsLabel.text = tipsStr;

    [self setNeedsUpdateConstraints];
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;

    if (WJIsStringNotEmpty(urlStr)) {
        self.imgView.hidden = NO;
        self.iconImgView.hidden = YES;
        self.tipsLabel.hidden = YES;
        self.deleteBtn.hidden = NO;
        self.clickBtn.hidden = YES;
        [HDWebImageManager setImageWithURL:urlStr placeholderImage:nil imageView:self.imgView];
        !self.buttonEnableBlock ?: self.buttonEnableBlock(urlStr);
    } else {
        self.imgView.hidden = YES;
        self.iconImgView.hidden = NO;
        self.tipsLabel.hidden = NO;
        self.deleteBtn.hidden = YES;
        self.clickBtn.hidden = NO;
        !self.buttonEnableBlock ?: self.buttonEnableBlock(urlStr);
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (void)handlerChooseHeadImage {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") config:nil];

    SAImageAccessorCompletionBlock block = ^(UIImage *_Nullable image, NSError *_Nullable error) {
        if (image) {
            [self uploadImage:image];
        }
    };

    // clang-format off
    
    HDActionSheetViewButton *takePhotoBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Take_photo", @"立即拍照") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto cropMode:SAImageCropMode4To3 completion:block];
    }];
    HDActionSheetViewButton *chooseImageBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Upload_from_gallery", @"从相册上传") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos cropMode:SAImageCropMode4To3 completion:block];
    }];
    
    NSMutableArray *buttonArr = [NSMutableArray arrayWithObjects:takePhotoBTN, chooseImageBTN, nil];
    
    if (self.isCanSelectDefaultPhoto) {
        HDActionSheetViewButton *defaultImageBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"pn_use_default_photo", @"使用默认照片") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
            [sheetView dismiss];
            self.urlStr = PN_Default_Photo_URL;
        }];
        [buttonArr addObject:defaultImageBTN];
    }

    // clang-format on
    [sheetView addButtons:buttonArr];
    [sheetView show];
}

- (void)uploadImage:(UIImage *)image {
    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.viewController.view];

    [self.uploadImageDTO uploadImages:@[image] progress:^(NSProgress *_Nonnull progress) {
        hd_dispatch_main_async_safe(^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray<NSString *> *_Nonnull imageURLArray) {
        hd_dispatch_main_async_safe(^{
            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            if (imageURLArray.count > 0) {
                HDLog(@"结果：%@", imageURLArray.firstObject);
                self.urlStr = imageURLArray.firstObject;
            }
        });
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        HDLog(@"上传失败error: %@", error);
        [hud hideAnimated:true];
    }];
}

#pragma mark
- (CAShapeLayer *)border {
    if (!_border) {
        _border = [CAShapeLayer layer];
        _border.strokeColor = HDAppTheme.PayNowColor.c9599A2.CGColor;
        _border.fillColor = [UIColor clearColor].CGColor;
        _border.lineDashPattern = @[@4, @2];
        _border.lineWidth = 1.f;
    }
    return _border;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        @HDWeakify(self);
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(5)];
            self.border.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:kRealWidth(5)].CGPath;
            self.border.frame = view.bounds;
            [self.border removeFromSuperlayer];
            [view.layer addSublayer:self.border];
        };
    }
    return _bgView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(5)];
        };
    }
    return _imgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"pn_camera_icon"];
    }
    return _iconImgView;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[SALabel alloc] init];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = HDAppTheme.PayNowFont.standard12;
        _tipsLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}

- (HDUIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.hidden = YES;
        [_deleteBtn setImage:[UIImage imageNamed:@"pn_photo_delete_icon"] forState:0];
        @HDWeakify(self);
        [_deleteBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.urlStr = @"";
        }];
    }
    return _deleteBtn;
}

- (HDUIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        @HDWeakify(self);
        [_clickBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self handlerChooseHeadImage];
        }];
    }
    return _clickBtn;
}

- (SAImageAccessor *)imageAccessor {
    return _imageAccessor ?: ({ _imageAccessor = [[SAImageAccessor alloc] initWithSourceViewController:self.viewController needCrop:true]; });
}

- (PNUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = PNUploadImageDTO.new; });
}
@end
