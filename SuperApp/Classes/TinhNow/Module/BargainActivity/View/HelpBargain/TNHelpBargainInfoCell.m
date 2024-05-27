//
//  TNHelpBargainInfoCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHelpBargainInfoCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNBargainCountDownView.h"
#import "TNBargainRuleModel.h"
#import "TNNotificationConst.h"


@interface TNHelpBargainInfoCell ()
/// 圆角背景
@property (strong, nonatomic) UIView *bgView;
/// 助力状态提示文本
@property (strong, nonatomic) HDLabel *bargainStatusTipsLabel;
/// 倒计时视图
@property (strong, nonatomic) TNBargainCountDownView *countDownView;
/// 发起人信息栏目
@property (strong, nonatomic) UIView *sponInfoBgView;
/// 发起人头像
@property (strong, nonatomic) UIImageView *sponHeaderImageView;
/// 文案
@property (strong, nonatomic) HDLabel *messageLabel;
/// 助力金额信息
@property (strong, nonatomic) HDLabel *bargainChargeLabel;
/// 操作按钮
@property (strong, nonatomic) HDUIButton *oprateBtn;
/// 发起我的助力按钮  只在未砍价的情况下出现
@property (strong, nonatomic) HDUIButton *startMyBargainBtn;
/// 头像视图
@property (strong, nonatomic) UIView *avatarsView;

@end


@implementation TNHelpBargainInfoCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.bargainStatusTipsLabel];
    [self.bgView addSubview:self.sponInfoBgView];
    [self.sponInfoBgView addSubview:self.sponHeaderImageView];
    [self.sponInfoBgView addSubview:self.messageLabel];
    [self.bgView addSubview:self.bargainChargeLabel];
    [self.bgView addSubview:self.countDownView];
    [self.bgView addSubview:self.oprateBtn];
    [self.bgView addSubview:self.startMyBargainBtn];
    [self.bgView addSubview:self.avatarsView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNoti) name:kNotificationNameBargainCountTime object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]; //按钮在动画期间  不接受点击事件  将点击事件交给父视图
    [self.bgView addGestureRecognizer:tap];
}
- (void)setModel:(TNBargainDetailModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.userTaskInfoVO.userImage placeholderImage:[UIImage imageNamed:@"tinhnow-default-avatar"] imageView:self.sponHeaderImageView];

    self.startMyBargainBtn.hidden = YES;
    switch (model.status) {
        case TNBargainGoodStatusOngoing: {
            //进行中需要判断是否已经砍过
            if (model.isHelpedBargain) {
                [self updateHasBargainUI];
            } else {
                [self updateNotBargainUI];
            }
            break;
        }
        case TNBargainGoodStatusSuccess:
        case TNBargainGoodStatusFailure: {
            self.countDownView.hidden = YES;
            self.bargainStatusTipsLabel.hidden = NO;
            //显示砍价总金额
            self.bargainChargeLabel.attributedText = self.model.attrMsg;
            [self.oprateBtn setTitle:TNLocalizedString(@"tn_initiate_my_help", @"发起我的助力") forState:UIControlStateNormal];
            self.bargainStatusTipsLabel.text = TNLocalizedString(@"tn_help_over", @"助力已结束");
            //砍价失败的文案展示
            self.messageLabel.text = self.model.helpCopywritingV2;
            break;
        }
        default:
            break;
    }
    //设置富文本后 重新设置居中文本
    self.bargainChargeLabel.textAlignment = NSTextAlignmentCenter;

    if (!HDIsArrayEmpty(model.bargainDetailList)) {
        //有助力人数
        self.avatarsView.hidden = NO;
        [self.avatarsView hd_removeAllSubviews];
        //创建头像
        NSArray *bargainList = @[];
        if (model.bargainDetailList.count <= 10) {
            bargainList = model.bargainDetailList;
        } else {
            bargainList = [model.bargainDetailList subarrayWithRange:NSMakeRange(model.bargainDetailList.count - 10, 10)];
        }
        for (int i = 0; i < bargainList.count; i++) {
            TNBargainPeopleModel *pModel = bargainList[i];
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.layer.masksToBounds = YES;
            imgView.size = CGSizeMake(kRealWidth(30), kRealWidth(30));
            imgView.layer.cornerRadius = imgView.size.width * 0.5f;
            imgView.layer.borderColor = [UIColor whiteColor].CGColor;
            imgView.layer.borderWidth = PixelOne;
            [imgView sd_setImageWithURL:[NSURL URLWithString:pModel.userPortrait] placeholderImage:[UIImage imageNamed:@"tinhnow-default-avatar"]];
            [self.avatarsView addSubview:imgView];
        }
    } else {
        self.avatarsView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
    //开启动画
    if (model.status == TNBargainGoodStatusOngoing && !model.isHelpedBargain) {
        [self endAnimation];
        [self startAnimation];
    } else {
        [self endAnimation];
    }
}
#pragma mark - 倒计时
- (void)countDownNoti {
    if (self.model.status == TNBargainGoodStatusOngoing && !self.model.isHelpedBargain) {
        NSInteger timeout = self.model.expiredTimeOut;
        if (timeout > 0) {
            NSInteger second = timeout % 60;       //秒
            NSInteger minutes = timeout / 60 % 60; //分
            NSInteger hours = timeout / 60 / 60;   //时
            [self.countDownView updateHour:hours minute:minutes second:second];
        } else {
            //倒计时结束
            [self.countDownView updateHour:0 minute:0 second:0];
        }
    }
}
#pragma mark - 设置已砍价的样式显示
- (void)updateHasBargainUI {
    self.countDownView.hidden = YES;
    self.bargainStatusTipsLabel.hidden = NO;
    //已经砍过价了
    //显示砍价总金额
    self.bargainChargeLabel.attributedText = self.model.attrMsg;
    if (!HDIsObjectNil(self.model.operatorHelpedPriceMoney)) {
        //砍价成功了
        [self.oprateBtn setTitle:TNLocalizedString(@"tn_initiate_my_help", @"发起我的助力") forState:UIControlStateNormal];
        self.bargainStatusTipsLabel.text = TNLocalizedString(@"tn_help_friend_success", @"成功帮助好友");
    } else {
        //砍价失败
        [self.oprateBtn setTitle:TNLocalizedString(@"tn_initiate_my_help", @"发起我的助力") forState:UIControlStateNormal];
        self.bargainStatusTipsLabel.text = self.model.helpFailMsg;
    }
    //已砍过价的文案展示
    self.messageLabel.text = self.model.showBargainSuccessMsg;
}
#pragma mark - 设置未砍价UI
- (void)updateNotBargainUI {
    //未砍价
    self.startMyBargainBtn.hidden = NO;
    self.countDownView.hidden = NO;
    self.bargainStatusTipsLabel.hidden = YES;
    //    //显示砍价提示
    self.messageLabel.attributedText = self.model.attrhelpCopywritingV2;
    [self.oprateBtn setTitle:TNLocalizedString(@"tn_help_friend_now", @"马上帮助好友") forState:UIControlStateNormal];
    //显示砍价总金额
    self.bargainChargeLabel.attributedText = self.model.attrMsg;
    [self countDownNoti]; //手动刷新时间
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    if (!self.countDownView.isHidden) {
        [self.countDownView sizeToFit];
        [self.countDownView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView.mas_centerX);
            make.top.equalTo(self.bgView.mas_top).offset(kRealWidth(15));
        }];
    }
    if (!self.bargainStatusTipsLabel.isHidden) {
        [self.bargainStatusTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(10));
            make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(10));
            make.top.equalTo(self.bgView).offset(kRealWidth(10));
        }];
    }
    [self.sponInfoBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.countDownView.isHidden) {
            make.top.equalTo(self.countDownView.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.equalTo(self.bargainStatusTipsLabel.mas_bottom).offset(kRealWidth(10));
        }
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(10));
    }];
    [self.sponHeaderImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sponInfoBgView.mas_left).offset(kRealWidth(10));
        make.centerY.equalTo(self.sponInfoBgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(30), kRealWidth(30)));
        make.top.equalTo(self.sponInfoBgView.mas_top).offset(kRealWidth(10)).priorityMedium();
        make.bottom.equalTo(self.sponInfoBgView.mas_bottom).offset(-kRealWidth(10)).priorityMedium();
    }];
    [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sponHeaderImageView.mas_right).offset(kRealWidth(10));
        make.centerY.equalTo(self.sponInfoBgView.mas_centerY);
        make.right.lessThanOrEqualTo(self.sponInfoBgView.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.sponInfoBgView.mas_top).offset(kRealWidth(10)).priorityHigh();
        make.bottom.equalTo(self.sponInfoBgView.mas_bottom).offset(-kRealWidth(10)).priorityHigh();
    }];

    [self.oprateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.sponInfoBgView.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(kRealWidth(45));
    }];
    if (!self.startMyBargainBtn.hidden) {
        [self.startMyBargainBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(20));
            make.top.equalTo(self.oprateBtn.mas_bottom).offset(kRealWidth(15));
            make.height.mas_equalTo(kRealWidth(45));
        }];
    }
    if (!self.avatarsView.isHidden) {
        UIImageView *lastView = nil;
        for (id view in self.self.avatarsView.subviews) {
            if ([view isKindOfClass:UIImageView.class]) {
                UIImageView *imgView = view;
                [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (lastView) {
                        make.left.mas_equalTo(lastView.mas_left).offset(kRealWidth(15));
                    } else {
                        make.left.mas_equalTo(self.avatarsView.mas_left);
                    }
                    make.top.mas_equalTo(self.avatarsView.mas_top);
                    make.bottom.mas_equalTo(self.avatarsView.mas_bottom);
                    make.width.height.equalTo(@(kRealWidth(30)));
                    if ([self.avatarsView.subviews.lastObject isEqual:imgView]) {
                        make.right.mas_equalTo(self.avatarsView.mas_right);
                    }
                }];
                lastView = imgView;
            }
        }
        [self.avatarsView sizeToFit];
        [self.avatarsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView.mas_centerX);
            if (self.startMyBargainBtn.isHidden) {
                make.top.equalTo(self.oprateBtn.mas_bottom).offset(kRealWidth(20));
            } else {
                make.top.equalTo(self.startMyBargainBtn.mas_bottom).offset(kRealWidth(20));
            }
        }];
    }

    UIView *topView = self.avatarsView.isHidden ? (self.startMyBargainBtn.isHidden ? self.oprateBtn : self.startMyBargainBtn) : self.avatarsView;
    [self.bargainChargeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(topView.mas_bottom).offset(kRealWidth(20));
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-kRealWidth(15));
    }];

    [super updateConstraints];
}
#pragma mark - kaishi按钮缩放动画
- (void)startAnimation {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.oprateBtn.transform = CGAffineTransformMakeScale(1.06, 1.08);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.oprateBtn.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (finished) {
                    HDLog(@"---重新开始缩放动画");
                    [self endAnimation]; //先移除动画
                    [self startAnimation];
                }
            }];
        }
    }];
}
#pragma mark - 结束按钮缩放动画
- (void)endAnimation {
    HDLog(@"---结束缩放动画");
    [self.oprateBtn.layer removeAllAnimations];
}
#pragma mark - 操作按钮点击
- (void)oprateClick {
    if (self.model.status == TNBargainGoodStatusOngoing) {
        if (!self.model.isHelpedBargain) {
            !self.helpBargainClickCallBack ?: self.helpBargainClickCallBack();
        } else {
            !self.startMyBargainClickCallBack ?: self.startMyBargainClickCallBack();
        }
    } else {
        !self.startMyBargainClickCallBack ?: self.startMyBargainClickCallBack();
    }
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.bgView];
    if ([self.oprateBtn.layer.presentationLayer hitTest:touchPoint]) {
        HDLog(@"命中帮助好友按钮点击");
        [self oprateClick];
    }
}
#pragma mark - 发起我的助力
- (void)startMyBargainClick {
    !self.startMyBargainClickCallBack ?: self.startMyBargainClickCallBack();
}
/** @lazy bgView */
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _bgView;
}
/** @lazy bargainStatusTipsLabel */
- (HDLabel *)bargainStatusTipsLabel {
    if (!_bargainStatusTipsLabel) {
        _bargainStatusTipsLabel = [[HDLabel alloc] init];
        _bargainStatusTipsLabel.textColor = [UIColor hd_colorWithHexString:@"#FE2337"];
        _bargainStatusTipsLabel.font = [UIFont boldSystemFontOfSize:14];
        _bargainStatusTipsLabel.numberOfLines = 0;
        _bargainStatusTipsLabel.textAlignment = NSTextAlignmentCenter;
        _bargainStatusTipsLabel.hidden = YES;
    }
    return _bargainStatusTipsLabel;
}

- (UIView *)sponInfoBgView {
    if (!_sponInfoBgView) {
        _sponInfoBgView = [[UIView alloc] init];
        _sponInfoBgView.backgroundColor = [UIColor hd_colorWithHexString:@"#F7F7F7"];
        _sponInfoBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _sponInfoBgView;
}
- (UIImageView *)sponHeaderImageView {
    if (!_sponHeaderImageView) {
        _sponHeaderImageView = [[UIImageView alloc] init];
        _sponHeaderImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.width / 2];
        };
    }
    return _sponHeaderImageView;
}
- (HDLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[HDLabel alloc] init];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.font = HDAppTheme.TinhNowFont.standard15;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}
- (HDLabel *)bargainChargeLabel {
    if (!_bargainChargeLabel) {
        _bargainChargeLabel = [[HDLabel alloc] init];
        _bargainChargeLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _bargainChargeLabel.font = [HDAppTheme.TinhNowFont fontSemibold:14];
        _bargainChargeLabel.textAlignment = NSTextAlignmentCenter;
        _bargainChargeLabel.numberOfLines = 0;
    }
    return _bargainChargeLabel;
}

/** @lazy oprateBtn */
- (HDUIButton *)oprateBtn {
    if (!_oprateBtn) {
        _oprateBtn = [[HDUIButton alloc] init];
        _oprateBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        _oprateBtn.userInteractionEnabled = NO;
        [_oprateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oprateBtn addTarget:self action:@selector(oprateClick) forControlEvents:UIControlEventTouchUpInside];
        _oprateBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:100];
            [view setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FD2C3A"] toColor:[UIColor hd_colorWithHexString:@"#FD8653"]];
        };
    }
    return _oprateBtn;
}
- (HDUIButton *)startMyBargainBtn {
    if (!_startMyBargainBtn) {
        _startMyBargainBtn = [[HDUIButton alloc] init];
        _startMyBargainBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        [_startMyBargainBtn setTitleColor:[UIColor hd_colorWithHexString:@"#FF2323"] forState:UIControlStateNormal];
        [_startMyBargainBtn setTitle:TNLocalizedString(@"tn_initiate_my_help", @"发起我的助力") forState:UIControlStateNormal];
        _startMyBargainBtn.backgroundColor = [UIColor whiteColor];
        [_startMyBargainBtn addTarget:self action:@selector(startMyBargainClick) forControlEvents:UIControlEventTouchUpInside];
        _startMyBargainBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:100 borderWidth:1 borderColor:[UIColor hd_colorWithHexString:@"#ED2C41"]];
        };
    }
    return _startMyBargainBtn;
}
/** @lazy countDownView */
- (TNBargainCountDownView *)countDownView {
    if (!_countDownView) {
        _countDownView = [[TNBargainCountDownView alloc] init];
        _countDownView.suffixText = TNLocalizedString(@"tn_bargain_count_down_end", @"后结束");
        _countDownView.hidden = YES;
    }
    return _countDownView;
}
/** @lazy avatarsView */
- (UIView *)avatarsView {
    if (!_avatarsView) {
        _avatarsView = [[UIView alloc] init];
        _avatarsView.hidden = YES;
    }
    return _avatarsView;
}
@end
