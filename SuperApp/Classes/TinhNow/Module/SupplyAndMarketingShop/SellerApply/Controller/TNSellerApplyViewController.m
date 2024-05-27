//
//  TNSellerApplyViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerApplyViewController.h"
#import "NSString+extend.h"
#import "SAUploadImageDTO.h"
#import "TNApplyDropDownSelectionView.h"
#import "TNCommonAdvRspModel.h"
#import "TNQuestionAndContactView.h"
#import "TNSellerApplyDTO.h"
#import "TNSellerApplyModel.h"
#import "TNTakePhotoView.h"
#import <HDVendorKit.h>
#import <YYText.h>


@interface TNSellerApplyViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *bannerImageView;                               ///<
@property (strong, nonatomic) UILabel *baseInfoLabel;                                     ///<基础信息文案
@property (strong, nonatomic) UILabel *nameKeyLabel;                                      ///<  姓名
@property (strong, nonatomic) HDUITextField *lastNameTextfeild;                           ///< 名字
@property (strong, nonatomic) HDUITextField *firstNameTextfeild;                          ///< 姓氏
@property (strong, nonatomic) UILabel *phoneKeyLabel;                                     ///<联系电话
@property (strong, nonatomic) HDUIButton *areaCodeBtn;                                    ///< 国家号段
@property (strong, nonatomic) HDUITextField *phoneTextfeild;                              ///<电话
@property (strong, nonatomic) TNApplyDropDownSelectionView *sourceChannelSelectionView;   ///<招商信息来源视图
@property (strong, nonatomic) HDUITextField *otherChannelTextfeild;                       ///<招商信息其它来源输入框
@property (strong, nonatomic) TNApplyDropDownSelectionView *customerGroupSelectionView;   ///<客户群体视图
@property (strong, nonatomic) TNApplyDropDownSelectionView *customerChannelSelectionView; ///<客户渠道视图
@property (strong, nonatomic) TNTakePhotoView *takePhotoView;                             ///<选取图片视图

@property (strong, nonatomic) UILabel *socialContackKeyLabel;        ///<社交账号文案
@property (strong, nonatomic) UILabel *socialContackTipsLabel;       ///<社交账号提示文案
@property (strong, nonatomic) UILabel *wechatKeyLabel;               ///<  微信
@property (strong, nonatomic) HDUITextField *wechaTextfeild;         ///<微信输入框
@property (strong, nonatomic) UILabel *FBKeyLabel;                   ///<  FB
@property (strong, nonatomic) HDUITextField *FBTextfeild;            ///< FB输入框
@property (strong, nonatomic) YYLabel *protocolLabel;                ///< 协议
@property (strong, nonatomic) TNQuestionAndContactView *contactView; ///< 联系平台按钮
@property (strong, nonatomic) HDUIButton *postBtn;                   ///< 提交按钮
@property (nonatomic, assign) BOOL isAgreeProtocol;                  ///<是否同意协议
@property (strong, nonatomic) TNSellerApplyModel *applyModel;        ///<  模型
@property (strong, nonatomic) TNSellerApplyDTO *applyDTO;            ///<
@property (nonatomic, strong) SAUploadImageDTO *uploadImageDTO;      /// 上传图片 dto
@end


@implementation TNSellerApplyViewController
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"Pp4hJo9S", @"卖家申请");
}
- (void)hd_setupViews {
    //获取详情数据
    [self getSellerApplyDetailData];

    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.postBtn];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.bannerImageView];
    [self.scrollViewContainer addSubview:self.baseInfoLabel];
    [self.scrollViewContainer addSubview:self.nameKeyLabel];
    [self.scrollViewContainer addSubview:self.lastNameTextfeild];
    [self.scrollViewContainer addSubview:self.firstNameTextfeild];
    [self.scrollViewContainer addSubview:self.phoneKeyLabel];
    [self.scrollViewContainer addSubview:self.areaCodeBtn];
    [self.scrollViewContainer addSubview:self.phoneTextfeild];
    [self.scrollViewContainer addSubview:self.sourceChannelSelectionView];
    [self.scrollViewContainer addSubview:self.otherChannelTextfeild];
    [self.scrollViewContainer addSubview:self.customerGroupSelectionView];
    [self.scrollViewContainer addSubview:self.customerChannelSelectionView];
    [self.scrollViewContainer addSubview:self.takePhotoView];
    [self.scrollViewContainer addSubview:self.socialContackKeyLabel];
    [self.scrollViewContainer addSubview:self.socialContackTipsLabel];
    [self.scrollViewContainer addSubview:self.wechatKeyLabel];
    [self.scrollViewContainer addSubview:self.wechaTextfeild];
    [self.scrollViewContainer addSubview:self.FBKeyLabel];
    [self.scrollViewContainer addSubview:self.FBTextfeild];
    [self.scrollViewContainer addSubview:self.protocolLabel];
    [self.scrollViewContainer addSubview:self.contactView];

    [self setProtocolText];
    self.hd_enableKeyboardRespond = YES;
    self.hd_needMoveView = self.scrollViewContainer;

    [self checkPostBtnEeable];
}

#pragma mark -获取申请详情数据
- (void)getSellerApplyDetailData {
    [self removePlaceHolder];
    [self showloading];
    @HDWeakify(self);
    [self.applyDTO querySellerApplyDataSuccess:^(TNSellerApplyModel *model) {
        @HDStrongify(self);
        [self dismissLoading];
        self.applyModel = model;
        [self updateData];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            [self getSellerApplyDetailData];
        }];
    }];

    [self.applyDTO querySellerApplyAdvById:@"50006" success:^(TNCommonAdvRspModel *advModel) {
        @HDStrongify(self);
        if (!HDIsObjectNil(advModel) && !HDIsArrayEmpty(advModel.advList)) {
            TNCommonAdvModel *model = advModel.advList.firstObject;
            [HDWebImageManager setImageWithURL:model.path placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth, 140) logoWidth:60] imageView:self.bannerImageView];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}
#pragma mark -卖家申请按钮点击
- (void)onClickPostApply {
    if (self.isAgreeProtocol == NO) {
        [HDTips showWithText:TNLocalizedString(@"xHUEcbn4", @"请同意卖家协议")];
        return;
    }
    if (!HDIsArrayEmpty(self.takePhotoView.selectedPhotos)) {
        @HDWeakify(self);
        [self uploadImagesCompletion:^(NSArray<NSString *> *imgUrlArray) {
            @HDStrongify(self);
            self.applyModel.images = imgUrlArray;
            [self submitSellerApply];
        }];
    } else {
        [self submitSellerApply];
    }
}
#pragma mark -提交卖家申请
- (void)submitSellerApply {
    [self showloading];
    @HDWeakify(self);
    [self.applyDTO postSellerApplyByModel:self.applyModel success:^{
        @HDStrongify(self);
        [self dismissLoading];
        [HDTips showWithText:TNLocalizedString(@"WmBVpfpm", @"提交成功，稍后平台客服联系您")];
        [self dismissAnimated:YES completion:nil];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}
#pragma mark - 上传图片
- (void)uploadImagesCompletion:(void (^)(NSArray<NSString *> *imgUrlArray))completion {
    NSArray<UIImage *> *images = [self.takePhotoView.selectedPhotos mapObjectsUsingBlock:^UIImage *_Nonnull(HXPhotoModel *_Nonnull model, NSUInteger idx) {
        return model.previewPhoto ?: model.thumbPhoto;
    }];

    HDTips *hud = [HDTips showLoading:SALocalizedString(@"hud_uploading", @"上传中...") inView:self.view];
    [self.uploadImageDTO batchUploadImages:images progress:^(NSProgress *_Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showProgressViewWithProgress:progress.fractionCompleted text:[NSString stringWithFormat:@"%.0f%%", progress.fractionCompleted * 100.0]];
        });
    } success:^(NSArray *_Nonnull imageURLArray) {
        [hud hideAnimated:true];
        !completion ?: completion(imageURLArray);
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        [hud hideAnimated:true];
    }];
}
#pragma 刷新数据
- (void)updateData {
    if (HDIsObjectNil(self.applyModel)) {
        self.applyModel = [[TNSellerApplyModel alloc] init];
    } else {
        if (HDIsStringNotEmpty(self.applyModel.areaCode) && HDIsStringNotEmpty(self.applyModel.number)) {
            HDUITextFieldConfig *config = [self.phoneTextfeild getCurrentConfig];
            if ([self.applyModel.areaCode containsString:@"855"]) {
                if ([self.applyModel.number hasPrefix:@"0"]) {
                    config.maxInputLength = 10;
                    config.separatedFormat = @"xxx-xxx-xxxx";
                } else {
                    config.maxInputLength = 9;
                    config.separatedFormat = @"xx-xxx-xxxx";
                }

            } else if ([self.applyModel.areaCode containsString:@"86"]) {
                config.maxInputLength = 11;
                config.separatedFormat = @"xxx-xxxx-xxxx";
            }
            [self.phoneTextfeild setConfig:config];
        }
    }

    if (!HDIsObjectNil(self.applyModel) && self.applyModel.status != TNSellerApplyStatusNone) {
        //在审核中
        [self.firstNameTextfeild setTextFieldText:self.applyModel.firstName];
        self.firstNameTextfeild.userInteractionEnabled = NO;

        [self.lastNameTextfeild setTextFieldText:self.applyModel.lastName];
        self.lastNameTextfeild.userInteractionEnabled = NO;

        [self.areaCodeBtn setTitle:[NSString stringWithFormat:@"+%@", self.applyModel.areaCode] forState:UIControlStateNormal];
        [self.phoneTextfeild setTextFieldText:self.applyModel.number];
        self.phoneTextfeild.userInteractionEnabled = NO;

        [self.wechaTextfeild setTextFieldText:self.applyModel.wechat];
        self.wechaTextfeild.userInteractionEnabled = NO;

        [self.FBTextfeild setTextFieldText:self.applyModel.facebook];
        self.FBTextfeild.userInteractionEnabled = NO;

        self.sourceChannelSelectionView.currentValueText = self.applyModel.sellerChannelValue;
        self.sourceChannelSelectionView.userInteractionEnabled = NO;
        if ([self.applyModel.sellerChannelKey isEqualToString:@"channel5"]) {
            self.otherChannelTextfeild.hidden = NO;
            [self.otherChannelTextfeild setTextFieldText:self.applyModel.sellerApplyChannelsContent];
            self.otherChannelTextfeild.userInteractionEnabled = NO;
        }

        self.customerChannelSelectionView.currentValueText = self.applyModel.customerChannelType;
        self.customerChannelSelectionView.userInteractionEnabled = NO;

        self.customerGroupSelectionView.currentValueText = self.applyModel.customerGroup;
        self.customerGroupSelectionView.userInteractionEnabled = NO;

        if (!HDIsArrayEmpty(self.applyModel.images)) {
            self.takePhotoView.imageURLs = self.applyModel.images;
        }
        self.takePhotoView.onlyRead = YES;

        self.postBtn.enabled = NO;
        self.postBtn.backgroundColor = HexColor(0xD6DBE8);
        if (self.applyModel.status == TNSellerApplyStatusApplying) {
            [self.postBtn setTitle:TNLocalizedString(@"tn_tf_reviewing", @"审核中") forState:UIControlStateNormal];
        } else if (self.applyModel.status == TNSellerApplyStatusSucess) {
            [self.postBtn setTitle:TNLocalizedString(@"hQSazy9v", @"审核通过") forState:UIControlStateNormal];
        } else if (self.applyModel.status == TNSellerApplyStatusReject) {
            [self.postBtn setTitle:TNLocalizedString(@"ImXEfCiN", @"审核不通过") forState:UIControlStateNormal];
        }

        self.isAgreeProtocol = YES;
        [self setProtocolText];
    } else if (!HDIsObjectNil(self.applyModel) && self.applyModel.status == TNSellerApplyStatusNone) {
        if (HDIsStringNotEmpty(self.applyModel.areaCode) && HDIsStringNotEmpty(self.applyModel.number)) {
            [self.areaCodeBtn setTitle:[NSString stringWithFormat:@"+%@", self.applyModel.areaCode] forState:UIControlStateNormal];
            [self.phoneTextfeild setTextFieldText:self.applyModel.number];
        }
    }

    self.sourceChannelSelectionView.keyValueArray = self.applyModel.dicValues;
    self.customerChannelSelectionView.keyValueArray = self.applyModel.customerChannelTypes;
    self.customerGroupSelectionView.keyValueArray = self.applyModel.customerGroups;

    [self.view setNeedsUpdateConstraints];
}
//检验按钮是否可以点击
- (void)checkPostBtnEeable {
    if (HDIsStringNotEmpty(self.firstNameTextfeild.validInputText) && HDIsStringNotEmpty(self.lastNameTextfeild.validInputText) && HDIsStringNotEmpty(self.phoneTextfeild.validInputText)
        && HDIsStringNotEmpty(self.applyModel.sellerApplyChannels) && HDIsStringNotEmpty(self.applyModel.customerChannelId) && HDIsStringNotEmpty(self.applyModel.customerGroupId)) {
        if ([self.applyModel.sellerApplyChannels isEqualToString:@"channel5"]) {
            if (HDIsStringNotEmpty(self.applyModel.sellerApplyChannelsContent)) {
                self.applyModel.telephoneNumber = self.phoneTextfeild.validInputText;
                self.postBtn.enabled = YES;
                self.postBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
            } else {
                self.postBtn.enabled = NO;
                self.postBtn.backgroundColor = HexColor(0xD6DBE8);
            }
        } else {
            self.applyModel.telephoneNumber = self.phoneTextfeild.validInputText;
            self.postBtn.enabled = YES;
            self.postBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        }

    } else {
        self.postBtn.enabled = NO;
        self.postBtn.backgroundColor = HexColor(0xD6DBE8);
    }
}
//设置协议文本
- (void)setProtocolText {
    NSString *postStr = [NSString stringWithFormat:@"  %@", TNLocalizedString(@"4E8dqPbE", @"提交申请，您将同意")];
    NSString *protocolStr = TNLocalizedString(@"v8e765p9", @"卖家协议");
    __block UIImage *image = self.isAgreeProtocol ? [UIImage imageNamed:@"tinhnow-selected_agree_k"] : [UIImage imageNamed:@"tinhnow-unselect_agree_k"];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size
                                                                                          alignToFont:[HDAppTheme.TinhNowFont fontMedium:12]
                                                                                            alignment:YYTextVerticalAlignmentCenter];
    [attachment yy_setTextHighlightRange:attachment.yy_rangeOfAll color:[UIColor clearColor] backgroundColor:[UIColor clearColor]
                               tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                   if (!HDIsObjectNil(self.applyModel) && self.applyModel.status != TNSellerApplyStatusApplying) {
                                       self.isAgreeProtocol = !self.isAgreeProtocol;
                                       [self setProtocolText];
                                   }
                               }];

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:postStr];
    NSMutableAttributedString *highlightText = [[NSMutableAttributedString alloc] initWithString:protocolStr];
    highlightText.yy_underlineStyle = NSUnderlineStyleSingle;
    [highlightText yy_setTextHighlightRange:highlightText.yy_rangeOfAll color:HDAppTheme.TinhNowColor.C1 backgroundColor:[UIColor clearColor]
                                  tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                      NSString *url;
                                      if ([[TNMultiLanguageManager currentLanguage] isEqualToString:SALanguageTypeCN]) {
                                          url = @"https://img.tinhnow.com/protocol/supplier_protocol_cn.html";
                                      } else if ([[TNMultiLanguageManager currentLanguage] isEqualToString:SALanguageTypeEN]) {
                                          url = @"https://img.tinhnow.com/protocol/supplier_protocol_en.html";
                                      } else if ([[TNMultiLanguageManager currentLanguage] isEqualToString:SALanguageTypeKH]) {
                                          url = @"https://img.tinhnow.com/protocol/supplier_protocol_kh.html";
                                      }
                                      [SAWindowManager openUrl:url withParameters:nil];
                                  }];
    [text insertAttributedString:attachment atIndex:0];
    [text appendAttributedString:highlightText];
    _protocolLabel.attributedText = text;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)updateViewConstraints {
    [self.postBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kRealWidth(45));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.bottom.equalTo(self.postBtn.mas_top);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.bannerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.scrollViewContainer);
        make.height.mas_equalTo(kScreenWidth * 140 / 375);
    }];
    [self.baseInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.bannerImageView.mas_bottom).offset(kRealWidth(20));
    }];
    [self.nameKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.baseInfoLabel.mas_bottom).offset(kRealWidth(10));
    }];
    [self.lastNameTextfeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.nameKeyLabel.mas_bottom).offset(kRealWidth(10));
        make.right.equalTo(self.firstNameTextfeild.mas_left).offset(-kRealWidth(20));
        make.height.mas_equalTo(kRealWidth(35));
    }];
    [self.firstNameTextfeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(35));
        make.centerY.equalTo(self.lastNameTextfeild.mas_centerY);
        make.width.equalTo(self.lastNameTextfeild.mas_width).dividedBy(1.4);
    }];

    [self.phoneKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.lastNameTextfeild.mas_bottom).offset(kRealWidth(20));
    }];
    [self.areaCodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.phoneKeyLabel.mas_bottom).offset(kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(35)));
    }];
    [self.phoneTextfeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(35));
        make.centerY.equalTo(self.areaCodeBtn.mas_centerY);
        make.left.equalTo(self.areaCodeBtn.mas_right).offset(kRealWidth(10));
    }];

    [self.sourceChannelSelectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.phoneTextfeild.mas_bottom).offset(kRealWidth(20));
    }];
    if (!self.otherChannelTextfeild.isHidden) {
        [self.otherChannelTextfeild mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.sourceChannelSelectionView.mas_bottom).offset(kRealWidth(10));
            make.height.mas_equalTo(kRealWidth(35));
        }];
    }
    [self.customerGroupSelectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        if (!self.otherChannelTextfeild.isHidden) {
            make.top.equalTo(self.otherChannelTextfeild.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.equalTo(self.sourceChannelSelectionView.mas_bottom).offset(kRealWidth(20));
        }
    }];

    [self.customerChannelSelectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.customerGroupSelectionView.mas_bottom).offset(kRealWidth(20));
    }];

    [self.takePhotoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.equalTo(self.customerChannelSelectionView.mas_bottom).offset(kRealWidth(20));
    }];

    [self.socialContackKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.takePhotoView.mas_bottom).offset(kRealWidth(40));
    }];
    [self.socialContackTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.socialContackKeyLabel.mas_bottom).offset(kRealWidth(5));
    }];
    [self.wechatKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.socialContackTipsLabel.mas_bottom).offset(kRealWidth(10));
    }];
    [self.wechaTextfeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.wechatKeyLabel.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(35));
    }];
    [self.FBKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.wechaTextfeild.mas_bottom).offset(kRealWidth(10));
    }];
    [self.FBTextfeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.FBKeyLabel.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(35));
    }];

    [self.protocolLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.FBTextfeild.mas_bottom).offset(kRealWidth(40));
    }];
    [self.contactView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollViewContainer);
        make.top.equalTo(self.protocolLabel.mas_bottom).offset(kRealWidth(40));
        make.bottom.equalTo(self.scrollViewContainer.mas_bottom).offset(-kRealWidth(20));
    }];

    [super updateViewConstraints];
}
/** @lazy bannerImageView */
- (UIImageView *)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerImageView.backgroundColor = HDAppTheme.TinhNowColor.G5;
    }
    return _bannerImageView;
}
/** @lazy baseInfoLabel */
- (UILabel *)baseInfoLabel {
    if (!_baseInfoLabel) {
        _baseInfoLabel = [[UILabel alloc] init];
        _baseInfoLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _baseInfoLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _baseInfoLabel.text = TNLocalizedString(@"k8AMY8Yk", @"基础信息");
    }
    return _baseInfoLabel;
}
/** @lazy nameKeyLabel */
- (UILabel *)nameKeyLabel {
    if (!_nameKeyLabel) {
        _nameKeyLabel = [[UILabel alloc] init];
        _nameKeyLabel.font = HDAppTheme.TinhNowFont.standard14;
        _nameKeyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        NSString *starName = @"*";
        NSString *keyStr = [NSString stringWithFormat:@"%@%@", starName, TNLocalizedString(@"JyYh19Cq", @"姓名")];
        NSMutableAttributedString *attr = [NSString highLightString:starName inLongString:keyStr font:HDAppTheme.TinhNowFont.standard14 color:HexColor(0xFF2323)];
        _nameKeyLabel.attributedText = attr;
    }
    return _nameKeyLabel;
}
- (HDUITextField *)lastNameTextfeild {
    if (!_lastNameTextfeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:12];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.keyboardType = UIKeyboardTypeDefault;
        config.maxInputLength = 100;
        config.bottomLineSelectedHeight = 0;
        config.bottomLineNormalHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.placeholder = TNLocalizedString(@"RYq526RH", @"名字");
        config.placeholderColor = HDAppTheme.TinhNowColor.G3;
        config.placeholderFont = [HDAppTheme.TinhNowFont fontRegular:12];
        [textField setConfig:config];
        [textField setCustomLeftView:UIView.new];
        [textField setCustomRightView:UIView.new];
        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            self.applyModel.lastName = text;
            [self checkPostBtnEeable];
        };
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        _lastNameTextfeild = textField;
    }
    return _lastNameTextfeild;
}
- (HDUITextField *)firstNameTextfeild {
    if (!_firstNameTextfeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:12];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.keyboardType = UIKeyboardTypeDefault;
        config.maxInputLength = 100;
        config.bottomLineSelectedHeight = 0;
        config.bottomLineNormalHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.placeholder = TNLocalizedString(@"QccMJkwF", @"姓");
        config.placeholderColor = HDAppTheme.TinhNowColor.G3;
        config.placeholderFont = [HDAppTheme.TinhNowFont fontRegular:12];
        [textField setConfig:config];
        [textField setCustomLeftView:UIView.new];
        [textField setCustomRightView:UIView.new];
        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            self.applyModel.firstName = text;
            [self checkPostBtnEeable];
        };
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        _firstNameTextfeild = textField;
    }
    return _firstNameTextfeild;
}
/** @lazy phoneKeyLabel */
- (UILabel *)phoneKeyLabel {
    if (!_phoneKeyLabel) {
        _phoneKeyLabel = [[UILabel alloc] init];
        _phoneKeyLabel.font = HDAppTheme.TinhNowFont.standard14;
        _phoneKeyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        NSString *starName = @"*";
        NSString *keyStr = [NSString stringWithFormat:@"%@%@", starName, TNLocalizedString(@"tn_tf_contact", @"联系电话")];
        NSMutableAttributedString *attr = [NSString highLightString:starName inLongString:keyStr font:HDAppTheme.TinhNowFont.standard14 color:HexColor(0xFF2323)];
        _phoneKeyLabel.attributedText = attr;
    }
    return _phoneKeyLabel;
}

/** @lazy areaCodeBtn */
- (HDUIButton *)areaCodeBtn {
    if (!_areaCodeBtn) {
        _areaCodeBtn = [[HDUIButton alloc] init];
        _areaCodeBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
        [_areaCodeBtn setTitle:@"+855" forState:UIControlStateNormal];
        [_areaCodeBtn setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _areaCodeBtn.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        _areaCodeBtn.layer.borderWidth = 0.5;
        _areaCodeBtn.layer.cornerRadius = 4;
        _areaCodeBtn.layer.masksToBounds = YES;
        _areaCodeBtn.userInteractionEnabled = NO;
    }
    return _areaCodeBtn;
}
/** @lazy phoneTextfeild */
- (HDUITextField *)phoneTextfeild {
    if (!_phoneTextfeild) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:SALocalizedString(@"placeholder_input_phone_number", @"输入手机号码") leftLabelString:nil];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:12];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.placeholderColor = HDAppTheme.TinhNowColor.G3;
        config.placeholderFont = [HDAppTheme.TinhNowFont fontRegular:12];
        config.shouldSeparatedTextWithSymbol = YES;
        config.floatingText = @" ";
        config.characterSetString = kCharacterSetStringNumber;
        config.maxInputLength = 10;
        config.separatedFormat = @"xx-xxx-xxxx";
        config.bottomLineSelectedHeight = 0;
        config.bottomLineNormalHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        [textField setConfig:config];
        [textField setCustomLeftView:UIView.new];
        [textField setCustomRightView:UIView.new];
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        textField.userInteractionEnabled = NO; //手机号码不能编辑
        _phoneTextfeild = textField;
    }
    return _phoneTextfeild;
}
/** @lazy sourceChannelSelectionView */
- (TNApplyDropDownSelectionView *)sourceChannelSelectionView {
    if (!_sourceChannelSelectionView) {
        _sourceChannelSelectionView = [[TNApplyDropDownSelectionView alloc] initSelectionViewWithKeyText:TNLocalizedString(@"8L5GjYrU", @"您是从哪里了解到招商信息")
                                                                                           placeHoldText:TNLocalizedString(@"k2UgCi7p", @"请选择信息来源的渠道")];
        @HDWeakify(self);
        _sourceChannelSelectionView.selectedCallBack = ^(NSString *_Nonnull key, NSString *_Nonnull value) {
            @HDStrongify(self);
            self.applyModel.sellerChannelValue = value;
            self.applyModel.sellerApplyChannels = key;
            [self checkPostBtnEeable];
            if ([key isEqualToString:@"channel5"]) {
                self.otherChannelTextfeild.hidden = NO;
            } else {
                self.otherChannelTextfeild.hidden = YES;
            }
            [self.view setNeedsUpdateConstraints];
        };
    }
    return _sourceChannelSelectionView;
}
/** @lazy customerGroupSelectionView */
- (TNApplyDropDownSelectionView *)customerGroupSelectionView {
    if (!_customerGroupSelectionView) {
        _customerGroupSelectionView = [[TNApplyDropDownSelectionView alloc] initSelectionViewWithKeyText:TNLocalizedString(@"5Wyjqy9b", @"客户群体")
                                                                                           placeHoldText:TNLocalizedString(@"puzB8PGj", @"请选择客户群体")];
        @HDWeakify(self);
        _customerGroupSelectionView.selectedCallBack = ^(NSString *_Nonnull key, NSString *_Nonnull value) {
            @HDStrongify(self);
            self.applyModel.customerGroupId = key;
            self.applyModel.customerGroup = value;
            [self checkPostBtnEeable];
        };
    }
    return _customerGroupSelectionView;
}

/** @lazy customerChannelSelectionView */
- (TNApplyDropDownSelectionView *)customerChannelSelectionView {
    if (!_customerChannelSelectionView) {
        _customerChannelSelectionView = [[TNApplyDropDownSelectionView alloc] initSelectionViewWithKeyText:TNLocalizedString(@"umX4vUZT", @"客户渠道类型")
                                                                                             placeHoldText:TNLocalizedString(@"G3osrW8A", @"请选择客户渠道类型")];
        @HDWeakify(self);
        _customerChannelSelectionView.selectedCallBack = ^(NSString *_Nonnull key, NSString *_Nonnull value) {
            @HDStrongify(self);
            self.applyModel.customerChannelId = key;
            self.applyModel.customerChannelType = value;
            [self checkPostBtnEeable];
        };
    }
    return _customerChannelSelectionView;
}
- (HDUITextField *)otherChannelTextfeild {
    if (!_otherChannelTextfeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:12];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.keyboardType = UIKeyboardTypeDefault;
        config.maxInputLength = 50;
        config.bottomLineSelectedHeight = 0;
        config.bottomLineNormalHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.placeholder = TNLocalizedString(@"tn_input", @"请输入");
        config.placeholderColor = HDAppTheme.TinhNowColor.G3;
        config.placeholderFont = [HDAppTheme.TinhNowFont fontRegular:12];
        [textField setConfig:config];
        [textField setCustomLeftView:UIView.new];
        [textField setCustomRightView:UIView.new];
        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            self.applyModel.sellerApplyChannelsContent = text;
            [self checkPostBtnEeable];
        };
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        textField.hidden = YES;
        _otherChannelTextfeild = textField;
    }
    return _otherChannelTextfeild;
}

/** @lazy socialContackKeyLabel */
- (UILabel *)socialContackKeyLabel {
    if (!_socialContackKeyLabel) {
        _socialContackKeyLabel = [[UILabel alloc] init];
        _socialContackKeyLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _socialContackKeyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _socialContackKeyLabel.text = TNLocalizedString(@"FUnQzh0X", @"社交账号");
    }
    return _socialContackKeyLabel;
}
/** @lazy socialContackTipsLabel */
- (UILabel *)socialContackTipsLabel {
    if (!_socialContackTipsLabel) {
        _socialContackTipsLabel = [[UILabel alloc] init];
        _socialContackTipsLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _socialContackTipsLabel.textColor = HDAppTheme.TinhNowColor.C1;
        _socialContackTipsLabel.text = TNLocalizedString(@"RlR6dmg8", @"请至少填写一个，以方便平台客服联系您");
        _socialContackKeyLabel.numberOfLines = 0;
    }
    return _socialContackTipsLabel;
}
/** @lazy wechatKeyLabel */
- (UILabel *)wechatKeyLabel {
    if (!_wechatKeyLabel) {
        _wechatKeyLabel = [[UILabel alloc] init];
        _wechatKeyLabel.font = HDAppTheme.TinhNowFont.standard14;
        _wechatKeyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _wechatKeyLabel.text = @"Wechat";
    }
    return _wechatKeyLabel;
}
/** @lazy FBKeyLabel */
- (UILabel *)FBKeyLabel {
    if (!_FBKeyLabel) {
        _FBKeyLabel = [[UILabel alloc] init];
        _FBKeyLabel.font = HDAppTheme.TinhNowFont.standard14;
        _FBKeyLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _FBKeyLabel.text = @"Facebook";
    }
    return _FBKeyLabel;
}
- (HDUITextField *)wechaTextfeild {
    if (!_wechaTextfeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:12];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.keyboardType = UIKeyboardTypeDefault;
        config.maxInputLength = 100;
        config.bottomLineSelectedHeight = 0;
        config.bottomLineNormalHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.placeholder = TNLocalizedString(@"MdpCJEUA", @"请输入微信号");
        config.placeholderColor = HDAppTheme.TinhNowColor.G3;
        config.placeholderFont = [HDAppTheme.TinhNowFont fontRegular:12];
        [textField setConfig:config];
        [textField setCustomLeftView:UIView.new];
        [textField setCustomRightView:UIView.new];
        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            self.applyModel.wechat = text;
            [self checkPostBtnEeable];
        };
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        _wechaTextfeild = textField;
    }
    return _wechaTextfeild;
}

- (HDUITextField *)FBTextfeild {
    if (!_FBTextfeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.TinhNowFont fontMedium:12];
        config.textColor = HDAppTheme.TinhNowColor.G1;
        config.keyboardType = UIKeyboardTypeDefault;
        config.maxInputLength = 100;
        config.bottomLineSelectedHeight = 0;
        config.bottomLineNormalHeight = 0;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.placeholder = TNLocalizedString(@"qaL4cY5J", @"请输入Facebook账号");
        config.placeholderColor = HDAppTheme.TinhNowColor.G3;
        config.placeholderFont = [HDAppTheme.TinhNowFont fontRegular:12];
        [textField setConfig:config];
        [textField setCustomLeftView:UIView.new];
        [textField setCustomRightView:UIView.new];
        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            self.applyModel.facebook = text;
            [self checkPostBtnEeable];
        };
        textField.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:219 / 255.0 blue:232 / 255.0 alpha:1.0].CGColor;
        textField.layer.borderWidth = 0.5;
        textField.layer.cornerRadius = 4;
        _FBTextfeild = textField;
    }
    return _FBTextfeild;
}
/** @lazy protocolLabel */
- (YYLabel *)protocolLabel {
    if (!_protocolLabel) {
        _protocolLabel = [[YYLabel alloc] init];
        _protocolLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _protocolLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _protocolLabel.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(30);
    }
    return _protocolLabel;
}
/** @lazy contactView */
- (TNQuestionAndContactView *)contactView {
    if (!_contactView) {
        _contactView = [[TNQuestionAndContactView alloc] init];
    }
    return _contactView;
}
/** @lazy postBtn */
- (HDUIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [[HDUIButton alloc] init];
        [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _postBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:17];
        _postBtn.backgroundColor = HDAppTheme.TinhNowColor.C1;
        [_postBtn setTitle:TNLocalizedString(@"Xz9Wnnq6", @"提交申请") forState:UIControlStateNormal];
        [_postBtn addTarget:self action:@selector(onClickPostApply) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}
/** @lazy applyDTO */
- (TNSellerApplyDTO *)applyDTO {
    if (!_applyDTO) {
        _applyDTO = [[TNSellerApplyDTO alloc] init];
    }
    return _applyDTO;
}
/** @lazy takePhotoView */
- (TNTakePhotoView *)takePhotoView {
    if (!_takePhotoView) {
        TNTakePhotoConfig *config = [[TNTakePhotoConfig alloc] init];
        config.desText = TNLocalizedString(@"JxpZtQMe", @"门店图片");
        _takePhotoView = [[TNTakePhotoView alloc] initWithConfig:config];
    }
    return _takePhotoView;
}
- (SAUploadImageDTO *)uploadImageDTO {
    return _uploadImageDTO ?: ({ _uploadImageDTO = SAUploadImageDTO.new; });
}
@end
