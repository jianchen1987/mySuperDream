//
//  TNTransferViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTransferViewController.h"
#import "SAMoneyModel.h"
#import "SAOperationButton.h"
#import "SAUploadImageDTO.h"
#import "TNGuideViewController.h"
#import "TNReviceMethodView.h"
#import "TNTransferDTO.h"
#import "TNTransferInputView.h"
#import "TNTransferRspModel.h"
#import "TNTransferSubmitModel.h"
#import "TNTransferTakePhotoView.h"


@interface TNTransferViewController ()
/// 转账金额文本
@property (strong, nonatomic) HDLabel *transferDesLabel;
/// 如何转账
@property (strong, nonatomic) HDUIButton *doubtTransferBtn;
/// 转账金额
@property (strong, nonatomic) HDLabel *amountLabel;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 付款方式文本
@property (strong, nonatomic) HDLabel *reciveMethodLabel;
/// 标签流
@property (strong, nonatomic) HDFloatLayoutView *floatLayoutView;
/// 电话视图
@property (strong, nonatomic) TNTransferInputView *transferInputView;
/// 转账凭证视图
@property (strong, nonatomic) TNTransferTakePhotoView *takePhotoView;
/// 说明文本
@property (strong, nonatomic) HDLabel *tipsLabel;
/// 联系客服按钮
@property (strong, nonatomic) SAOperationButton *contactBtn;
/// 按钮数组
@property (strong, nonatomic) NSMutableArray *btnArr;
/// 平台客服按钮
@property (strong, nonatomic) SAOperationButton *submitBtn;
///审核状态文本
@property (strong, nonatomic) HDLabel *statuaLabel;
/// 付款方式视图  数组
@property (strong, nonatomic) NSMutableArray<TNReviceMethodView *> *methodViewArr;
/// dto
@property (strong, nonatomic) TNTransferDTO *transferDTO;
/// 转账付款数据源
@property (strong, nonatomic) TNTransferRspModel *model;
/// 支付方式的账户数据
@property (strong, nonatomic) NSArray<TNTransferItemModel *> *itemList;
/// oderNo
@property (nonatomic, copy) NSString *orderNo;
/// 上传图片 dto
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;
@end


@implementation TNTransferViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.orderNo = parameters[@"orderNo"];
    }
    return self;
}
- (void)hd_setupViews {
    self.scrollView.hidden = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.statuaLabel];
    [self.scrollViewContainer addSubview:self.transferDesLabel];
    [self.scrollViewContainer addSubview:self.doubtTransferBtn];
    [self.scrollViewContainer addSubview:self.amountLabel];
    [self.scrollViewContainer addSubview:self.lineView];
    [self.scrollViewContainer addSubview:self.contactBtn];
    [self.scrollViewContainer addSubview:self.reciveMethodLabel];
    [self.scrollViewContainer addSubview:self.floatLayoutView];
    [self.scrollViewContainer addSubview:self.transferInputView];
    [self.scrollViewContainer addSubview:self.takePhotoView];
    [self.scrollViewContainer addSubview:self.tipsLabel];
    [self.view addSubview:self.submitBtn];
    [self loadData];
    [self addKVO];
    self.hd_needMoveView = self.scrollViewContainer;
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_transfer_pay", @"转账付款");
}
- (void)addKVO {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.transferInputView keyPath:@"phoneNum" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateSubmitStatus];
    }];
    [self.KVOController hd_observe:self.takePhotoView keyPath:@"selectedPhotos" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self updateSubmitStatus];
    }];
}
#pragma mark - 提交转账凭证
- (void)submitTransferData {
    @HDWeakify(self);
    [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
        @HDStrongify(self);
        [self showloading];
        TNTransferSubmitModel *submitModel = [[TNTransferSubmitModel alloc] init];
        submitModel.orderNo = self.orderNo;
        submitModel.mobile = self.transferInputView.phoneNum;
        submitModel.credentialImages = imgUrlArray;
        [self.transferDTO saveTransferCredentiaDataBySubmitModel:submitModel Success:^(BOOL isSuccess) {
            @HDStrongify(self);
            [self dismissLoading];
            [HDTips showSuccess:TNLocalizedString(@"tn_tf_submit_success", @"提交成功") inView:self.view hideAfterDelay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    }];
}
#pragma mark - Data
- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    NSArray<UIImage *> *images = [self.takePhotoView.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
        return model.previewPhoto ?: model.thumbPhoto;
    }];

    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.view];
    @HDWeakify(self);
    [self.uploadImageDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0] hideAfterDelay:0.25];
            @HDWeakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @HDStrongify(self);
                [self showloading];
            });
        });
    } success:^(NSArray *_Nonnull imageURLArray) {
        @HDStrongify(self);
        if (hud) {
            [hud hideAnimated:true];
        }
        [self dismissLoading];

        !completion ?: completion(imageURLArray);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        if (hud) {
            [hud hideAnimated:true];
        }
        [self dismissLoading];
        [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                          handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                              [alertView dismiss];
                          }];
    }];
}
#pragma mark - 获取转账付款数据
- (void)loadData {
    [self.view showloading];
    @HDWeakify(self);
    [self.transferDTO queryTransferDataByOrderNo:self.orderNo Success:^(TNTransferRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.scrollView.hidden = NO;
        // 第一次credential 没有值  初始化 默认是待提交状态   状态非常混乱
        if (HDIsObjectNil(rspModel.credential)) {
            rspModel.credential = [[TNTransferCredentialModel alloc] init];
            rspModel.credential.auditStatus = TNTransferAuditStatusNotSubmit;
        }
        //处理数据  后台没有重新提交状态  待补交 13的状态归为11 审核中
        if (rspModel.credential.auditStatus == TNTransferAuditStatusSupplementInfo) {
            rspModel.credential.auditStatus = TNTransferAuditStatusChecking;
        }
        //没有是在待提交状态  又有数据  就设置本地状态
        if (rspModel.credential.auditStatus == TNTransferAuditStatusNotSubmit && HDIsStringNotEmpty(rspModel.credential.mobile) && !HDIsArrayEmpty(rspModel.credential.credentialImages)) {
            rspModel.credential.auditStatus = TNTransferAuditStatusAgainSubmit; //重新提交状态
        }
        self.model = rspModel;
        [self updateData];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        @HDWeakify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            @HDStrongify(self);
            [self loadData];
        }];
    }];
}
#pragma mark - 更新显示数据
- (void)updateData {
    //是否显示审核状态
    switch (self.model.credential.auditStatus) {
        case TNTransferAuditStatusNotSubmit: {
            self.statuaLabel.hidden = YES;
            self.submitBtn.hidden = NO;
        } break;
        case TNTransferAuditStatusChecking: {
            self.statuaLabel.hidden = NO;
            self.statuaLabel.textColor = HDAppTheme.TinhNowColor.C1;
            self.statuaLabel.text = TNLocalizedString(@"tn_tf_reviewing", @"审核中");
            self.submitBtn.hidden = YES;
            self.transferInputView.mobile = self.model.credential.mobile;
            self.transferInputView.disableEdit = YES;
            self.takePhotoView.imageURLs = self.model.credential.credentialImages;
            self.takePhotoView.hiddenAddAndDeleteBtn = YES;
        } break;
        case TNTransferAuditStatusPassed: {
            self.statuaLabel.hidden = NO;
            self.statuaLabel.textColor = HexColor(0x14B96D);
            self.statuaLabel.text = TNLocalizedString(@"tn_tf_review_approved", @"已通过");
            self.submitBtn.hidden = YES;
            self.transferInputView.mobile = self.model.credential.mobile;
            self.transferInputView.disableEdit = YES;
            self.takePhotoView.imageURLs = self.model.credential.credentialImages;
            self.takePhotoView.hiddenAddAndDeleteBtn = YES;
        } break;
        case TNTransferAuditStatusAgainSubmit: {
            self.statuaLabel.hidden = NO;
            self.statuaLabel.textColor = HexColor(0xFD2322);
            self.statuaLabel.text = TNLocalizedString(@"tn_tf_review_not_approved", @"未通过");
            self.submitBtn.hidden = NO;
            [self.submitBtn setTitle:TNLocalizedString(@"tn_tf_submit_agian", @"重新提交") forState:UIControlStateNormal];
            self.transferInputView.mobile = self.model.credential.mobile;
            self.takePhotoView.imageURLs = self.model.credential.credentialImages;
        } break;
        default:
            self.statuaLabel.hidden = YES;
            self.submitBtn.hidden = NO;
            break;
    }
    // 订单金额
    self.amountLabel.text = self.model.money.thousandSeparatorAmount;
    //说明
    NSString *tips = self.model.explain;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:tips];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, tips.length)];
    self.tipsLabel.attributedText = attr;

    // 支付方式的 名称
    NSArray *methodNameArr = [self.model.payType mapObjectsUsingBlock:^id _Nonnull(TNTransferPayTypeModel *_Nonnull obj, NSUInteger idx) {
        return obj.name;
    }];
    [self.floatLayoutView hd_removeAllSubviews];
    for (int i = 0; i < methodNameArr.count; i++) {
        NSString *tag = methodNameArr[i];
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        button.tag = i;
        button.ghostColor = HDAppTheme.color.G3;
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard14;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, kRealWidth(10), 5, kRealWidth(10));
        button.cornerRadius = 4.0f;
        [button setTitle:tag forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.adjustsImageTintColorAutomatically = NO;
        [button applyPropertiesWithBackgroundColor:UIColor.whiteColor];
        [self.floatLayoutView addSubview:button];
        [self.btnArr addObject:button];
        if (i == 0) {
            [self tagBtnClick:button];
        }
    }
    //设置按钮状态
    [self updateSubmitStatus];
    [self.view setNeedsUpdateConstraints];
}
#pragma mark 更新按钮显示
- (void)updateSubmitStatus {
    if (self.model.credential.auditStatus == TNTransferAuditStatusNotSubmit || self.model.credential.auditStatus == TNTransferAuditStatusAgainSubmit) {
        if (HDIsStringNotEmpty(self.transferInputView.phoneNum) && !HDIsArrayEmpty(self.takePhotoView.selectedPhotos)) {
            self.submitBtn.enabled = YES;
            if (self.model.credential.auditStatus == TNTransferAuditStatusNotSubmit) {
                [self.submitBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
            } else if (self.model.credential.auditStatus == TNTransferAuditStatusAgainSubmit) {
                [self.submitBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.cFF2323];
            }
        } else {
            self.submitBtn.enabled = NO;
            [self.submitBtn applyPropertiesWithBackgroundColor:HexColor(0xD6DBE8)];
        }
    }
}
#pragma mark - 点击支付方式
- (void)tagBtnClick:(SAOperationButton *)btn {
    if (btn.isSelected) {
        return;
    }
    btn.selected = YES;
    [btn applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:@"#FD8824"]];
    btn.borderColor = [UIColor hd_colorWithHexString:@"#FD8824"];
    for (SAOperationButton *otherBtn in self.btnArr) {
        if (otherBtn != btn) {
            otherBtn.selected = NO;
            [otherBtn applyPropertiesWithBackgroundColor:UIColor.whiteColor];
            otherBtn.borderColor = HDAppTheme.TinhNowColor.G3;
            [otherBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        }
    }
    //支付方式的详细数据
    self.itemList = self.model.payType[btn.tag].dataDictList;
    [self cratePaymethodItemView];
}
#pragma mark - 创建支付方式的账户数据
- (void)cratePaymethodItemView {
    [self.methodViewArr removeAllObjects];
    for (UIView *subView in self.scrollViewContainer.subviews) {
        if ([subView isKindOfClass:[TNReviceMethodView class]]) {
            [subView removeFromSuperview];
        }
    }
    for (TNTransferItemModel *item in self.itemList) {
        TNReviceMethodView *methodView = [[TNReviceMethodView alloc] init];
        methodView.item = item;
        [self.scrollViewContainer addSubview:methodView];
        [self.methodViewArr addObject:methodView];
    }
    [self.view setNeedsUpdateConstraints];
}
- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        if (self.submitBtn.isHidden) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-kRealWidth(10));
        } else {
            make.bottom.equalTo(self.submitBtn.mas_top);
        }
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    if (!self.statuaLabel.isHidden) {
        [self.statuaLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.scrollViewContainer.mas_top);
            make.height.mas_equalTo(kRealWidth(35));
        }];
    }
    [self.transferDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        if (!self.statuaLabel.isHidden) {
            make.top.equalTo(self.statuaLabel.mas_bottom).offset(kRealWidth(15));
        } else {
            make.top.equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(15));
        }
    }];
    [self.doubtTransferBtn sizeToFit];
    [self.doubtTransferBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.transferDesLabel.mas_centerY);
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
    }];
    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.transferDesLabel.mas_bottom).offset(kRealWidth(20));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.amountLabel.mas_bottom).offset(kRealWidth(10));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(PixelOne);
    }];
    [self.contactBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(35));
    }];

    [self.reciveMethodLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contactBtn.mas_bottom).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
    }];
    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = kScreenWidth - 2 * kRealWidth(15);
        make.top.equalTo(self.reciveMethodLabel.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        make.size.mas_equalTo(size);
    }];

    UIView *lastView = nil;
    if (!HDIsArrayEmpty(self.methodViewArr)) {
        for (TNReviceMethodView *methodView in self.methodViewArr) {
            [methodView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
                make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
                if (lastView) {
                    make.top.equalTo(lastView.mas_bottom);
                } else {
                    make.top.equalTo(self.floatLayoutView.mas_bottom).offset(kRealWidth(10));
                }
            }];
            lastView = methodView;
        }
    }

    [self.transferInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        if (lastView) {
            make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.equalTo(self.floatLayoutView.mas_bottom).offset(kRealWidth(20));
        }
        make.height.mas_equalTo(kRealWidth(45));
    }];

    [self.takePhotoView sizeToFit];
    [self.takePhotoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.equalTo(self.transferInputView.mas_bottom);
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.takePhotoView.mas_bottom).offset(kRealWidth(15));
        make.bottom.equalTo(self.scrollViewContainer.mas_bottom).offset(-kRealWidth(20));
    }];
    if (!self.submitBtn.isHidden) {
        [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_offset(kRealWidth(45));
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self.view);
            }
        }];
    }
    [super updateViewConstraints];
}
/** @lazy transferDesLabel */
- (HDLabel *)transferDesLabel {
    if (!_transferDesLabel) {
        _transferDesLabel = [[HDLabel alloc] init];
        _transferDesLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _transferDesLabel.font = HDAppTheme.TinhNowFont.standard12M;
        _transferDesLabel.text = TNLocalizedString(@"tn_transfer_money", @"转账金额");
    }
    return _transferDesLabel;
}
- (HDUIButton *)doubtTransferBtn {
    if (!_doubtTransferBtn) {
        _doubtTransferBtn = [[HDUIButton alloc] init];
        _doubtTransferBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_doubtTransferBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _doubtTransferBtn.spacingBetweenImageAndTitle = 8;
        _doubtTransferBtn.imagePosition = HDUIButtonImagePositionRight;
        _doubtTransferBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _doubtTransferBtn.adjustsButtonWhenHighlighted = NO;
        [_doubtTransferBtn setTitle:TNLocalizedString(@"tn_how_transfer", @"如何转账") forState:UIControlStateNormal];
        [_doubtTransferBtn setImage:[UIImage imageNamed:@"tinhnow_doubt"] forState:UIControlStateNormal];
        [_doubtTransferBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            TNGuideViewController *vc = [[TNGuideViewController alloc] init];
            [SAWindowManager navigateToViewController:vc];
        }];
    }
    return _doubtTransferBtn;
}
- (HDLabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[HDLabel alloc] init];
        _amountLabel.textColor = [UIColor hd_colorWithHexString:@"#FD8824"];
        _amountLabel.font = [HDAppTheme.TinhNowFont fontSemibold:30];
    }
    return _amountLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _lineView;
}
- (HDLabel *)reciveMethodLabel {
    if (!_reciveMethodLabel) {
        _reciveMethodLabel = [[HDLabel alloc] init];
        _reciveMethodLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _reciveMethodLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _reciveMethodLabel.numberOfLines = 0;
        _reciveMethodLabel.text = TNLocalizedString(@"tn_supports_way", @"WOWNOW支持以下方式收款：");
    }
    return _reciveMethodLabel;
}
- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, kRealWidth(12), kRealWidth(10));
        _floatLayoutView.minimumItemSize = CGSizeMake(kRealWidth(40), kRealWidth(30));
    }
    return _floatLayoutView;
}
- (NSMutableArray<TNReviceMethodView *> *)methodViewArr {
    if (!_methodViewArr) {
        _methodViewArr = [NSMutableArray array];
    }
    return _methodViewArr;
}
/** @lazy transferInputView */
- (TNTransferInputView *)transferInputView {
    if (!_transferInputView) {
        _transferInputView = [[TNTransferInputView alloc] init];
    }
    return _transferInputView;
}
/** @lazy takePhotoView */
- (TNTransferTakePhotoView *)takePhotoView {
    if (!_takePhotoView) {
        _takePhotoView = [[TNTransferTakePhotoView alloc] init];
    }
    return _takePhotoView;
}
/** @lazy submitBtn */
- (SAOperationButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _submitBtn.cornerRadius = 0;
        [_submitBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        [_submitBtn setTitle:TNLocalizedString(@"tn_button_submit", @"提交") forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard17M;
        [_submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitTransferData) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.hidden = YES;
    }
    return _submitBtn;
}
- (HDLabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[HDLabel alloc] init];
        _tipsLabel.textColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
        _tipsLabel.font = HDAppTheme.TinhNowFont.standard12;
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}
- (HDLabel *)statuaLabel {
    if (!_statuaLabel) {
        _statuaLabel = [[HDLabel alloc] init];
        _statuaLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#FFF2E5"];
        _statuaLabel.font = HDAppTheme.TinhNowFont.standard12M;
        _statuaLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statuaLabel;
}
/** @lazy contactBtn */
- (SAOperationButton *)contactBtn {
    if (!_contactBtn) {
        _contactBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_contactBtn setTitle:TNLocalizedString(@"tn_customer", @"联系客服") forState:UIControlStateNormal];
        _contactBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_contactBtn applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.c5d667f];
        _contactBtn.layer.borderWidth = 0.5;
        [_contactBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [[HDMediator sharedInstance] navigaveTinhNowContactCustomerServiceViewController:@{}];
        }];
    }
    return _contactBtn;
}
- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
- (TNTransferDTO *)transferDTO {
    if (!_transferDTO) {
        _transferDTO = [[TNTransferDTO alloc] init];
    }
    return _transferDTO;
}
- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}
@end
