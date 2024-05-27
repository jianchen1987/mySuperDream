//
//  PNApartmentUploadVoucherView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentUploadVoucherView.h"
#import "PNPhotoView.h"
#import "PNPhotoManager.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNUploadImageDTO.h"
#import "PNMSUploadVoucherResultViewController.h"
#import "PNMSVoucherInfoModel.h"
#import "PNApartmentDTO.h"


@interface PNApartmentUploadVoucherView () <HDTextViewDelegate, HXPhotoViewDelegate>
@property (nonatomic, strong) PNUploadImageDTO *uploadDTO;
@property (nonatomic, strong) PNApartmentDTO *apartmentDTO;
@property (nonatomic, strong) PNOperationButton *comfirmBtn;
@property (nonatomic, strong) SALabel *titleLabel;
/// 上传图片提示
@property (nonatomic, strong) SALabel *uploadTipLabel;
@property (strong, nonatomic) PNPhotoManager *manager;
@property (strong, nonatomic) PNPhotoView *photoView;
@property (nonatomic, strong) SALabel *remarkLabel;
@property (nonatomic, strong) HDTextView *textView;
@property (nonatomic, strong) SALabel *textLengthLabel;

@property (nonatomic, assign) CGFloat textViewHeight;
@property (nonatomic, assign) CGFloat photoViewHeight;
/// 选择的照片
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos;

@end


@implementation PNApartmentUploadVoucherView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.titleLabel];
    [self.scrollViewContainer addSubview:self.photoView];
    [self.scrollViewContainer addSubview:self.uploadTipLabel];
    [self.scrollViewContainer addSubview:self.remarkLabel];
    [self.scrollViewContainer addSubview:self.textView];
    [self.scrollViewContainer addSubview:self.textLengthLabel];

    [self addSubview:self.comfirmBtn];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.equalTo(self.comfirmBtn.mas_top).offset(-kRealWidth(20));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(16));
    }];

    [self.uploadTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(8));
    }];

    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadTipLabel.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.height.equalTo(@(self.photoViewHeight));
    }];

    [self.photoView.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.photoView);
    }];


    [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.photoView.mas_bottom).offset(kRealWidth(16));
    }];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkLabel.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.height.mas_equalTo(self.textViewHeight > 0 ? self.textViewHeight : kRealWidth(100));
    }];

    [self.textLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(12));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom).offset(-kRealWidth(15));
    }];

    [self.comfirmBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(20));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-(kRealWidth(16) + kiPhoneXSeriesSafeBottomHeight));
    }];
}

#pragma mark
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    if (height <= kRealWidth(100))
        return;

    [UIView animateWithDuration:0.25 animations:^{
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)textViewDidChange:(HDTextView *)textView {
    self.textLengthLabel.text = [NSString stringWithFormat:@"%zd/%zd", textView.text.length, textView.maximumTextLength];
}

#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView
    changeComplete:(NSArray<HXPhotoModel *> *)allList
            photos:(NSArray<HXPhotoModel *> *)photos
            videos:(NSArray<HXPhotoModel *> *)videos
          original:(BOOL)isOriginal {
    self.selectedPhotos = photos;
    [self.selectedPhotos enumerateObjectsUsingBlock:^(HXPhotoModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        CGSize size;
        if (isOriginal) {
            size = PHImageManagerMaximumSize;
        } else {
            size = CGSizeMake(model.imageSize.width * 0.5, model.imageSize.height * 0.5);
        }
        [model requestPreviewImageWithSize:size startRequestICloud:nil progressHandler:nil success:nil failed:nil];
    }];

    if (WJIsArrayEmpty(self.selectedPhotos)) {
        self.comfirmBtn.enabled = NO;
    } else {
        self.comfirmBtn.enabled = YES;
    }
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    [UIView animateWithDuration:0.25 animations:^{
        [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(frame.size.height);
        }];
        [self layoutIfNeeded];
    }];
}

#pragma mark
- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    NSArray<UIImage *> *images = [self.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
        return model.previewPhoto ?: model.thumbPhoto;
    }];

    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self];
    [self.uploadDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray<NSString *> *_Nonnull imageURLArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
            [hud hideAnimated:NO];
        });
        !completion ?: completion(imageURLArray);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [hud hideAnimated:YES];
    }];
}

- (void)clickDoneAction {
    if (self.selectedPhotos.count > 0) {
        @HDWeakify(self);
        [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
            HDLog(@"%@", imgUrlArray);
            NSString *urlStr = [imgUrlArray componentsJoinedByString:@","];
            @HDStrongify(self);
            @HDWeakify(self);
            [self showloading];
            [self.apartmentDTO uploadVoucherApartment:self.paymentId remark:self.textView.text voucherImgUrl:urlStr success:^(PNRspModel *_Nonnull rspModel) {
                @HDStrongify(self);
                [self dismissLoading];
                [HDMediator.sharedInstance navigaveToPayNowApartmentResultVC:@{
                    @"type": @(1),
                }];
            } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
                [self dismissLoading];
            }];
        }];
    }
}

#pragma mark
#pragma mark - lazy load
- (PNPhotoManager *)manager {
    if (!_manager) {
        _manager = [[PNPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = 5;
    }
    return _manager;
}

- (PNPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [PNPhotoView photoManager:self.manager addViewBackgroundColor:HDAppTheme.PayNowColor.cFFFFFF];
        _photoView.delegate = self;
        _photoView.width = kScreenWidth - kRealWidth(24);
    }
    return _photoView;
}

- (SALabel *)uploadTipLabel {
    if (!_uploadTipLabel) {
        SALabel *label = SALabel.new;
        label.text = PNLocalizedString(@"pn_upload_voucher_tips", @"请上传凭证照片，每张不超过5MB，最多可上传5张，支持PNG/JPEG/GIF");
        label.font = HDAppTheme.PayNowFont.standard11;
        label.textColor = [UIColor hd_colorWithHexString:@"#0052D9"];
        label.numberOfLines = 0;
        _uploadTipLabel = label;
    }
    return _uploadTipLabel;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = SALabel.new;
        NSString *hightStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", hightStr, PNLocalizedString(@"pn_Payment_voucher", @"缴费凭证")];
        label.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14B
                                                           highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                                  norFont:HDAppTheme.PayNowFont.standard14B
                                                                 norColor:HDAppTheme.PayNowColor.c333333];
        label.numberOfLines = 0;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)remarkLabel {
    if (!_remarkLabel) {
        SALabel *label = SALabel.new;
        label.text = PNLocalizedString(@"remark", @"备注");
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.numberOfLines = 0;
        _remarkLabel = label;
    }
    return _remarkLabel;
}

- (HDTextView *)textView {
    if (!_textView) {
        _textView = HDTextView.new;
        _textView.placeholder = PNLocalizedString(@"please_enter", @"请输入");
        _textView.placeholderColor = HDAppTheme.color.G3;
        _textView.font = HDAppTheme.font.standard3;
        _textView.textColor = HDAppTheme.color.G1;
        _textView.delegate = self;
        _textView.maximumTextLength = 500;
        _textView.backgroundColor = HDAppTheme.color.normalBackground;
        _textView.layer.cornerRadius = 5;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.tintColor = HDAppTheme.PayNowColor.mainThemeColor;
    }
    return _textView;
}

- (SALabel *)textLengthLabel {
    if (!_textLengthLabel) {
        SALabel *label = SALabel.new;
        label.text = @"0/500";
        label.textAlignment = NSTextAlignmentRight;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        label.hd_edgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        _textLengthLabel = label;
    }
    return _textLengthLabel;
}

- (PNOperationButton *)comfirmBtn {
    if (!_comfirmBtn) {
        _comfirmBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _comfirmBtn.enabled = NO;
        [_comfirmBtn setTitle:PNLocalizedString(@"pn_confirm_upload", @"确认上传") forState:UIControlStateNormal];
        [_comfirmBtn addTarget:self action:@selector(clickDoneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmBtn;
}

- (PNUploadImageDTO *)uploadDTO {
    if (!_uploadDTO) {
        _uploadDTO = [[PNUploadImageDTO alloc] init];
    }
    return _uploadDTO;
}

- (PNApartmentDTO *)apartmentDTO {
    if (!_apartmentDTO) {
        _apartmentDTO = [[PNApartmentDTO alloc] init];
    }
    return _apartmentDTO;
}

@end
