//
//  PNWalletUploadImageItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWalletUploadImageItemView.h"
#import "PNUploadImageDTO.h"


@interface PNWalletUploadImageItemView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) HDUIButton *deleteBtn;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) SAImageAccessor *imageAccessor;
/// 上传图片 VM
@property (nonatomic, strong) PNUploadImageDTO *uploadImageDTO;
/// 图片url
@property (nonatomic, copy) NSString *imageURLStr;

@end


@implementation PNWalletUploadImageItemView

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.imgView];
    [self addSubview:self.deleteBtn];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
    }];

    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.imgView.mas_width);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(8));
        make.bottom.mas_equalTo(self.mas_bottom);
        make.width.mas_equalTo(self.mas_width);
    }];

    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.deleteBtn.imageView.image.size);
        make.top.mas_equalTo(self.imgView.mas_top);
        make.right.mas_equalTo(self.imgView.mas_right);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setOnlyShow:(BOOL)onlyShow {
    _onlyShow = onlyShow;
    self.deleteBtn.hidden = onlyShow;
    if (onlyShow) {
        [self.imgView removeGestureRecognizer:self.tap];
    } else {
        [self.imgView addGestureRecognizer:self.tap];
    }
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    self.imgView.image = placeholderImage;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self setNeedsUpdateConstraints];
}

- (void)setImageView:(NSString *)url {
    self.imageURLStr = url;
    if (WJIsStringNotEmpty(self.imageURLStr)) {
        [HDWebImageManager setImageWithURL:self.imageURLStr placeholderImage:nil imageView:self.imgView];
        self.deleteBtn.hidden = NO;
        !self.buttonEnableBlock ?: self.buttonEnableBlock(YES, self.imageURLStr);
    } else {
        self.deleteBtn.hidden = YES;
        self.imgView.image = self.placeholderImage;
        !self.buttonEnableBlock ?: self.buttonEnableBlock(NO, @"");
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
        
        if (self.needCrop) {
            // 用户头像
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto cropMode:self.cropMode completion:block];
        } else {
            // 手持
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeTakingPhoto needCrop:NO completion:block];
        }
    }];
    HDActionSheetViewButton *chooseImageBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Upload_from_gallery", @"从相册上传") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        if (self.needCrop) {
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos cropMode:self.cropMode completion:block];
        } else {
            [self.imageAccessor fetchImageWithType:SAImageAccessorTypeBrowserPhotos needCrop:NO completion:block];
        }
    }];
    // clang-format on
    [sheetView addButtons:@[takePhotoBTN, chooseImageBTN]];
    [sheetView show];
}

- (void)uploadImage:(UIImage *)image {
    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.superview];

    [self.uploadImageDTO uploadImages:@[image] progress:^(NSProgress *_Nonnull progress) {
        hd_dispatch_main_async_safe(^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray<NSString *> *_Nonnull imageURLArray) {
        hd_dispatch_main_async_safe(^{
            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            if (imageURLArray.count > 0) {
                HDLog(@"结果：%@", imageURLArray.firstObject);
                //                    self.imageURLStr = imageURLArray.firstObject;
                [self setImageView:imageURLArray.firstObject];
            }
        });
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        HDLog(@"上传失败error: %@", error);
        [hud hideAnimated:true];
    }];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _titleLabel.font = HDAppTheme.PayNowFont.standard15B;
    }
    return _titleLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.userInteractionEnabled = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.image = [UIImage imageNamed:@"pn_photo_add"];
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerChooseHeadImage)];
        _tap.delegate = self;
    }
    return _tap;
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
            self.imageURLStr = @"";
            [self setImageView:@""];
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
