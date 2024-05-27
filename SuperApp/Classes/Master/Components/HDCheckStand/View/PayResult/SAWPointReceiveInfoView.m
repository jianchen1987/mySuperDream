//
//  SAWPointReceiveInfoView.m
//  SuperApp
//
//  Created by seeu on 2022/5/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAWPointReceiveInfoView.h"
#import "SAAnimateImageView.h"
#import "SAApolloManager.h"
#import "SACacheManager.h"
#import "SAEarnPointBannerRspModel.h"
#import "SAMoneyModel.h"


@interface SAWPointReceiveInfoView ()

///< text
@property (nonatomic, strong) SALabel *titleLabel;
///< subTitle
@property (nonatomic, strong) SALabel *subTitleLabel;
///< to use
@property (nonatomic, strong) SAOperationButton *toUseButton;
///< imageview
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) SAEarnPointBannerModel *bModel;

@end


@implementation SAWPointReceiveInfoView

- (void)hd_setupViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.toUseButton];
}

- (void)updateConstraints {
    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
        make.height.equalTo(self.mas_width).multipliedBy(280 / 730.0);
    }];

    [self.toUseButton sizeToFit];
    [self.toUseButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView.mas_right).offset(-kRealWidth(20));
        make.top.equalTo(self.titleLabel);
        make.size.mas_equalTo(self.toUseButton.frame.size);
    }];

    [self.titleLabel sizeToFit];
    [self.subTitleLabel sizeToFit];

    BOOL result1
        = self.titleLabel.width > (kScreenWidth - (HDAppTheme.value.padding.left + HDAppTheme.value.padding.right)) - kRealWidth(20) - kRealWidth(18) - self.toUseButton.width - kRealWidth(20);
    BOOL result2 = self.subTitleLabel.width > (kScreenWidth - (HDAppTheme.value.padding.left + HDAppTheme.value.padding.right)) - kRealWidth(20) - kRealWidth(20);
    //    HDLog(@"%f---%f",self.titleLabel.width,((kScreenWidth - (HDAppTheme.value.padding.left + HDAppTheme.value.padding.right)) - kRealWidth(20) - kRealWidth(18) - self.toUseButton.width -
    //    kRealWidth(20)));
    if (result1 || result2) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.toUseButton.mas_left).offset(-kRealWidth(18));
            make.top.equalTo(self.bgImageView.mas_top).offset(kRealWidth(25));
        }];

        [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.bgImageView.mas_right).offset(-kRealWidth(20));
            make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-kRealHeight(35));
        }];
    } else { //主标题和子标题均为一行时
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.toUseButton.mas_left).offset(-kRealWidth(18));
            make.top.equalTo(self.bgImageView.mas_top).offset(kRealWidth(38));
        }];

        [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImageView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.bgImageView.mas_right).offset(-kRealWidth(20));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealHeight(20));
        }];

        [self.toUseButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgImageView.mas_right).offset(-kRealWidth(20));
            make.centerY.equalTo(self.titleLabel);
            make.size.mas_equalTo(self.toUseButton.frame.size);
        }];
    }

    [super updateConstraints];
}

- (void)setModel:(SAWPontWillGetRspModel *)model {
    _model = model;

    NSString *highlight = nil;
    NSString *text = nil;
    NSString *subTitleText = nil;
    //获取缓存
    SAEarnPointBannerRspModel *bannerRspModel = [SACacheManager.shared objectForKey:kCacheKeyEarnPointBannerCache type:SACacheTypeCachePublic];
    SAEarnPointBannerModel *bModel = nil;
    if (model.bePermitted) {
        // 有积分
        highlight = [NSString stringWithFormat:@"%.1f", model.point.floatValue];
        text = [NSString stringWithFormat:SALocalizedString(@"paid_result_wpoint_get_tips1", @"恭喜您本单预计获得%.1f积分"), model.point.floatValue];

        bModel = bannerRspModel.reachThreshold;
    } else {
        // 无积分
        highlight = model.thresholdAmount.thousandSeparatorAmount;
        if (SAMultiLanguageManager.isCurrentLanguageKH) {
            highlight = model.thresholdAmount.thousandSeparatorAmountNoCurrencySymbol;
        }
        text = [NSString stringWithFormat:SALocalizedString(@"paid_result_wpoint_get_tips2", @"消费满%@，可以获得积分哦!"), highlight];
        bModel = bannerRspModel.thresholdNotMet;
    }

    self.bModel = nil;
    if (bModel) {
        NSString *format = nil;
        NSString *urlString = nil;
        if (SAMultiLanguageManager.isCurrentLanguageKH) {
            [self.toUseButton setTitle:bModel.buttonTextKh forState:UIControlStateNormal];
            subTitleText = bModel.remarkKh;
            format = bModel.hintsKh;
            urlString = bModel.imageUrlKh;
        } else if (SAMultiLanguageManager.isCurrentLanguageEN) {
            [self.toUseButton setTitle:bModel.buttonTextEn forState:UIControlStateNormal];
            subTitleText = bModel.remarkEn;
            format = bModel.hintsEn;
            urlString = bModel.imageUrlEn;
        } else {
            [self.toUseButton setTitle:bModel.buttonTextCn forState:UIControlStateNormal];
            subTitleText = bModel.remarkCn;
            format = bModel.hintsCn;
            urlString = bModel.imageUrlCn;
        }

        if ([format containsString:@"{number}"]) {
            format = [format stringByReplacingOccurrencesOfString:@"{number}" withString:@"%@"];
            text = [NSString stringWithFormat:format, highlight];
        }

        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"payment_result_point_bg"]];
        self.bModel = bModel;
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.maximumLineHeight = kRealWidth(20);
    paragraphStyle.minimumLineHeight = kRealWidth(20);

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]
        initWithString:text
            attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard14H, NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: paragraphStyle}];
    [attStr addAttributes:@{NSForegroundColorAttributeName: [UIColor hd_colorWithHexString:@"#FFC248"]} range:[text rangeOfString:highlight]];

    self.titleLabel.attributedText = attStr;

    if (subTitleText) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.maximumLineHeight = kRealWidth(17);
        paragraphStyle.minimumLineHeight = kRealWidth(17);
        attStr = [[NSMutableAttributedString alloc]
            initWithString:subTitleText
                attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard12M, NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: paragraphStyle}];
        self.subTitleLabel.attributedText = attStr;
    }

    [self setNeedsUpdateConstraints];
}

- (CGFloat)fitHeightWithWidth:(CGFloat)width {
    return width * 280 / 730.0;
}

- (void)clickedOnToUseButton:(SAOperationButton *)button {
    if (self.bModel && HDIsStringNotEmpty(self.bModel.forwardLink)) {
        [SAWindowManager openUrl:self.bModel.forwardLink withParameters:nil];
    } else {
        NSString *url = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeyWPointReceiveJumpLink];
        if (HDIsStringNotEmpty(url)) {
            [SAWindowManager openUrl:url withParameters:nil];
        }
    }
}

#pragma mark - lazy load
/** @lazy textlabel */
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (SALabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[SALabel alloc] init];
        _subTitleLabel.font = HDAppTheme.font.sa_standard12M;
        _subTitleLabel.textColor = UIColor.whiteColor;
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.text = SALocalizedString(@"payment_result_wpoint_tips", @"积分可抽奖，兑换优惠券哦！~");
    }
    return _subTitleLabel;
}

/** @lazy imageView */
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"payment_result_point_bg"];
    }
    return _bgImageView;
}

- (SAOperationButton *)toUseButton {
    if (!_toUseButton) {
        _toUseButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_toUseButton applyPropertiesWithBackgroundColor:UIColor.whiteColor];
        [_toUseButton setTitle:SALocalizedString(@"payment_result_wpoint_toUse", @"去使用") forState:UIControlStateNormal];
        [_toUseButton setTitleColor:[UIColor hd_colorWithHexString:@"#FC2040"] forState:UIControlStateNormal];
        _toUseButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
        _toUseButton.titleEdgeInsets = UIEdgeInsetsMake(6, 17, 6, 17);
        [_toUseButton addTarget:self action:@selector(clickedOnToUseButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _toUseButton;
}

@end
