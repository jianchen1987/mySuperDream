//
//  PNMSOpenResultController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOpenResultController.h"
#import "PNCommonUtils.h"
#import "PNMSHomeDTO.h"
#import "PNMSInfoModel.h"
#import "PNMSStepView.h"


@interface PNMSOpenResultController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topWhiteView;
@property (nonatomic, strong) PNMSStepView *stepView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *stateLabel;
@property (nonatomic, strong) SALabel *msgLabel;
@property (nonatomic, strong) HDUIButton *btn;
@property (nonatomic, strong) PNMSHomeDTO *homeDTO;
@property (nonatomic, strong) PNMSInfoModel *infoModel;
@end


@implementation PNMSOpenResultController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"ms_open_merchant", @"开通商户");
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    [self.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletController") animated:YES];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.bgView];
    self.bgView.hidden = YES;

    [self.bgView addSubview:self.topWhiteView];
    [self.bgView addSubview:self.stepView];
    [self.bgView addSubview:self.iconImgView];
    [self.bgView addSubview:self.stateLabel];
    [self.bgView addSubview:self.msgLabel];
    [self.bgView addSubview:self.btn];
}

- (void)hd_bindViewModel {
    [self.view showloading];
    @HDWeakify(self);
    [self.homeDTO getMerchantServicesInfo:^(PNMSInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        self.infoModel = rspModel;
        self.bgView.hidden = NO;
        self.btn.hidden = YES;
        UIImage *imageStr;
        if (rspModel.status == PNMerchantStatusFailed) {
            imageStr = [UIImage imageNamed:@"pn_ms_apply_reject"];
            self.btn.hidden = NO;
            [self.btn setTitle:PNLocalizedString(@"ms_apply_again", @"重新申请") forState:0];
            self.btn.tag = 100;
        } else if (rspModel.status == PNMerchantStatusEnable) {
            imageStr = [UIImage imageNamed:@"pn_ms_apply_success"];
            self.btn.hidden = NO;
            [self.btn setTitle:PNLocalizedString(@"ms_enter_mserchant_services", @"进入商户服务") forState:0];
            self.btn.tag = 200;
        } else if (rspModel.status == PNMerchantStatusReviewing) {
            imageStr = [UIImage imageNamed:@"pn_ms_apply_ing"];
        }
        self.iconImgView.image = imageStr;
        self.stateLabel.text = [PNCommonUtils getMerchantStatusName:rspModel.status];
        self.msgLabel.text = rspModel.desc;

        [self.view setNeedsUpdateConstraints];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)updateViewConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.topWhiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.equalTo(@(kRealWidth(12)));
    }];
    [self.stepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left);
        make.right.mas_equalTo(self.bgView.mas_right);
        make.top.mas_equalTo(self.topWhiteView.mas_bottom);
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.stepView.mas_bottom).offset(kRealWidth(24));
    }];

    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.iconImgView.mas_bottom);
    }];

    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.stateLabel.mas_bottom).offset(kRealWidth(8));
    }];

    [self.btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-12));
        make.height.equalTo(@(48));
        make.bottom.mas_equalTo(self.bgView).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(30)));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        view.hidden = YES;
        _bgView = view;
    }
    return _bgView;
}

- (PNMSStepView *)stepView {
    if (!_stepView) {
        _stepView = [[PNMSStepView alloc] init];
        _stepView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        [_stepView layoutIfNeeded];

        NSMutableArray<PNMSStepItemModel *> *list = [NSMutableArray arrayWithCapacity:3];
        PNMSStepItemModel *model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_3_hight"];
        model.titleStr = @"01";
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), 0, 0, 0);
        model.titleFont = [HDAppTheme.PayNowFont fontDINBlack:20];
        ;
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.subTitleStr = PNLocalizedString(@"ms_submit_apply", @"提交申请");
        model.subTitleColor = HDAppTheme.PayNowColor.c666666;
        model.subTitleFont = HDAppTheme.PayNowFont.standard12;
        [list addObject:model];

        model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_3_hight"];
        model.titleStr = @"02";
        model.titleFont = [HDAppTheme.PayNowFont fontDINBlack:20];
        model.titleColor = HDAppTheme.PayNowColor.c333333;
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), 0, 0, 0);
        model.subTitleStr = PNLocalizedString(@"ms_approval_merchant_info", @"审核商户信息");
        model.subTitleColor = HDAppTheme.PayNowColor.c666666;
        model.subTitleFont = HDAppTheme.PayNowFont.standard12;
        [list addObject:model];

        model = PNMSStepItemModel.new;
        model.iconImage = [UIImage imageNamed:@"pn_3_hight"];
        model.titleStr = @"03";
        model.titleFont = [HDAppTheme.PayNowFont fontDINBlack:20];
        ;
        model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), 0, 0, 0);
        model.subTitleStr = PNLocalizedString(@"ms_open_success", @"开通成功");
        model.subTitleFont = HDAppTheme.PayNowFont.standard12;
        [list addObject:model];

        [_stepView setModelList:list step:1];
    }
    return _stepView;
}

- (UIView *)topWhiteView {
    if (!_topWhiteView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _topWhiteView = view;
    }
    return _topWhiteView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_ms_apply_ing"];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (SALabel *)stateLabel {
    if (!_stateLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        _stateLabel = label;
    }
    return _stateLabel;
}

- (SALabel *)msgLabel {
    if (!_msgLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15;

        label.numberOfLines = 0;
        _msgLabel = label;
    }
    return _msgLabel;
}

- (HDUIButton *)btn {
    if (!_btn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"ms_apply_again", @"重新申请") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard16B;
        button.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
        button.hidden = YES;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            if (self.btn.tag == 100) {
                /// 重新申请
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesApplyOpenVC:@{
                    @"merchantNo": self.infoModel.mainMerchantNo,
                }];
            } else if (self.btn.tag == 200) {
                /// 进入服务商
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesHomeVC:@{}];
            }
        }];

        _btn = button;
    }
    return _btn;
}

- (PNMSHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = [[PNMSHomeDTO alloc] init];
    }
    return _homeDTO;
}
@end
