//
//  PNPacketOpenView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketOpenView.h"
#import "PNMultiLanguageManager.h"
#import "PNPacketOpenDTO.h"
#import "PNRspModel.h"


@interface PNPacketOpenView () <HDUITextFieldDelegate>
@property (nonatomic, strong) UIImageView *packetImgView;
@property (nonatomic, strong) HDUIButton *openBtn;

@property (nonatomic, strong) UIView *userNameBgView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) SALabel *nameLabel;

@property (nonatomic, strong) SALabel *remarksLabel;

@property (nonatomic, strong) HDUITextField *inputTF;

@property (nonatomic, strong) SALabel *bottomTipsLabel;
@property (nonatomic, strong) HDUIButton *resultBtn;
@property (nonatomic, strong) SALabel *resultLabel;

@property (nonatomic, strong) HDUIButton *closeBtn;

@property (nonatomic, strong) PNPacketOpenDTO *openDTO;

@property (nonatomic, copy) NSString *packetId;
@property (nonatomic, assign) PNPacketType packetType;
@property (nonatomic, strong) PNPacketDetailModel *model;

@property (nonatomic, assign) CGFloat maxNameWidth;
@end


@implementation PNPacketOpenView

- (instancetype)initWithModel:(PNPacketDetailModel *)model {
    if (self = [super init]) {
        self.model = model;
        self.maxNameWidth = kScreenWidth - kRealWidth(70) - kRealWidth(24) - kRealWidth(4) - kRealWidth(24);
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];
}

#pragma mark - override
- (void)layoutContainerView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(35));
        make.centerY.equalTo(self.mas_centerY).offset(-kRealWidth(30));
    }];
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 8;
}

- (void)closeAction {
    [self dismiss];
    !self.closeBtnBlock ?: self.closeBtnBlock();
}

- (void)setupContainerSubViews {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(closeAction) name:kNotificationNameUserLogout object:nil];

    self.containerView.backgroundColor = [UIColor clearColor];
    // 给containerview添加子视图
    [self.containerView addSubview:self.packetImgView];
    [self.containerView addSubview:self.openBtn];

    [self.packetImgView addSubview:self.userNameBgView];
    [self.userNameBgView addSubview:self.headImgView];
    [self.userNameBgView addSubview:self.nameLabel];
    [self.packetImgView addSubview:self.remarksLabel];
    [self.packetImgView addSubview:self.inputTF];
    [self.packetImgView addSubview:self.bottomTipsLabel];
    [self.packetImgView addSubview:self.resultBtn];
    [self.packetImgView addSubview:self.resultLabel];

    [self.containerView addSubview:self.closeBtn];

    [HDWebImageManager setImageWithURL:self.model.hearUrl placeholderImage:[UIImage imageNamed:@"pn_default_user_neutral"] imageView:self.headImgView];
    self.nameLabel.text = self.model.sendName;

    self.remarksLabel.text = self.model.remarks;

    if (self.model.packetType == PNPacketType_Password) {
        self.inputTF.hidden = NO;
    } else {
        self.inputTF.hidden = YES;
    }

    [HDWebImageManager setImageWithURL:self.model.imageUrl placeholderImage:[UIImage imageNamed:@"pn_packet_cover_big"] imageView:self.packetImgView];

    if (self.model.currentStatus == PNPacketMessageStatus_PARTIAL_RECEIVE) {
        [self setResetView:@"LP20014"];
    } else if (self.model.currentStatus == PNPacketMessageStatus_EXPIRED) {
        [self setResetView:@"LP20002"];
    } else if (self.model.currentStatus == PNPacketMessageStatus_NO_WAITING) {
        [self setResetView:@"LP20003"];
    }
}

- (void)layoutContainerViewSubViews {
    [self.packetImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(295), kRealWidth(420)));
        make.left.top.right.equalTo(self.containerView);
    }];

    [self.openBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.openBtn.imageView.image.size);
        make.top.mas_equalTo(self.containerView.mas_top).offset(kRealWidth(50));
        make.centerX.mas_equalTo(self.containerView.mas_centerX);
    }];

    [self.userNameBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.openBtn.mas_bottom);
        make.centerX.mas_equalTo(self.packetImgView.mas_centerX);
    }];

    [self.headImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(24), kRealWidth(24)));
        make.top.bottom.left.mas_equalTo(self.userNameBgView);
    }];

    [self.nameLabel sizeToFit];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImgView.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(self.userNameBgView.mas_right);
        make.centerY.mas_equalTo(self.headImgView.mas_centerY);
        if (self.nameLabel.hd_width > self.maxNameWidth) {
            make.width.equalTo(@(self.maxNameWidth));
        }
    }];

    [self.remarksLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.packetImgView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.packetImgView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.userNameBgView.mas_bottom).offset(kRealWidth(12));
    }];

    if (!self.inputTF.hidden) {
        [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.packetImgView.mas_left).offset(kRealWidth(16));
            make.right.mas_equalTo(self.packetImgView.mas_right).offset(-kRealWidth(16));
            make.top.mas_equalTo(self.remarksLabel.mas_bottom).offset(kRealWidth(16));
            make.height.equalTo(@(kRealWidth(44)));
        }];
    }

    if (!self.bottomTipsLabel.hidden) {
        [self.bottomTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.packetImgView.mas_left).offset(kRealWidth(12));
            make.right.mas_equalTo(self.packetImgView.mas_right).offset(-kRealWidth(12));
            make.bottom.mas_equalTo(self.packetImgView.mas_bottom).offset(-kRealWidth(12));
        }];
    }

    if (!self.resultBtn.hidden) {
        [self.resultBtn sizeToFit];
        [self.resultBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.packetImgView.mas_left).offset(kRealWidth(12));
            make.right.mas_equalTo(self.packetImgView.mas_right).offset(-kRealWidth(12));
            make.bottom.mas_equalTo(self.packetImgView.mas_bottom);
            make.centerX.mas_equalTo(self.packetImgView.mas_centerX);
        }];

        [self.resultLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.packetImgView.mas_left).offset(kRealWidth(12));
            make.right.mas_equalTo(self.packetImgView.mas_right).offset(-kRealWidth(12));
            make.bottom.mas_equalTo(self.resultBtn.mas_top).offset(-kRealWidth(30));
        }];
    }

    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.packetImgView.mas_centerX);
        make.top.mas_equalTo(self.packetImgView.mas_bottom).offset(kRealWidth(30));
        make.bottom.equalTo(self.containerView);
    }];
}

#pragma mark
////// 开始动画
- (void)beginAnimation:(HDUIButton *)sender {
    if (WJIsStringEmpty(self.inputTF.validInputText) && self.model.packetType == PNPacketType_Password) {
        [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_input_packet_password", @"请输入口令") type:HDTopToastTypeWarning];

        return;
    }

    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnima.toValue = [NSNumber numberWithFloat:M_PI];
    transformAnima.duration = 0.5;
    transformAnima.cumulative = YES;
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = HUGE_VALF;
    transformAnima.fillMode = kCAFillModeForwards;
    transformAnima.removedOnCompletion = NO;
    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    sender.layer.zPosition = 5;
    sender.layer.zPosition = sender.layer.frame.size.width / 2.f;
    [sender.layer addAnimation:transformAnima forKey:@"open_packet_rotationAnimationY"];
    sender.userInteractionEnabled = NO;

    [self openAction];
}

/// 开红包
- (void)openAction {
    @HDWeakify(self);
    [self.openDTO openPacket:self.model.packetId password:self.inputTF.validInputText.uppercaseString success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);

        [self.openBtn.layer removeAnimationForKey:@"open_packet_rotationAnimationY"];
        self.openBtn.hidden = YES;

        [self closeAction];

        [HDMediator.sharedInstance navigaveToPacketDetailVC:@{
            @"packetId": self.model.packetId,
            @"viewType": @"reciver",
        }];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);

        [self.openBtn.layer removeAnimationForKey:@"open_packet_rotationAnimationY"];
        self.openBtn.userInteractionEnabled = YES;

        /// 额外处理特殊的code
        if (WJIsObjectNil(rspModel)) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"network_no_network", @"网络开小差啦") type:HDTopToastTypeError];
        } else {
            /*
             错误码
             LP_ORDER_NOT_EXIST("LP10001", "红包订单不存在", "", ""),
             LP_PACKET_EXPIRE("LP20002","红包已过期", "", ""),
             LP_PACKET_ERROR_KEY("LP20004","口令错误", "", ""),
             KYC_UPGRADE("LP20005","KYC升级中","",""),
             LP_PACKET_ERROR_USER("LP_20013", "非红包领取用户", "", ""),
             LP_PACKET_CHECKING("LP_20011", "红包领取中", "", ""),
             LP_HAS_CHECK("LP20004","红包已领取","",""),
             LP_PACKET_OVER("LP20003","红包已领完", "", ""),
             OVER_BALANCE("LP20006","用户额度已超","",""),
             */
            NSString *errorCode = rspModel.code;
            if ([errorCode isEqualToString:@"LP20002"] || [errorCode isEqualToString:@"LP20003"] || [errorCode isEqualToString:@"LP20014"] || [errorCode isEqualToString:@"LP20006"] ||
                [errorCode isEqualToString:@"LP20111"]) {
                [self setResetView:errorCode];
            } else {
                [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                  handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                      [alertView dismiss];
                                  }];
            }
        }
    }];
}

- (void)setResetView:(NSString *)code {
    /*
     错误码
     LP_ORDER_NOT_EXIST("LP10001", "红包订单不存在", "", ""),
     LP_PACKET_EXPIRE("LP20002","红包已过期", "", ""),
     LP_PACKET_ERROR_KEY("LP20004","口令错误", "", ""),
     KYC_UPGRADE("LP20005","KYC升级中","",""),
     LP_PACKET_ERROR_USER("LP_20013", "非红包领取用户", "", ""),
     LP_PACKET_CHECKING("LP_20011", "红包领取中", "", ""),
     LP_PACKET_CHECKING("LP20111", "用户等级过低", "", ""),
     LP_HAS_CHECK("LP20014","红包已领取","",""),
     LP_PACKET_OVER("LP20003","红包已领完", "", ""),
     OVER_BALANCE("LP20006","用户额度已超","",""),
     */
    self.openBtn.hidden = YES;
    self.inputTF.hidden = YES;

    if ([code isEqualToString:@"LP20002"]) {
        /// 红包已过期
        self.resultLabel.text = PNLocalizedString(@"pn_red_packet_expired", @"红包已过期");
        [self.resultBtn setTitle:[NSString stringWithFormat:@"%@ >", PNLocalizedString(@"pn_Look_at_your_luck", @"看看大家的手气")] forState:UIControlStateNormal];
        [self.resultBtn addTarget:self action:@selector(goToPacketOrderDetial) forControlEvents:UIControlEventTouchUpInside];

    } else if ([code isEqualToString:@"LP20003"]) {
        self.resultLabel.text = PNLocalizedString(@"pn_red_packet_Run_out", @"红包已领完");
        [self.resultBtn setTitle:[NSString stringWithFormat:@"%@ >", PNLocalizedString(@"pn_Look_at_your_luck", @"看看大家的手气")] forState:UIControlStateNormal];
        [self.resultBtn addTarget:self action:@selector(goToPacketOrderDetial) forControlEvents:UIControlEventTouchUpInside];
    } else if ([code isEqualToString:@"LP20014"]) {
        /// 红包已领取
        self.resultLabel.text = PNLocalizedString(@"pn_Red_packets_have_been_opened", @"红包已领取");
        [self.resultBtn setTitle:[NSString stringWithFormat:@"%@ >", PNLocalizedString(@"pn_Look_at_your_luck", @"看看大家的手气")] forState:UIControlStateNormal];
        [self.resultBtn addTarget:self action:@selector(goToPacketOrderDetial) forControlEvents:UIControlEventTouchUpInside];
    } else if ([code isEqualToString:@"LP20006"]) {
        /// 用户额度已超
        self.resultLabel.text = PNLocalizedString(@"pn_exceeds_maximum_your_account", @"哎呀，我的财富溢出了");
        [self.resultBtn setTitle:[NSString stringWithFormat:@"%@ >", PNLocalizedString(@"pn_go_to_transfer", @"去转账")] forState:UIControlStateNormal];
        [self.resultBtn addTarget:self action:@selector(goToTranserList) forControlEvents:UIControlEventTouchUpInside];
    } else if ([code isEqualToString:@"LP20111"]) {
        /// 用户等级过低
        self.resultLabel.text = PNLocalizedString(@"pn_upgrade_your_account_to_receive_packet", @"哎呀，我太低调了");
        [self.resultBtn setTitle:[NSString stringWithFormat:@"%@ >", PNLocalizedString(@"Go_to_upgrade", @"去升级")] forState:UIControlStateNormal];
        [self.resultBtn addTarget:self action:@selector(goToUpgrade) forControlEvents:UIControlEventTouchUpInside];
    }

    self.resultBtn.hidden = NO;
    self.resultLabel.hidden = NO;
    self.bottomTipsLabel.hidden = YES;

    [self layoutContainerViewSubViews];
}

- (void)goToUpgrade {
    [self closeAction];
    [HDMediator.sharedInstance navigaveToPayNowAccountInfoVC:@{}];
}

- (void)goToTranserList {
    [self closeAction];
    [HDMediator.sharedInstance navigaveToPayNowTransListVC:@{}];
}

- (void)goToPacketOrderDetial {
    [self closeAction];

    [HDMediator.sharedInstance navigaveToPacketDetailVC:@{
        @"packetId": self.model.packetId,
        @"viewType": @"reciver",
    }];
}

#pragma mark
- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    [self beginAnimation:self.openBtn];
}

#pragma mark
- (UIImageView *)packetImgView {
    if (!_packetImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"pn_packet_cover_big"];
        _packetImgView = imageView;
    }
    return _packetImgView;
}

- (HDUIButton *)openBtn {
    if (!_openBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageStr = @"pn_open_en";
        if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
            imageStr = @"pn_open_cn";
        } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeEN]) {
            imageStr = @"pn_open_en";
        } else if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeKH]) {
            imageStr = @"pn_open_kh";
        }
        [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = NO;
        [button addTarget:self action:@selector(beginAnimation:) forControlEvents:UIControlEventTouchUpInside];

        _openBtn = button;
    }
    return _openBtn;
}

- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_openPacket_close"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self closeAction];
        }];

        _closeBtn = button;
    }
    return _closeBtn;
}

- (UIView *)userNameBgView {
    if (!_userNameBgView) {
        UIView *view = [[UIView alloc] init];
        _userNameBgView = view;
    }
    return _userNameBgView;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _headImgView = imageView;

        _headImgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(4)];
        };
    }
    return _headImgView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#FFE589"];
        label.font = HDAppTheme.PayNowFont.standard12;
        _nameLabel = label;
    }
    return _nameLabel;
}

- (SALabel *)remarksLabel {
    if (!_remarksLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#FFE589"];
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.textAlignment = NSTextAlignmentCenter;
        _remarksLabel = label;
    }
    return _remarksLabel;
}

- (HDUITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[HDUITextField alloc] initWithPlaceholder:PNLocalizedString(@"pn_input_packet_password", @"请输入口令") leftLabelString:nil];
        _inputTF.delegate = self;
        HDUITextFieldConfig *config = [_inputTF getCurrentConfig];
        config.floatingText = @"";
        config.font = HDAppTheme.PayNowFont.standard16B;
        config.textColor = HDAppTheme.PayNowColor.c333333;
        config.marginBottomLineToTextField = 0;
        config.placeholderFont = HDAppTheme.PayNowFont.standard16;
        config.placeholderColor = [UIColor hd_colorWithHexString:@"#D6D8DB"];
        config.marginFloatingLabelToTextField = -15;
        config.bottomLineNormalHeight = 0;
        config.textAlignment = NSTextAlignmentCenter;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.maxInputLength = 8;
        _inputTF.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _inputTF.layer.cornerRadius = kRealWidth(8);

        [_inputTF setConfig:config];

        @HDWeakify(self);
        _inputTF.textFieldDidChangeBlock = ^(NSString *text) {
//            @HDStrongify(self);
        };

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPadCanSwitchToLetter theme:theme];

        kb.inputSource = _inputTF.inputTextField;
        _inputTF.inputTextField.inputView = kb;
    }
    return _inputTF;
}

- (SALabel *)bottomTipsLabel {
    if (!_bottomTipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#FFE589"];
        label.font = [HDAppTheme.PayNowFont fontRegular:9];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"pn_not_open_will_be_refunded", @"未领取的红包，将于24小时后退回到WN钱包");
        _bottomTipsLabel = label;
    }
    return _bottomTipsLabel;
}

- (HDUIButton *)resultBtn {
    if (!_resultBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        [button setTitle:@"去升级 >" forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
        button.hidden = YES;
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
        }];

        _resultBtn = button;
    }
    return _resultBtn;
}

- (SALabel *)resultLabel {
    if (!_resultLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#FFE589"];
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.textAlignment = NSTextAlignmentCenter;
        _resultLabel = label;
    }
    return _resultLabel;
}

- (PNPacketOpenDTO *)openDTO {
    if (!_openDTO) {
        _openDTO = [[PNPacketOpenDTO alloc] init];
    }
    return _openDTO;
}

@end
