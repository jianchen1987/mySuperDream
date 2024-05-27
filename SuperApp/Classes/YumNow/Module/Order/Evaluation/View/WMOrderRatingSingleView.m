//
//  WMOrderRatingSingleView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/26.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderRatingSingleView.h"
#import <HDUIKit/HDUIKit.h>


@interface WMOrderRatingSingleView () <UITextViewDelegate>
///标题名称
@property (nonatomic, strong) SALabel *titleLabel;
///评分描述
@property (nonatomic, strong) SALabel *descLabel;
///评分视图
@property (nonatomic, strong) HDRatingStarView *startView;
/// lineView
@property (nonatomic, strong) UIView *lineView;
///标题名称
@property (nonatomic, strong) SALabel *nameLB;
/// timeLB
@property (nonatomic, strong) SALabel *timeLB;
/// distanceLB
@property (nonatomic, strong) SALabel *distanceLB;
/// iconIV
@property (nonatomic, strong) UIImageView *iconIV;
/// contentView
@property (nonatomic, strong) UIView *contentView;
/// placelB
@property (nonatomic, strong) SALabel *placelB;
/// numLB
@property (nonatomic, strong) SALabel *numLB;
/// floatView
@property (nonatomic, strong) HDFloatLayoutView *floatView;
///是否匿名
@property (nonatomic, strong) HDUIButton *anonymousButton;
///是否匿名
@property (nonatomic, strong) HDUIButton *anonymousIconButton;
/// topView
@property (nonatomic, strong) UIView *topView;
/// 评分
@property (nonatomic, assign) CGFloat start;
/// 展示新评价
@property (nonatomic, assign) BOOL isShowGood;

@end


@implementation WMOrderRatingSingleView

- (void)hd_setupViews {
    self.floatBtnArr = NSMutableArray.new;
    [self addSubview:self.topView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.anonymousButton];
    [self addSubview:self.anonymousIconButton];
    [self addSubview:self.lineView];
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLB];
    [self addSubview:self.timeLB];
    [self addSubview:self.distanceLB];
    [self addSubview:self.descLabel];
    [self addSubview:self.startView];
    [self addSubview:self.floatView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.placelB];
    [self.contentView addSubview:self.numLB];
    //    [self addQuickContent];
    self.showDetail = NO;
}

- (void)addQuickContent {
    if (self.start >= 4 && self.isShowGood && self.floatBtnArr.count)
        return;

    if (self.start < 4 && !self.isShowGood && self.floatBtnArr.count)
        return;

    self.isShowGood = self.start >= 4;

    NSArray *dataSource = nil;
    if (self.isShowGood) {
        dataSource = @[
            WMLocalizedString(@"wm_evaluation_tag_11", @"仪表整洁"),
            WMLocalizedString(@"wm_evaluation_tag_12", @"热情礼貌"),
            WMLocalizedString(@"wm_evaluation_tag_13", @"穿戴工服"),
            WMLocalizedString(@"wm_evaluation_tag_14", @"快速送达"),
            WMLocalizedString(@"wm_evaluation_tag_15", @"货品完好"),
            WMLocalizedString(@"wm_evaluation_tag_16", @"风雨无阻"),
        ];
    } else {
        dataSource = @[
            WMLocalizedString(@"wm_evaluation_tag_1", @"超时送达"),
            WMLocalizedString(@"wm_evaluation_tag_2", @"漏送/错送"),
            WMLocalizedString(@"wm_evaluation_tag_3", @"提前点送达"),
            WMLocalizedString(@"wm_evaluation_tag_4", @"洒餐"),
            WMLocalizedString(@"wm_evaluation_tag_5", @"态度不好"),
            WMLocalizedString(@"wm_evaluation_tag_6", @"送达不通知"),
            WMLocalizedString(@"wm_evaluation_tag_7", @"其他")
        ];
    }

    [self.floatView hd_removeAllSubviews];
    [self.floatBtnArr removeAllObjects];

    [dataSource enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(8), kRealWidth(3), kRealWidth(8));
        [btn setTitleColor:HDAppTheme.WMColor.B9 forState:UIControlStateNormal];
        [btn setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateSelected];
        btn.adjustsButtonWhenHighlighted = NO;
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        btn.layer.cornerRadius = kRealWidth(4);
        btn.layer.backgroundColor = HDAppTheme.WMColor.lineColorE9.CGColor;
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            btn.selected = !btn.isSelected;
            btn.layer.backgroundColor = btn.isSelected ? [HDAppTheme.WMColor.mainRed colorWithAlphaComponent:0.1].CGColor : HDAppTheme.WMColor.lineColorE9.CGColor;
        }];
        [btn sizeToFit];
        [self.floatView addSubview:btn];
        [self.floatBtnArr addObject:btn];
    }];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kRealWidth(8));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(kRealWidth(12));
        make.left.equalTo(self).offset(kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(12));
    }];

    if (self.storeName) {
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRealWidth(12));
            make.size.mas_equalTo(CGSizeMake(kRealWidth(32), kRealWidth(32)));
            make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(15));
        }];

        [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
            make.centerY.equalTo(self.iconIV);
            make.right.mas_equalTo(-kRealWidth(12));
        }];
        self.timeLB.hidden = YES;
    } else {
        self.timeLB.hidden = NO;
        [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRealWidth(12));
            make.size.mas_equalTo(self.iconIV.image.size);
            make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(19));
        }];

        [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
            make.top.equalTo(self.iconIV.mas_top);
        }];

        [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLB);
            make.bottom.equalTo(self.iconIV.mas_bottom);
        }];
    }

    [self.distanceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(5));
        make.centerY.equalTo(self.startView);
        make.left.mas_equalTo(kRealWidth(12));
    }];

    [self.startView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self.startView sizeThatFits:CGSizeMake(MAXFLOAT, 24)]);
        make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(14));
        make.left.equalTo(self.distanceLB.mas_right).offset(kRealWidth(20));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startView.mas_right).offset(kRealWidth(16));
        make.centerY.equalTo(self.startView);
    }];

    [self.floatView sizeToFit];
    [self.floatView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatView.isHidden) {
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            make.top.equalTo(self.startView.mas_bottom).offset(kRealWidth(14));
            CGFloat width = kScreenWidth - kRealWidth(24);
            CGSize size = [self.floatView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
        }
    }];

    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.contentView.isHidden) {
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
            make.left.mas_equalTo(kRealWidth(12));
            make.right.mas_equalTo(-kRealWidth(12));
            if (self.floatView.isHidden) {
                make.top.equalTo(self.startView.mas_bottom).offset(kRealWidth(14));
            } else {
                make.top.equalTo(self.floatView.mas_bottom).offset(kRealWidth(14));
            }
        }
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(kRealWidth(130));
        make.left.mas_equalTo(kRealWidth(6));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(4));
        make.bottom.equalTo(self.numLB.mas_top).offset(-kRealWidth(8));
    }];

    [self.placelB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(12));
    }];

    [self.numLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.anonymousButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(14));
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];

    [self.anonymousIconButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.anonymousIconButton.isHidden) {
            make.right.equalTo(self.anonymousButton.mas_left);
            make.centerY.equalTo(self.anonymousButton.mas_centerY);
        }
    }];
}

#pragma mark - getters and setters
- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLB.text = [NSString stringWithFormat:WMLocalizedString(@"wm_evaluation_delivered", @""), time ?: @""];
}

- (void)setShowDetail:(BOOL)showDetail {
    _showDetail = showDetail;
    self.floatView.hidden = self.contentView.hidden = !showDetail;
    if (self.storeName) {
        self.floatView.hidden = YES;
    }
    if (!self.floatView.hidden) {
        [self addQuickContent];
    }

    [self setNeedsUpdateConstraints];
}

- (void)setRatingTitle:(NSString *)ratingTitle {
    _ratingTitle = ratingTitle;
    self.distanceLB.text = ratingTitle;
    [self setNeedsUpdateConstraints];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


- (void)setStoreName:(NSString *)storeName {
    _storeName = storeName;
    self.nameLB.text = storeName;
    self.placelB.text = WMLocalizedString(@"wm_evaluation_about_food", @"说说菜品味道怎么样～");
    self.floatView.hidden = YES;
    [self.anonymousButton setTitle:WMLocalizedString(@"rating_anonymous", @"匿名") forState:UIControlStateNormal];
    self.anonymousButton.userInteractionEnabled = YES;
    [self setNeedsUpdateConstraints];
}

- (void)setLogoURL:(NSString *)logoURL {
    _logoURL = logoURL;
    self.iconIV.clipsToBounds = YES;
    self.iconIV.contentMode = UIViewContentModeScaleAspectFill;
    self.iconIV.layer.cornerRadius = kRealWidth(4);
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:logoURL] placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(4) size:CGSizeMake(kRealWidth(32), kRealWidth(32))]];
}

#pragma mark - public methods
- (double)score {
    return self.startView.score;
}

- (void)setIsShowAnonymous:(BOOL)isShowAnonymous {
    _isShowAnonymous = isShowAnonymous;
    self.anonymousIconButton.hidden = !self.isShowAnonymous;
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)anonymousButtonClick:(HDUIButton *)btn {
    self.anonymousIconButton.selected = !self.anonymousIconButton.isSelected;
    !self.clickedIsAnonymousButtonBlock ?: self.clickedIsAnonymousButtonBlock(self.anonymousIconButton.isSelected ? WMReviewAnonymousStateTrue : WMReviewAnonymousStateFalse);
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placelB.hidden = textView.text.length;
    NSInteger max = 250;
    if (textView.text.length >= max) {
        textView.text = [textView.text substringToIndex:max];
    }
    self.numLB.text = [NSString stringWithFormat:@"%zd/%zd", textView.text.length, max];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - lazy load
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        _titleLabel.textColor = HDAppTheme.WMColor.B3;
    }
    return _titleLabel;
}

- (SALabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[SALabel alloc] init];
        _descLabel.font = [HDAppTheme.WMFont wm_ForSize:14];
        _descLabel.textColor = HDAppTheme.WMColor.B3;
    }
    return _descLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _lineView;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.image = [UIImage imageNamed:@"yn_evaluation_rider"];
    }
    return _iconIV;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = [[SALabel alloc] init];
        label.font = [HDAppTheme.WMFont wm_ForSize:14];
        ;
        label.textColor = HDAppTheme.WMColor.B3;
        label.text = WMLocalizedString(@"wm_evaluation_platform_delivery", @"平台配送");
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)timeLB {
    if (!_timeLB) {
        SALabel *label = [[SALabel alloc] init];
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        ;
        label.textColor = HDAppTheme.WMColor.B9;
        _timeLB = label;
    }
    return _timeLB;
}

- (SALabel *)distanceLB {
    if (!_distanceLB) {
        SALabel *label = [[SALabel alloc] init];
        label.font = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        ;
        label.textColor = HDAppTheme.WMColor.B3;
        label.text = WMLocalizedString(@"delivery_service", @"配送服务");
        _distanceLB = label;
    }
    return _distanceLB;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.new;
        _contentView.layer.backgroundColor = HDAppTheme.WMColor.bgGray.CGColor;
        _contentView.layer.cornerRadius = kRealWidth(4);
    }
    return _contentView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = UITextView.new;
        _textView.font = [HDAppTheme.WMFont wm_ForSize:14];
        _textView.textColor = HDAppTheme.WMColor.B3;
        _textView.scrollEnabled = NO;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.spellCheckingType = UITextSpellCheckingTypeNo;
        _textView.backgroundColor = UIColor.clearColor;
        _textView.tintColor = HDAppTheme.WMColor.mainRed;
    }
    return _textView;
}

- (SALabel *)placelB {
    if (!_placelB) {
        SALabel *label = [[SALabel alloc] init];
        label.font = [HDAppTheme.WMFont wm_ForSize:14];
        ;
        label.textColor = HDAppTheme.WMColor.B9;
        label.text = WMLocalizedString(@"wm_evaluation_help_us_better", @"您的反馈将帮助我们变得更好～");
        _placelB = label;
    }
    return _placelB;
}

- (SALabel *)numLB {
    if (!_numLB) {
        SALabel *label = [[SALabel alloc] init];
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        ;
        label.textColor = HDAppTheme.WMColor.B9;
        label.text = @"0/250";
        _numLB = label;
    }
    return _numLB;
}

- (HDFloatLayoutView *)floatView {
    if (!_floatView) {
        _floatView = HDFloatLayoutView.new;
        _floatView.maximumItemSize = CGSizeMake(kScreenWidth - kRealWidth(24), kRealWidth(28));
        _floatView.itemMargins = UIEdgeInsetsMake(0, 0, kRealWidth(12), kRealWidth(8));
    }
    return _floatView;
}

- (HDRatingStarView *)startView {
    if (!_startView) {
        _startView = [[HDRatingStarView alloc] init];
        _startView.starImage = [UIImage imageNamed:@"starUnselected"];
        _startView.starWidth = 20;
        _startView.itemMargin = 6;
        _startView.renderColors = @[HDAppTheme.WMColor.mainRed];
        _startView.countForOneStar = 1;
        @HDWeakify(self);
        _startView.selectScoreHandler = ^(CGFloat score) {
            NSString *descTitle;
            if (score <= 0) {
                descTitle = WMLocalizedString(@"star_rating_tip", @"点击或滑动评分");
            } else if (score <= 1) {
                descTitle = WMLocalizedString(@"rating_level_very_bad", @"非常差");
            } else if (score <= 2) {
                descTitle = WMLocalizedString(@"rating_level_bad", @"差");
            } else if (score <= 3) {
                descTitle = WMLocalizedString(@"rating_level_good", @"一般");
            } else if (score <= 4) {
                descTitle = WMLocalizedString(@"rating_level_great", @"满意");
            } else {
                descTitle = WMLocalizedString(@"rating_level_very_good", @"非常好");
            }
            @HDStrongify(self);
            self.start = score;
            self.descLabel.text = descTitle;
            self.showDetail = YES;
            if (self.scoreChangedBlock) {
                self.scoreChangedBlock();
            }
        };
    }
    return _startView;
}

- (HDUIButton *)anonymousIconButton {
    if (!_anonymousIconButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G3 forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_evaluation_check"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_evaluation_check_sel"] forState:UIControlStateSelected];
        button.adjustsButtonWhenHighlighted = false;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(4), 0, kRealWidth(4));
        [button addTarget:self action:@selector(anonymousButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _anonymousIconButton = button;
        _anonymousIconButton.hidden = YES;
    }
    return _anonymousIconButton;
}

- (HDUIButton *)anonymousButton {
    if (!_anonymousButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.WMColor.B9 forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"wm_evaluation_anonymized", @"已匿名") forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.userInteractionEnabled = NO;
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        [button addTarget:self action:@selector(anonymousButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _anonymousButton = button;
    }
    return _anonymousButton;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = UIView.new;
        _topView.backgroundColor = HDAppTheme.WMColor.bgGray;
    }
    return _topView;
}

@end
