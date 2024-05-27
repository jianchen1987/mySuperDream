//
//  SAImFeedbackView.m
//  SuperApp
//
//  Created by Tia on 2023/2/27.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAImFeedbackView.h"
#import "SAPhotoManager.h"
#import "SAImFeedbackViewModel.h"
#import "SAUploadImageDTO.h"
#import <HDUIKit/HDTextView.h>
#import "UICollectionViewLeftAlignLayout.h"
#import "SAAppSwitchManager.h"
#import "SACouponFilterAlertViewCollectionCell.h"
#import "SACouponFilterAlertViewCollectionReusableView.h"
#import "SACouponFilterDownView.h"
#import "SAImFeedbackOptionModel.h"


@interface SAImFeedbackItemView : SAView
/// 按钮名称
@property (nonatomic, strong) SAImFeedbackOptionModel *model;
/// 选择状态
@property (nonatomic, assign) BOOL selected;
/// 隐藏分割线
@property (nonatomic, assign) BOOL hiddenLine;
/// 点击回调
@property (nonatomic, copy) dispatch_block_t clickBlock;
/// 按钮
@property (nonatomic, strong) HDUIButton *button;
/// 分割线
@property (nonatomic, strong) UIView *line;

@end


@implementation SAImFeedbackItemView

- (void)hd_setupViews {
    [self addSubview:self.button];
    [self addSubview:self.line];
}

- (void)setModel:(SAImFeedbackOptionModel *)model {
    _model = model;
    [self.button setTitle:model.name.desc forState:UIControlStateNormal];
}

- (void)updateConstraints {
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(kRealWidth(-12));
        make.bottom.equalTo(self);
        make.height.mas_equalTo(PixelOne);
    }];

    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - event response
- (void)clickedBTNHandler:(HDUIButton *)btn {
    !self.clickBlock ?: self.clickBlock();
}

#pragma mark - setter
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.button.selected = selected;
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    _hiddenLine = hiddenLine;
    self.line.hidden = hiddenLine;
}

#pragma mark - lazy load
- (HDUIButton *)button {
    if (!_button) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = HDAppTheme.font.sa_standard14;
        [button setTitleColor:HDAppTheme.color.sa_C333 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedBTNHandler:) forControlEvents:UIControlEventTouchDown];
        [button setImage:[UIImage imageNamed:@"ac_icon_radio_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"ac_icon_radio_sel"] forState:UIControlStateSelected];
        //        button.titleLabel.numberOfLines = 2;
        button.adjustsButtonWhenHighlighted = NO;
        button.spacingBetweenImageAndTitle = 4;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), 0, kRealWidth(12));
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button sizeToFit];
        _button = button;
    }
    return _button;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
    }
    return _line;
}

@end


@interface SAImFeedbackView () <HDTextViewDelegate, HXPhotoViewDelegate>
/// VM
@property (nonatomic, strong) SAImFeedbackViewModel *viewModel;
/// 上传图片 VM
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
/// 初始数据
@property (nonatomic, strong) NSArray *defaultDataArr;

/// 头部卡片
@property (nonatomic, strong) UIView *topContentView;
@property (nonatomic, strong) UILabel *redPoint1;
@property (nonatomic, strong) UILabel *tipLabel1;
/// 选项按钮数组
@property (nonatomic, strong) NSArray *btnList;
/// 底部卡片
@property (nonatomic, strong) UIView *bottomContentView;
@property (nonatomic, strong) UILabel *redPoint2;
@property (nonatomic, strong) UILabel *tipLabel2;

@property (nonatomic, strong) HDTextView *textView;          ///< 输入框
@property (nonatomic, assign) CGFloat textViewMinimumHeight; ///< 输入框最小高度
@property (nonatomic, strong) SALabel *textLengthLabel;      ///< 文本长度显示

@property (nonatomic, strong) SALabel *uploadTipLabel; ///< 上传图片提示
@property (nonatomic, strong) UILabel *tipLabel3;

@property (strong, nonatomic) SAPhotoManager *manager;
@property (strong, nonatomic) SAPhotoView *photoView;
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos; ///< 选择的照片
@property (nonatomic, assign) CGFloat lastPhotoViewHeight;           ///< 上一次 photoView 高度


@property (nonatomic, strong) SAOperationButton *confirmButton;

@property (nonatomic, strong) SAOperationButton *cancelButton;

@end


@implementation SAImFeedbackView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.textViewMinimumHeight = 106;
    self.backgroundColor = HDAppTheme.color.sa_backgroundColor;

    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.topContentView];
    [self.topContentView addSubview:self.redPoint1];
    [self.topContentView addSubview:self.tipLabel1];

    [self.scrollViewContainer addSubview:self.bottomContentView];
    [self.bottomContentView addSubview:self.redPoint2];
    [self.bottomContentView addSubview:self.tipLabel2];
    [self.bottomContentView addSubview:self.textView];
    [self.bottomContentView addSubview:self.textLengthLabel];
    [self.bottomContentView addSubview:self.uploadTipLabel];
    [self.bottomContentView addSubview:self.tipLabel3];
    [self.bottomContentView addSubview:self.photoView];

    [self addSubview:self.confirmButton];
    [self addSubview:self.cancelButton];
}


- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.confirmButton.mas_top).offset(-margin);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];


    [self.topContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];

    [self.redPoint1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.height.mas_equalTo(2 * margin);
    }];

    [self.tipLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(margin);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(2 * margin);
    }];

    UIView *lastView = nil;
    for (SAImFeedbackItemView *view in self.btnList) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.tipLabel1.mas_bottom);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.topContentView);
            make.height.mas_equalTo(48);
            if (view == self.btnList.lastObject) {
                view.hiddenLine = YES;
                make.bottom.equalTo(self.topContentView);
            }
        }];
        lastView = view;
    }


    [self.bottomContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContentView.mas_bottom).offset(margin);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.bottom.mas_equalTo(-margin);
    }];

    [self.redPoint2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.height.mas_equalTo(2 * margin);
    }];

    [self.tipLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(margin);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(2 * margin);
    }];


    CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(kScreenWidth - 2 * kRealWidth(15), CGFLOAT_MAX)];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.equalTo(self.tipLabel2.mas_bottom).offset(margin);
        make.height.mas_equalTo(fmax(textViewSize.height, self.textViewMinimumHeight) + 30);
    }];


    [self.textLengthLabel sizeToFit];
    [self.textLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.textView).offset(-margin);
    }];


    [self.uploadTipLabel sizeToFit];
    [self.uploadTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(margin);
        make.left.mas_equalTo(margin);
        make.height.mas_equalTo(2 * margin);
    }];

    [self.tipLabel3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.uploadTipLabel.mas_right).offset(4);
        make.centerY.equalTo(self.uploadTipLabel);
    }];

    [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadTipLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(margin);
        make.bottom.right.mas_equalTo(-margin);
        make.height.mas_equalTo(CGRectGetHeight(self.photoView.frame) > 0 ? CGRectGetHeight(self.photoView.frame) : 50);
    }];


    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(-margin);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];

    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self).offset(-kiPhoneXSeriesSafeBottomHeight - margin);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];

    [super updateConstraints];
}

#pragma mark - private methods


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
    void (^finalSubmit)(NSArray<NSString *> *, NSString *) = ^void(NSArray<NSString *> *imageURLArray, NSString *type) {
        @HDStrongify(self);
        [self showloading];
        [self.viewModel saveFeedbackWithType:type fromOperatorNo:self.viewModel.fromOperatorNo fromOperatorType:self.viewModel.fromOperatorType toOperatorNo:self.viewModel.toOperatorNo
            toOperatorType:self.viewModel.toOperatorType
            description:self.textView.text
            imageUrls:imageURLArray success:^{
                @HDStrongify(self);
                [self dismissLoading];

                //            [NAT showToastWithTitle:nil content:SALocalizedString(@"im_fb_tips", @"感谢你提交的反馈，我们将会尽快处理") type:HDTopToastTypeSuccess];
                [HDTips showWithText:SALocalizedString(@"im_fb_tips", @"感谢你提交的反馈，我们将会尽快处理")];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.viewController.navigationController popViewControllerAnimated:YES];
                });
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self dismissLoading];
            }];
    };


    NSString *feedbackType = nil;
    for (SAImFeedbackItemView *m in self.btnList) {
        if (m.selected) {
            feedbackType = m.model.feedbackType;
            break;
        }
    }

    if (!feedbackType) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"im_fb_tips2", @"请选择反馈类型") type:HDTopToastTypeError];
        return;
    }

    // 检查有效性d
    if ([self checkIsOperationValid]) {
        if (self.selectedPhotos.count > 0) {
            // 上传图片
            [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
                finalSubmit(imgUrlArray, feedbackType);
            }];
        } else {
            finalSubmit(nil, feedbackType);
        }
    }
}

#pragma mark - HDTextViewDelegate
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmax(height, self.textViewMinimumHeight);
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        // 实现自适应高度
        [self setNeedsUpdateConstraints];
    }
}

- (void)textView:(HDTextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [HDTips showError:[NSString stringWithFormat:SALocalizedString(@"text_not_longer_than", @"文字不能超过 %@ 个字符"), @(textView.maximumTextLength)] inView:self];
}

- (BOOL)textViewShouldReturn:(HDTextView *)textView {
    [self.confirmButton sendActionsForControlEvents:UIControlEventTouchUpInside];
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
    BOOL needUpdateConstraints = NO;
    if ((self.selectedPhotos.count < 3 && photos.count >= 3) || (self.selectedPhotos.count >= 3 && photos.count < 3)) {
        needUpdateConstraints = YES;
    }
    self.selectedPhotos = photos;
    [self.selectedPhotos enumerateObjectsUsingBlock:^(HXPhotoModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        CGSize size;
        size = PHImageManagerMaximumSize;
        [model requestPreviewImageWithSize:size startRequestICloud:nil progressHandler:nil
                                   success:^(UIImage *_Nullable image, HXPhotoModel *_Nullable model, NSDictionary *_Nullable info) { //此处block为nil着拿到的是预览图，非原图

                                   }
                                    failed:nil];
    }];
    if (needUpdateConstraints)
        [self setNeedsUpdateConstraints];
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    if (self.lastPhotoViewHeight != frame.size.height) {
        self.lastPhotoViewHeight = frame.size.height;
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark - lazy load
- (UIView *)topContentView {
    if (!_topContentView) {
        _topContentView = UIView.new;
        _topContentView.backgroundColor = UIColor.whiteColor;
        _topContentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _topContentView;
}

- (UILabel *)redPoint1 {
    if (!_redPoint1) {
        _redPoint1 = UILabel.new;
        _redPoint1.text = @"*";
        _redPoint1.textColor = HDAppTheme.color.sa_C1;
        _redPoint1.font = HDAppTheme.font.sa_standard16B;
    }
    return _redPoint1;
}

- (UILabel *)tipLabel1 {
    if (!_tipLabel1) {
        _tipLabel1 = UILabel.new;
        _tipLabel1.text = SALocalizedString(@"im_fb_FeedbackType", @"反馈类型");
        _tipLabel1.textColor = HDAppTheme.color.sa_C333;
        _tipLabel1.font = HDAppTheme.font.sa_standard16SB;
    }
    return _tipLabel1;
}

- (NSArray *)btnList {
    if (!_btnList) {
        NSMutableArray *btns = NSMutableArray.new;
        for (int i = 0; i < self.defaultDataArr.count; i++) {
            SAImFeedbackItemView *v = SAImFeedbackItemView.new;

            v.model = self.defaultDataArr[i];
            @HDWeakify(self);
            @HDWeakify(v);
            v.clickBlock = ^{
                @HDStrongify(self);
                @HDStrongify(v);
                [self endEditing:YES];
                for (SAImFeedbackItemView *btn in self.btnList) {
                    btn.selected = NO;
                }

                v.selected = YES;
            };

            [self.topContentView addSubview:v];
            [btns addObject:v];
        }
        _btnList = btns;
    }
    return _btnList;
}

- (NSArray *)defaultDataArr {
    if (!_defaultDataArr) {
        //根据后台配置控制获取筛选数据，默认显示
        NSString *jsonStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchIMFeedBackOption];
        _defaultDataArr = [NSArray yy_modelArrayWithClass:SAImFeedbackOptionModel.class json:jsonStr];
    }
    return _defaultDataArr;
}


- (UIView *)bottomContentView {
    if (!_bottomContentView) {
        _bottomContentView = UIView.new;
        _bottomContentView.backgroundColor = UIColor.whiteColor;
        _bottomContentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _bottomContentView;
}

- (UILabel *)redPoint2 {
    if (!_redPoint2) {
        _redPoint2 = UILabel.new;
        _redPoint2.text = @"*";
        _redPoint2.textColor = HDAppTheme.color.sa_C1;
        _redPoint2.font = HDAppTheme.font.sa_standard16B;
    }
    return _redPoint2;
}

- (UILabel *)tipLabel2 {
    if (!_tipLabel2) {
        _tipLabel2 = UILabel.new;
        _tipLabel2.text = SALocalizedString(@"im_fb_DetailDescription", @"详细描述");
        _tipLabel2.textColor = HDAppTheme.color.sa_C333;
        _tipLabel2.font = HDAppTheme.font.sa_standard16SB;
    }
    return _tipLabel2;
}

- (HDTextView *)textView {
    if (!_textView) {
        _textView = HDTextView.new;
        _textView.placeholder = SALocalizedString(@"im_fb_textView_tips", @"请填写反馈详细内容及相关诉求");
        _textView.placeholderColor = HDAppTheme.color.G3;
        _textView.font = HDAppTheme.font.sa_standard12;
        _textView.textColor = HDAppTheme.color.sa_C333;
        _textView.delegate = self;
        _textView.maximumTextLength = 300;
        _textView.backgroundColor = HDAppTheme.color.sa_backgroundColor;
        _textView.layer.cornerRadius = 8;
        _textView.returnKeyType = UIReturnKeySend;
    }
    return _textView;
}

- (SALabel *)textLengthLabel {
    if (!_textLengthLabel) {
        SALabel *label = SALabel.new;
        label.text = @"0/300";
        label.textAlignment = NSTextAlignmentRight;
        label.font = HDAppTheme.font.sa_standard12;
        label.textColor = HDAppTheme.color.sa_searchBarTextColor;
        _textLengthLabel = label;
    }
    return _textLengthLabel;
}

- (SAPhotoManager *)manager {
    if (!_manager) {
        _manager = [[SAPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = 5;
        _manager.configuration.hideOriginalBtn = true; //隐藏原图按钮
    }
    return _manager;
}

- (SALabel *)uploadTipLabel {
    if (!_uploadTipLabel) {
        SALabel *label = SALabel.new;
        label.text = [NSString stringWithFormat:@"%@", SALocalizedString(@"im_fb_Upload_certificate", @"上传凭证")];
        label.font = HDAppTheme.font.sa_standard16SB;
        label.textColor = HDAppTheme.color.sa_C333;
        _uploadTipLabel = label;
    }
    return _uploadTipLabel;
}

- (UILabel *)tipLabel3 {
    if (!_tipLabel3) {
        _tipLabel3 = UILabel.new;
        _tipLabel3.text = [NSString stringWithFormat:@"(%@)", SALocalizedString(@"im_fb_tips1", @"最多5张")];
        _tipLabel3.textColor = HDAppTheme.color.sa_C999;
        _tipLabel3.font = HDAppTheme.font.sa_standard14;
    }
    return _tipLabel3;
}

- (SAPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [SAPhotoView photoManager:self.manager];
        _photoView.delegate = self;
    }
    return _photoView;
}


- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}

- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_confirmButton setTitle:SALocalizedStringFromTable(@"submit", @"提交", @"Buttons") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = HDAppTheme.font.sa_standard16B;
        [_confirmButton addTarget:self action:@selector(clickedSubmitButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (SAOperationButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_cancelButton setTitle:SALocalizedStringFromTable(@"cancel", @"取消", @"Buttons") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = HDAppTheme.font.sa_standard16B;
        @HDWeakify(self);
        [_cancelButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.viewController.navigationController popViewControllerAnimated:YES];
        }];
        [_cancelButton applyPropertiesWithBackgroundColor:UIColor.clearColor];
    }
    return _cancelButton;
}

@end
