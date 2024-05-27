//
//  WMOrderRefundApplyViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderRefundApplyViewController.h"
#import "SAInfoView.h"
#import "SAMoneyModel.h"
#import "SAPhotoManager.h"
#import "SAUploadImageDTO.h"
#import "WMOrderDetailCancelReasonView.h"
#import "WMOrderDetailViewModel.h"
#import "WMOrderRefundChooseReasonView.h"
#import "WMOrderRefundDTO.h"
#import "WMOrderRefundReasonCellModel.h"


@interface WMOrderRefundApplyViewController () <HXPhotoViewDelegate, HDTextViewDelegate>
/// 退款金额
@property (nonatomic, strong) SAMoneyModel *refundMoney;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 原因
@property (nonatomic, strong) SAInfoView *reasonInfoView;
/// 金额
@property (nonatomic, strong) SAInfoView *amountInfoView;
/// 输入框标题
@property (nonatomic, strong) SALabel *inputTitleLB;
/// 输入框
@property (nonatomic, strong) HDTextView *textView;
/// 上传图片标题
@property (nonatomic, strong) SALabel *uploadTitleLB;
@property (strong, nonatomic) SAPhotoManager *manager;
@property (strong, nonatomic) SAPhotoView *photoView;
/// 提交按钮
@property (nonatomic, strong) SAOperationButton *submitBTN;
/// DTO
@property (nonatomic, strong) WMOrderRefundDTO *orderRefundDTO;
/// 上传图片 VM
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
/// 选择的照片
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos;
/// 输入框最小高度
@property (nonatomic, assign) CGFloat textViewMinimumHeight;
/// photoView高度
@property (nonatomic, assign) CGFloat photoViewHeight;
/// 原因
@property (nonatomic, copy) NSString *resonDesc;
/// VM
@property (nonatomic, strong) WMOrderDetailViewModel *viewModel;
/// 选择的原因
@property (nonatomic, strong) WMOrderCancelReasonModel *selectModel;

@end


@implementation WMOrderRefundApplyViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.refundMoney = [parameters objectForKey:@"refundMoney"];
    self.orderNo = [parameters objectForKey:@"orderNo"];

    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"order_refund_apply", @"退款申请");
}

- (void)hd_setupViews {
    self.textViewMinimumHeight = 120;

    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.submitBTN];
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.reasonInfoView];
    [self.scrollViewContainer addSubview:self.amountInfoView];
    [self.scrollViewContainer addSubview:self.inputTitleLB];
    [self.scrollViewContainer addSubview:self.textView];
    [self.scrollViewContainer addSubview:self.uploadTitleLB];
    [self.scrollViewContainer addSubview:self.photoView];

    [self activeViewConstraints];
}

- (void)activeViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        if (self.submitBTN.isHidden) {
            make.bottom.equalTo(self.view);
        } else {
            make.bottom.equalTo(self.submitBTN.mas_top);
        }
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.submitBTN.isHidden) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
            make.bottom.equalTo(self.view).offset(-kiPhoneXSeriesSafeBottomHeight);
        }
    }];
    [self.reasonInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollViewContainer);
        make.left.right.equalTo(self.scrollViewContainer);
    }];
    [self.amountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonInfoView.mas_bottom);
        make.left.right.equalTo(self.scrollViewContainer);
    }];
    [self.inputTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountInfoView.mas_bottom).offset(kRealWidth(15));
        make.left.equalTo(self.scrollViewContainer).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.scrollViewContainer).offset(-HDAppTheme.value.padding.right);
    }];
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.scrollViewContainer).offset(-HDAppTheme.value.padding.right);
        const CGFloat textViewWidth = kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
        const CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(textViewWidth, CGFLOAT_MAX)];
        make.height.mas_equalTo(fmax(textViewSize.height, self.textViewMinimumHeight));
        make.top.equalTo(self.inputTitleLB.mas_bottom).offset(kRealWidth(15));
    }];
    [self.uploadTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(kRealWidth(15));
        make.left.equalTo(self.scrollViewContainer).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.scrollViewContainer).offset(-HDAppTheme.value.padding.right);
    }];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadTitleLB.mas_bottom);
        make.left.equalTo(self.scrollViewContainer).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.scrollViewContainer).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(self.photoViewHeight);
        make.bottom.equalTo(self.scrollViewContainer).offset(-kRealWidth(15));
    }];
}

#pragma mark - Data
- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    NSArray<UIImage *> *images = [self.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
        return model.previewPhoto ?: model.thumbPhoto;
    }];

    HDTips *hud = [HDTips showLoading:WMLocalizedString(@"hud_uploading", @"上传中...") inView:self.view];
    [self.uploadImageDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray *_Nonnull imageURLArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showSuccessNotCreateNew:WMLocalizedString(@"upload_completed", @"上传完毕")];
        });
        !completion ?: completion(imageURLArray);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        [hud hideAnimated:true];
    }];
}

#pragma mark - private methods
- (void)showChooseReasonViewWithChoosedItem {
    //    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    //    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    //    config.title = WMLocalizedString(@"choose_refund_reason", @"选择退款原因");
    //    config.style = HDCustomViewActionViewStyleClose;
    //    config.iPhoneXFillViewBgColor = UIColor.whiteColor;
    //    config.contentHorizontalEdgeMargin = 0;
    //    const CGFloat width = kScreenWidth - config.contentHorizontalEdgeMargin * 2;
    //    WMOrderRefundChooseReasonView *view = [[WMOrderRefundChooseReasonView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    //    [view layoutyImmediately];
    //    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
    //
    //    @HDWeakify(actionView);
    //    view.selectedItemHandler = ^(WMOrderRefundReasonCellModel *model) {
    //        @HDStrongify(actionView);
    //        [actionView dismiss];
    //        !choosedItemHandler ?: choosedItemHandler(model);
    //    };
    //    actionView.willDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {
    //        !choosedItemHandler ?: choosedItemHandler(nil);
    //    };
    //    [actionView show];

    [self showloading];
    @HDWeakify(self);
    [self.viewModel userCancelOrderReasonSuccess:^(NSArray<WMOrderCancelReasonModel *> *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self);
        [self dismissLoading];
        if (rspModel) {
            HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
            config.containerMinHeight = kScreenHeight * 0.3;
            config.textAlignment = HDCustomViewActionViewTextAlignmentCenter;
            config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
            config.title = WMLocalizedString(@"choose_refund_reason", @"选择退款原因");
            config.style = HDCustomViewActionViewStyleClose;
            config.iPhoneXFillViewBgColor = UIColor.whiteColor;
            config.contentHorizontalEdgeMargin = 0;
            const CGFloat width = kScreenWidth - config.contentHorizontalEdgeMargin * 2;
            WMOrderDetailCancelReasonView *reasonView = [[WMOrderDetailCancelReasonView alloc] initWithFrame:CGRectMake(0, 0, width, kScreenHeight)];
            reasonView.dataSource = rspModel;
            [reasonView layoutyImmediately];

            HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:reasonView config:config];
            [actionView show];
            reasonView.clickedConfirmBlock = ^(WMOrderCancelReasonModel *_Nonnull model) {
                @HDStrongify(self);
                [actionView dismiss];
                self.selectModel = model;
                if (!HDIsObjectNil(model)) {
                    self.resonDesc = model.name;
                    self.reasonInfoView.model.valueText = model.name;
                }
                [self.reasonInfoView setNeedsUpdateContent];
                [self.view setNeedsUpdateConstraints];
            };
        }
    }];
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
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    self.photoViewHeight = frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.photoViewHeight);
        }];
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - HDTextViewDelegate
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmax(height, self.textViewMinimumHeight);
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        // 实现自适应高度
        @HDWeakify(self);
        void (^updateConstraintsWithAnimation)(void) = ^(void) {
            @HDStrongify(self);
            [self activeViewConstraints];
            [UIView animateWithDuration:0.4 animations:^{
                [self.view layoutIfNeeded];
            }];
        };
        updateConstraintsWithAnimation();
    }
}

- (void)textView:(HDTextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [HDTips showError:[NSString stringWithFormat:WMLocalizedString(@"text_not_longer_than", @"文字不能超过 %@ 个字符"), @(textView.maximumTextLength)] inView:self.view];
}

- (BOOL)textViewShouldReturn:(HDTextView *)textView {
    [self.view.window endEditing:true];
    // return YES 表示这次 return 按钮的点击是为了触发“发送”，而不是为了输入一个换行符
    return YES;
}

#pragma mark - event response
- (void)clickedSubmitButtonHandler {
    if (HDIsStringEmpty(self.resonDesc)) {
        [NAT showToastWithTitle:nil content:WMLocalizedString(@"please_choose_refund_reason", @"请选择退款原因") type:HDTopToastTypeWarning];
        return;
    }
    if (HDIsArrayEmpty(self.selectedPhotos)) {
        [NAT showToastWithTitle:nil content:WMLocalizedString(@"please_upload_picture", @"请上传图片") type:HDTopToastTypeWarning];
        return;
    }
    void (^finalSubmit)(NSArray<NSString *> *) = ^void(NSArray<NSString *> *imageURLArray) {
        [self showloading];
        @HDWeakify(self);
        [self.orderRefundDTO orderRefundApplyWithOrderNo:self.orderNo applyDesc:self.resonDesc cancelReason:self.selectModel reason:self.textView.text pictures:imageURLArray success:^{
            @HDStrongify(self);
            [self dismissLoading];
            self.submitBTN.hidden = true;
            self.scrollViewContainer.userInteractionEnabled = false;

            [self.view setNeedsUpdateConstraints];
            @HDWeakify(self);
            [NAT showAlertWithTitle:WMLocalizedString(@"submit_refund_success_tip_1", @"提交成功!") message:WMLocalizedString(@"submit_refund_success_tip_2", @"我们将会尽快处理你的申请。")
                        buttonTitle:WMLocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                            @HDStrongify(self);
                            [alertView dismiss];
                            //提交成功返回上一页。
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    };

    if (self.selectedPhotos.count > 0) {
        // 上传图片
        [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
            finalSubmit(imgUrlArray);
        }];
    } else {
        finalSubmit(nil);
    }
}

#pragma mark - lazy load
- (SAInfoView *)reasonInfoView {
    if (!_reasonInfoView) {
        _reasonInfoView = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyColor = HDAppTheme.color.G2;
        model.keyText = WMLocalizedString(@"refund_reason", @"退款原因");
        model.valueText = WMLocalizedString(@"please_select", @"请选择");
        model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
        model.enableTapRecognizer = true;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self showChooseReasonViewWithChoosedItem];
        };
        _reasonInfoView.model = model;
    }
    return _reasonInfoView;
}

- (SAInfoView *)amountInfoView {
    if (!_amountInfoView) {
        _amountInfoView = SAInfoView.new;
        SAInfoViewModel *model = SAInfoViewModel.new;
        model.keyColor = HDAppTheme.color.G2;
        model.keyText = WMLocalizedString(@"refund_amount", @"金额");
        model.valueText = self.refundMoney.thousandSeparatorAmount;
        model.valueColor = HDAppTheme.color.G1;
        _amountInfoView.model = model;
    }
    return _amountInfoView;
}

- (SALabel *)inputTitleLB {
    if (!_inputTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        label.text = WMLocalizedString(@"refund_problem_desc", @"问题描述");
        _inputTitleLB = label;
    }
    return _inputTitleLB;
}

- (SALabel *)uploadTitleLB {
    if (!_uploadTitleLB) {
        SALabel *label = SALabel.new;
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(12), 0, kRealWidth(12), 0);
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"*" attributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.color.C1}];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:str1];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:WMLocalizedString(@"upload_photos_required_up_to_some", @"上传图片（必填，最多%zd张）"), 5]
                                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.color.G2}];
        [text appendAttributedString:str2];
        label.attributedText = text;
        label.numberOfLines = 0;
        label.hd_borderPosition = HDViewBorderPositionTop;
        label.hd_borderWidth = 1;
        label.hd_borderColor = HDAppTheme.color.G4;
        _uploadTitleLB = label;
    }
    return _uploadTitleLB;
}

- (SAPhotoManager *)manager {
    if (!_manager) {
        _manager = [[SAPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.photoMaxNum = 5;
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
        _textView.placeholder = WMLocalizedString(@"desc_your_problem", @"请描述你的退款原因");
        _textView.placeholderColor = HDAppTheme.color.G3;
        _textView.font = HDAppTheme.font.standard3;
        _textView.textColor = HDAppTheme.color.G1;
        _textView.delegate = self;
        _textView.maximumTextLength = 200;
        _textView.backgroundColor = HDAppTheme.color.normalBackground;
        _textView.layer.cornerRadius = 5;
        _textView.returnKeyType = UIReturnKeySend;
    }
    return _textView;
}

- (SAOperationButton *)submitBTN {
    if (!_submitBTN) {
        _submitBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _submitBTN.cornerRadius = 0;
        [_submitBTN addTarget:self action:@selector(clickedSubmitButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [_submitBTN setTitle:WMLocalizedStringFromTable(@"submit", @"提交", @"Buttons") forState:UIControlStateNormal];
    }
    return _submitBTN;
}

- (WMOrderRefundDTO *)orderRefundDTO {
    if (!_orderRefundDTO) {
        _orderRefundDTO = WMOrderRefundDTO.new;
    }
    return _orderRefundDTO;
}

- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}

- (WMOrderDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = WMOrderDetailViewModel.new;
        _viewModel.orderNo = self.orderNo;
    }
    return _viewModel;
}

@end
