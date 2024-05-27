//
//  SASuggestionView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASuggestionView.h"
#import "SAPhotoManager.h"
#import "SASuggestionViewModel.h"
#import "SAUploadImageDTO.h"
#import <HDUIKit/HDTextView.h>


@interface SASuggestionView () <HDTextViewDelegate, HXPhotoViewDelegate>
/// VM
@property (nonatomic, strong) SASuggestionViewModel *viewModel;
/// 上传图片 VM
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
@property (strong, nonatomic) SAPhotoManager *manager;
@property (strong, nonatomic) SAPhotoView *photoView;
@property (nonatomic, strong) HDTextView *textView;                  ///< 输入框
@property (nonatomic, assign) CGFloat lastPhotoViewHeight;           ///< 上一次 photoView 高度
@property (nonatomic, strong) SAOperationButton *submitBTN;          ///< 提交按钮
@property (nonatomic, strong) SALabel *textLengthLabel;              ///< 文本长度显示
@property (nonatomic, strong) SALabel *uploadTipLabel;               ///< 上传图片提示
@property (nonatomic, assign) CGFloat textViewMinimumHeight;         ///< 输入框最小高度
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos; ///< 选择的照片

@end


@implementation SASuggestionView
- (void)hd_setupViews {
    self.textViewMinimumHeight = 100;
    self.backgroundColor = UIColor.whiteColor;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.textView];
    [self.scrollView addSubview:self.textLengthLabel];
    [self.scrollView addSubview:self.uploadTipLabel];
    [self.scrollView addSubview:self.photoView];
    [self addSubview:self.submitBTN];

    @HDWeakify(self);
    self.submitBTN.hd_frameDidChangeBlock = ^void(__kindof UIView *_Nonnull view, CGRect frame) {
        @HDStrongify(self);
        [self updateContainerContainerSubViewsAndFrame];
    };
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(40));
        make.bottom.equalTo(self).offset(-kiPhoneXSeriesSafeBottomHeight);
        make.width.centerX.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - private methods
- (void)updateContainerContainerSubViewsAndFrame {
    self.scrollView.frame = CGRectMake(HDAppTheme.value.padding.left,
                                       kRealWidth(15),
                                       CGRectGetWidth(self.frame) - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding),
                                       CGRectGetMinY(self.submitBTN.frame) - self.submitBTN.height);

    [self updateTextViewFrame];
}

- (void)updateTextViewFrame {
    const CGFloat width = CGRectGetWidth(self.scrollView.frame);
    const CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(kScreenWidth - 2 * kRealWidth(15), CGFLOAT_MAX)];
    self.textView.frame = CGRectMake(0, 0, width, fmax(textViewSize.height, self.textViewMinimumHeight));

    [self.textLengthLabel sizeToFit];
    [self.textLengthLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(0);
        make.width.hd_equalTo(width);
        make.top.hd_equalTo(self.textView.bottom).offset(kRealWidth(15));
        make.height.hd_equalTo(self.textLengthLabel.height);
    }];

    [self.uploadTipLabel sizeToFit];
    [self.uploadTipLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(self.textView.left);
        make.top.hd_equalTo(self.textLengthLabel.bottom);
        make.width.hd_equalTo(self.textView.width);
        make.height.hd_equalTo(self.uploadTipLabel.height);
    }];

    [self updatePhotoViewFrameAndShouldScrollToBottom:false];
}

- (void)updatePhotoViewFrameAndShouldScrollToBottom:(BOOL)shouldScrollToBottom {
    const CGFloat width = CGRectGetWidth(self.scrollView.frame);
    self.photoView.frame = CGRectMake(0, CGRectGetMaxY(self.uploadTipLabel.frame) + kRealWidth(15), width, CGRectGetHeight(self.photoView.frame) > 0 ? CGRectGetHeight(self.photoView.frame) : 50);

    self.scrollView.contentSize = CGSizeMake(width, CGRectGetMaxY(self.photoView.frame) + kRealWidth(30));

    if (shouldScrollToBottom) {
        // 滚动到底部
        if (self.scrollView.contentSize.height > self.scrollView.bounds.size.height) {
            CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom);
            [self.scrollView setContentOffset:bottomOffset animated:YES];
        }
    }
}

- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    NSArray<UIImage *> *images = [self.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
        return model.previewPhoto ?: model.thumbPhoto;
    }];

    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self];
    [self.uploadImageDTO batchUploadImages:images singleImageLimitedSize:250 progress:^(NSProgress *_Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray *_Nonnull imageURLArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showSuccessNotCreateNew:SALocalizedString(@"upload_completed", @"上传完毕")];
        });
        !completion ?: completion(imageURLArray);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        [hud hideAnimated:true];
    }];
}

- (BOOL)checkIsOperationValid {
    if (self.textView.text.length <= 0) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"no_complaint_content_tip", @"您还没有填写反馈信息") type:HDTopToastTypeError];
        return false;
    }
    return true;
}

#pragma mark - event response
- (void)clickedSubmitButtonHandler {
    @HDWeakify(self);
    void (^finalSubmit)(NSArray<NSString *> *) = ^void(NSArray<NSString *> *imageURLArray) {
        @HDStrongify(self);
        [self showloading];
        [self.viewModel publishSuggestionWithContent:self.textView.text images:imageURLArray success:^{
            @HDStrongify(self);
            [self dismissLoading];

            [NAT showToastWithTitle:nil content:SALocalizedString(@"thanks_for_your_sendback", @"感谢您的反馈。") type:HDTopToastTypeSuccess];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.viewController.navigationController popViewControllerAnimated:true];
            });
        } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    };

    // 检查有效性d
    if ([self checkIsOperationValid]) {
        if (self.selectedPhotos.count > 0) {
            // 上传图片
            [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
                finalSubmit(imgUrlArray);
            }];
        } else {
            finalSubmit(nil);
        }
    }
}

#pragma mark - HDTextViewDelegate
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmax(height, self.textViewMinimumHeight);
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        // 实现自适应高度
        [self updateTextViewFrame];
    }
}

- (void)textView:(HDTextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [HDTips showError:[NSString stringWithFormat:SALocalizedString(@"text_not_longer_than", @"文字不能超过 %@ 个字符"), @(textView.maximumTextLength)] inView:self];
}

- (BOOL)textViewShouldReturn:(HDTextView *)textView {
    [self.submitBTN sendActionsForControlEvents:UIControlEventTouchUpInside];
    // return YES 表示这次 return 按钮的点击是为了触发“发送”，而不是为了输入一个换行符
    return YES;
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
        size = PHImageManagerMaximumSize;
        [model requestPreviewImageWithSize:size startRequestICloud:nil progressHandler:nil
                                   success:^(UIImage *_Nullable image, HXPhotoModel *_Nullable model, NSDictionary *_Nullable info) { //此处block为nil着拿到的是预览图，非原图

                                   }
                                    failed:nil];
    }];
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    if (self.lastPhotoViewHeight != frame.size.height) {
        [self updatePhotoViewFrameAndShouldScrollToBottom:true];
        self.lastPhotoViewHeight = frame.size.height;
    }
}

#pragma mark - lazy load
- (SAPhotoManager *)manager {
    if (!_manager) {
        _manager = [[SAPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = 5;
        _manager.configuration.hideOriginalBtn = true; //隐藏原图按钮
    }
    return _manager;
}

- (SAPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [SAPhotoView photoManager:self.manager];
        _photoView.delegate = self;
    }
    return _photoView;
}

- (HDTextView *)textView {
    if (!_textView) {
        _textView = HDTextView.new;
        _textView.placeholder = SALocalizedString(@"desc_your_problem_help_to_improve", @"请描述你的问题，帮助我们做得更好。");
        _textView.placeholderColor = HDAppTheme.color.G3;
        _textView.font = HDAppTheme.font.standard3;
        _textView.textColor = HDAppTheme.color.G1;
        _textView.delegate = self;
        _textView.maximumTextLength = 500;
        _textView.backgroundColor = HDAppTheme.color.normalBackground;
        _textView.layer.cornerRadius = 5;
        _textView.returnKeyType = UIReturnKeySend;
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

- (SALabel *)uploadTipLabel {
    if (!_uploadTipLabel) {
        SALabel *label = SALabel.new;
        label.text = [NSString stringWithFormat:SALocalizedString(@"upload_image_count_not_longer_than", @"最多上传 %zd 张"), 5];
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        label.hd_edgeInsets = UIEdgeInsetsMake(10, 5, 0, 5);
        label.hd_borderPosition = HDViewBorderPositionTop;
        label.hd_borderColor = HexColor(0xEBEDF0);
        label.hd_borderWidth = 1;
        label.hd_borderLocation = HDViewBorderLocationInside;
        _uploadTipLabel = label;
    }
    return _uploadTipLabel;
}

- (SAOperationButton *)submitBTN {
    if (!_submitBTN) {
        _submitBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _submitBTN.cornerRadius = 0;
        _submitBTN.backgroundColor = HexColor(0xFA1D39);
        [_submitBTN addTarget:self action:@selector(clickedSubmitButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [_submitBTN setTitle:SALocalizedStringFromTable(@"submit", @"提交", @"Buttons") forState:UIControlStateNormal];
    }
    return _submitBTN;
}

- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}
@end
