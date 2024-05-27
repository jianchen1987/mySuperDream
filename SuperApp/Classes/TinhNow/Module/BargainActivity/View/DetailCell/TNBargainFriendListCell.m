//
//  TNBargainFriendListCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainFriendListCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAInternationalizationModel.h"
#import "SAOperationButton.h"
#import "TNBargainCountDownView.h"
#import "TNNotificationConst.h"


@interface TNBargainFriendListCell ()
/// 圆角背景
@property (strong, nonatomic) UIView *bgView;
///提示好友需要在WOWNOWapp打开的提示
@property (strong, nonatomic) HDLabel *openAPPTipsLabel;
/// 倒计时视图
@property (strong, nonatomic) TNBargainCountDownView *countDownView;
/// 助力状态提示文本
@property (strong, nonatomic) HDLabel *bargainStatusTipsLabel;
/// 文案
@property (strong, nonatomic) UILabel *detailLabel;
/// 头像视图
@property (strong, nonatomic) UIView *avatarsView;
///进度条背景
@property (strong, nonatomic) UIView *progressBgView;
/// 进度条
@property (strong, nonatomic) UIView *progressView;
/// 操作按钮
@property (strong, nonatomic) HDUIButton *oprateBtn;

@end


@implementation TNBargainFriendListCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.countDownView];
    [self.bgView addSubview:self.detailLabel];
    [self.bgView addSubview:self.oprateBtn];
    [self.bgView addSubview:self.openAPPTipsLabel];
    [self.bgView addSubview:self.bargainStatusTipsLabel];
    [self.bgView addSubview:self.avatarsView];
    [self.bgView addSubview:self.progressBgView];
    [self.progressBgView addSubview:self.progressView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNoti) name:kNotificationNameBargainCountTime object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]; //按钮在动画期间  不接受点击事件  将点击事件交给父视图
    [self.bgView addGestureRecognizer:tap];
}
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    if (!self.openAPPTipsLabel.isHidden) {
        [self.openAPPTipsLabel sizeToFit];
        [self.openAPPTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.bgView);
        }];
    }
    if (!self.countDownView.isHidden) {
        [self.countDownView sizeToFit];
        [self.countDownView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView.mas_centerX);
            if (self.openAPPTipsLabel.isHidden) {
                make.top.equalTo(self.bgView.mas_top).offset(kRealWidth(15));
            } else {
                make.top.equalTo(self.openAPPTipsLabel.mas_bottom).offset(kRealWidth(15));
            }
        }];
    }
    if (!self.bargainStatusTipsLabel.isHidden) {
        [self.bargainStatusTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
            if (self.openAPPTipsLabel.isHidden) {
                make.top.equalTo(self.bgView.mas_top).offset(kRealWidth(10));
            } else {
                make.top.equalTo(self.openAPPTipsLabel.mas_bottom).offset(kRealWidth(10));
            }
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
            if (self.countDownView.isHidden) {
                make.top.equalTo(self.bargainStatusTipsLabel.mas_bottom).offset(kRealWidth(20));
            } else {
                make.top.equalTo(self.countDownView.mas_bottom).offset(kRealWidth(20));
            }
        }];
    }
    if (!self.progressBgView.isHidden) {
        [self.progressBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(20));
            make.height.mas_equalTo(kRealWidth(6));
            make.top.equalTo(self.avatarsView.mas_bottom).offset(kRealWidth(15));
        }];

        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.progressBgView);
            make.width.mas_equalTo(self.progressBgView.mas_width).multipliedBy(self.model.taskPrecent);
        }];
    }
    if (!self.detailLabel.isHidden) {
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(15));
            if (!self.progressBgView.isHidden) {
                make.top.equalTo(self.progressBgView.mas_bottom).offset(kRealWidth(10));
            } else if (!self.avatarsView.isHidden) {
                make.top.equalTo(self.avatarsView.mas_bottom).offset(kRealWidth(10));
            } else {
                make.top.equalTo(self.countDownView.mas_bottom).offset(kRealWidth(20));
            }
        }];
    }
    [self.oprateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(kRealWidth(20));
        make.right.equalTo(self.bgView.mas_right).offset(-kRealWidth(20));
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(45));
        if (!self.detailLabel.isHidden) {
            make.top.equalTo(self.detailLabel.mas_bottom).offset(kRealWidth(20));
        } else if (!self.avatarsView.isHidden) {
            make.top.equalTo(self.avatarsView.mas_bottom).offset(kRealWidth(20));
        } else if (!self.bargainStatusTipsLabel.isHidden) {
            make.top.equalTo(self.bargainStatusTipsLabel.mas_bottom).offset(kRealWidth(20));
        }
    }];
    [super updateConstraints];
}
#pragma mark - 倒计时
- (void)countDownNoti {
    if (self.model.status == TNBargainGoodStatusOngoing) {
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
#pragma mark - 赋值
- (void)setModel:(TNBargainDetailModel *)model {
    _model = model;
    switch (model.status) {
        case TNBargainGoodStatusOngoing: {
            self.countDownView.hidden = NO;
            self.detailLabel.hidden = NO;
            self.bargainStatusTipsLabel.hidden = YES;
            self.detailLabel.attributedText = model.attrMsg;
            self.detailLabel.textAlignment = NSTextAlignmentCenter;
            [self.oprateBtn setTitle:model.buttonMsg forState:UIControlStateNormal];
            [self countDownNoti]; //手动刷新时间
            break;
        }
        case TNBargainGoodStatusSuccess: {
            self.detailLabel.hidden = YES;
            self.bargainStatusTipsLabel.hidden = NO;
            self.bargainStatusTipsLabel.text = TNLocalizedString(@"tn_bargain_success", @"助力成功");
            self.progressBgView.hidden = YES;
            self.countDownView.hidden = YES;
            [self.oprateBtn setTitle:TNLocalizedString(@"tn_bargain_check_order", @"查看订单") forState:UIControlStateNormal];
            break;
        }
        case TNBargainGoodStatusFailure: {
            self.detailLabel.hidden = YES;
            self.bargainStatusTipsLabel.hidden = NO;
            self.bargainStatusTipsLabel.textColor = [UIColor hd_colorWithHexString:@"#ADB6C8"];
            self.bargainStatusTipsLabel.text = TNLocalizedString(@"tn_bargain_unsuccess_try_k", @"助力未成功，要再接再厉哦");
            self.oprateBtn.enabled = false;
            self.progressBgView.hidden = YES;
            self.countDownView.hidden = YES;
            [self.oprateBtn setTitle:TNLocalizedString(@"tn_bargain_end", @"助力结束") forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    //显示打开app提示
    if (model.isOpenBargainExponent) {
        self.openAPPTipsLabel.text = model.downLoadAppTips;
        self.openAPPTipsLabel.hidden = NO;
    } else {
        if (model.isEvokeApp) {
            self.openAPPTipsLabel.text = model.downLoadAppTips;
            self.openAPPTipsLabel.hidden = NO;
        } else {
            self.openAPPTipsLabel.hidden = YES;
        }
    }

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
        //助力进度
        if (model.status == TNBargainGoodStatusOngoing && model.bargainType != TNBargainTaskTypeBigChallenge) {
            self.progressBgView.hidden = NO;
        } else {
            self.progressBgView.hidden = YES;
        }
    } else {
        self.avatarsView.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
    if (model.status == TNBargainGoodStatusOngoing) {
        [self endAnimation];
        [self startAnimation];
    } else {
        [self endAnimation];
    }
}
#pragma mark - 操作按钮点击
- (void)oprateClick {
    if (self.model.status == TNBargainGoodStatusOngoing) {
        if (self.shareClickCallBack) {
            self.shareClickCallBack();
        }
    } else if (self.model.status == TNBargainGoodStatusSuccess) {
        if (self.orderDetailClickCallBack) {
            self.orderDetailClickCallBack();
        }
    }
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.bgView];
    if ([self.oprateBtn.layer.presentationLayer hitTest:touchPoint]) {
        HDLog(@"命中帮助好友按钮点击");
        [self oprateClick];
    }
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
                    [self endAnimation]; //先移除动画
                    HDLog(@"---重新开始缩放动画");
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
/** @lazy countDownView */
- (TNBargainCountDownView *)countDownView {
    if (!_countDownView) {
        _countDownView = [[TNBargainCountDownView alloc] init];
        _countDownView.suffixText = TNLocalizedString(@"tn_bargain_count_down_end", @"后结束");
        _countDownView.hidden = YES;
    }
    return _countDownView;
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
/** @lazy detailLabel */
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = HDAppTheme.TinhNowFont.standard14;
        _detailLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.numberOfLines = 0;
        _detailLabel.hidden = YES;
    }
    return _detailLabel;
}

/** @lazy oprateBtn */
- (HDUIButton *)oprateBtn {
    if (!_oprateBtn) {
        _oprateBtn = [[HDUIButton alloc] init];
        _oprateBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        [_oprateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [_oprateBtn addTarget:self action:@selector(oprateClick) forControlEvents:UIControlEventTouchUpInside];
        _oprateBtn.userInteractionEnabled = NO;
        @HDWeakify(self);
        _oprateBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            [view setRoundedCorners:UIRectCornerAllCorners radius:100];
            if (self.model.status == TNBargainGoodStatusFailure) {
                [view setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#BEBEBE"] toColor:[UIColor hd_colorWithHexString:@"#BEBEBE"]];
            } else {
                [view setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FD2C3A"] toColor:[UIColor hd_colorWithHexString:@"#FD8653"]];
            }
        };
    }
    return _oprateBtn;
}
- (HDLabel *)openAPPTipsLabel {
    if (!_openAPPTipsLabel) {
        _openAPPTipsLabel = [[HDLabel alloc] init];
        _openAPPTipsLabel.textColor = [UIColor whiteColor];
        _openAPPTipsLabel.font = HDAppTheme.TinhNowFont.standard11;
        _openAPPTipsLabel.numberOfLines = 0;
        _openAPPTipsLabel.backgroundColor = [UIColor hd_colorWithHexString:@"#FD2F3B"];
        _openAPPTipsLabel.text = TNLocalizedString(@"tn_bargain_detail_tips", @"好友点击邀请链接后，需要在WOWNOW APP打开才能助力哦");
        _openAPPTipsLabel.hd_edgeInsets = UIEdgeInsetsMake(9, 15, 9, 15);
        _openAPPTipsLabel.hidden = YES;
    }
    return _openAPPTipsLabel;
}
/** @lazy avatarsView */
- (UIView *)avatarsView {
    if (!_avatarsView) {
        _avatarsView = [[UIView alloc] init];
        _avatarsView.hidden = YES;
    }
    return _avatarsView;
}
/** @lazy progressBgView */
- (UIView *)progressBgView {
    if (!_progressBgView) {
        _progressBgView = [[UIView alloc] init];
        _progressBgView.backgroundColor = [UIColor hd_colorWithHexString:@"#FFEED9"];
        _progressBgView.hidden = YES;
        _progressBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _progressBgView;
}
/** @lazy progressView */
- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor hd_colorWithHexString:@"#FD8152"];
        _progressView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        };
    }
    return _progressView;
}
@end
