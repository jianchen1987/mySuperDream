//
//  SACMSNewUserMarketingView.m
//  SuperApp
//
//  Created by seeu on 2022/7/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSNewUserMarketingView.h"
#import "LKDataRecord.h"
#import "SACMSNewUserMarketingViewConfig.h"


@interface SACMSNewUserMarketingView ()
///< viewConfig
@property (nonatomic, strong) SACMSNewUserMarketingViewConfig *viewConfig;
///< background
@property (nonatomic, strong) UIView *bgView;
///< icon
@property (nonatomic, strong) SDAnimatedImageView *iconImageView;
///< title
@property (nonatomic, strong) SALabel *titleLabel;
///< button
@property (nonatomic, strong) SAOperationButton *actionButton;
@end


@implementation SACMSNewUserMarketingView

- (void)hd_setupViews {
    [self addSubview:self.bgView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.actionButton];
    self.backgroundColor = UIColor.clearColor;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnIcon:)];
    [self.iconImageView addGestureRecognizer:tap];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    if (!self.iconImageView.isHidden) {
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
            make.left.equalTo(self.mas_left).offset(kRealWidth(12));
            make.centerY.equalTo(self.mas_centerY);
        }];
    }

    if (!self.actionButton.isHidden) {
        [self.actionButton sizeToFit];
        [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.actionButton.frame.size);
            make.right.equalTo(self.mas_right).offset(-kRealWidth(12));
            make.centerY.equalTo(self.mas_centerY);
        }];
    }

    if (!self.titleLabel.isHidden) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            if (!self.iconImageView.isHidden) {
                make.left.equalTo(self.iconImageView.mas_right).offset(kRealWidth(4));
            } else {
                make.left.equalTo(self.mas_left).offset(kRealWidth(12));
            }
            if (!self.actionButton.isHidden) {
                make.right.equalTo(self.actionButton.mas_left).offset(-kRealWidth(12));
            } else {
                make.right.equalTo(self.mas_right).offset(-kRealWidth(12));
            }
        }];
    }

    [super updateConstraints];
}

#pragma mark - Actions
- (void)clickedOnIcon:(UITapGestureRecognizer *)recognizer {
    if (HDIsStringNotEmpty(self.viewConfig.iconJumpLink)) {
        [SAWindowManager openUrl:self.viewConfig.iconJumpLink withParameters:@{
            @"source" : [NSString stringWithFormat:@"%@.%@.icon", self.config.pageConfig.pageName, self.config.pluginName]
        }];
    }

    [LKDataRecord.shared traceClickEvent:@"click_newUserMarketingPlugin_icon" parameters:@{@"route": self.viewConfig.iconJumpLink}
                                     SPM:[LKSPM SPMWithPage:self.config.pageConfig.pageName area:self.config.pluginName node:@"icon"]];
}

- (void)clickedOnActionButton:(SAOperationButton *)button {
    if (HDIsStringNotEmpty(self.viewConfig.buttonJumpLink)) {
        [SAWindowManager openUrl:self.viewConfig.buttonJumpLink withParameters:@{
            @"source" : [NSString stringWithFormat:@"%@.%@.button", self.config.pageConfig.pageName, self.config.pluginName]
        }];
    }

    [LKDataRecord.shared traceClickEvent:@"click_newUserMarketingPlugin_button" parameters:@{@"route": self.viewConfig.buttonJumpLink}
                                     SPM:[LKSPM SPMWithPage:self.config.pageConfig.pageName area:self.config.pluginName node:@"button"]];
}

#pragma mark - setter
- (void)setConfig:(SACMSPluginViewConfig *)config {
    [super setConfig:config];

    self.viewConfig = [SACMSNewUserMarketingViewConfig yy_modelWithDictionary:[config getPluginContent]];
    if (HDIsStringNotEmpty(self.viewConfig.icon)) {
        self.iconImageView.hidden = NO;
        [HDWebImageManager setGIFImageWithURL:self.viewConfig.icon placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(40), kRealWidth(40))] imageView:self.iconImageView];
    } else {
        self.iconImageView.hidden = YES;
    }

    if (HDIsStringNotEmpty(self.viewConfig.title)) {
        self.titleLabel.hidden = NO;
        self.titleLabel.text = self.viewConfig.title;
        self.titleLabel.textColor = [UIColor hd_colorWithHexString:self.viewConfig.titleColor];
        self.titleLabel.font = [UIFont systemFontOfSize:self.viewConfig.titleFont weight:UIFontWeightMedium];
    } else {
        self.titleLabel.hidden = YES;
    }

    if (HDIsStringNotEmpty(self.viewConfig.buttonTitle)) {
        self.actionButton.hidden = NO;
        [self.actionButton applyPropertiesWithBackgroundColor:[UIColor hd_colorWithHexString:self.viewConfig.buttonColor]];
        [self.actionButton setTitle:self.viewConfig.buttonTitle forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[UIColor hd_colorWithHexString:self.viewConfig.buttonTitleColor] forState:UIControlStateNormal];
        self.actionButton.titleLabel.font = [UIFont systemFontOfSize:self.viewConfig.buttonTitleFont weight:UIFontWeightHeavy];
        self.actionButton.cornerRadius = 4.0f;
    } else {
        self.actionButton.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SDAnimatedImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[SDAnimatedImageView alloc] init];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.hd_lineSpace = 5.0f;
    }
    return _titleLabel;
}

- (SAOperationButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_actionButton addTarget:self action:@selector(clickedOnActionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.blackColor;
        _bgView.alpha = 0.7;
    }
    return _bgView;
}
@end
