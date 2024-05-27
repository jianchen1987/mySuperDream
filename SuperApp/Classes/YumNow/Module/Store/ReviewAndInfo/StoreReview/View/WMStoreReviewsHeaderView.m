//
//  WMStoreReviewsHeaderView.m
//  SuperApp
//
//  Created by Chaos on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreReviewsHeaderView.h"
#import "WMReviewFilterView.h"


@interface WMStoreReviewsHeaderView ()

/// 评分
@property (nonatomic, strong) SALabel *scoreLabel;
/// 评分标题
@property (nonatomic, strong) SALabel *scoreTitleLabel;
/// 评分视图
@property (nonatomic, strong) HDRatingStarView *startView;
/// 中间线
@property (nonatomic, strong) UIView *lineView;
/// positiverate 内容
@property (nonatomic, strong) SALabel *positiverateLabel;
/// positiverate标题
@property (nonatomic, strong) SALabel *positiverateTitleLabel;
/// 底部线
@property (nonatomic, strong) UIView *bottomLineView;
/// 筛选 View
@property (nonatomic, strong) WMReviewFilterView *filterView;

@end


@implementation WMStoreReviewsHeaderView

- (void)hd_setupViews {
    [self addSubview:self.scoreLabel];
    [self addSubview:self.scoreTitleLabel];
    [self addSubview:self.startView];
    [self addSubview:self.lineView];
    [self addSubview:self.positiverateLabel];
    [self addSubview:self.positiverateTitleLabel];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.filterView];
}

- (void)updateConstraints {
    [self.scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(20));
        make.top.equalTo(self.mas_top).offset(kRealHeight(30));
        make.height.mas_equalTo(40);
    }];

    [self.scoreTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreLabel);
        make.left.equalTo(self.scoreLabel.mas_right).offset(kRealWidth(5));
        make.right.lessThanOrEqualTo(self.lineView.mas_left).offset(-kRealWidth(20));
    }];

    [self.startView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self.startView sizeThatFits:CGSizeMake(50, 30)]);
        make.left.equalTo(self.scoreTitleLabel);
        make.top.equalTo(self.scoreTitleLabel.mas_bottom).offset(kRealWidth(10));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealHeight(35));
        make.width.mas_equalTo(kRealWidth(1));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.scoreLabel.mas_centerY);
    }];

    [self.positiverateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.lineView.mas_right).offset(kRealWidth(20)).priorityLow();
        make.centerY.equalTo(self.scoreLabel.mas_centerY);
    }];

    [self.positiverateTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.positiverateLabel);
        make.right.equalTo(self.mas_right).offset(-kRealWidth(20));
        make.left.equalTo(self.positiverateLabel.mas_right).offset(kRealWidth(5));
    }];

    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(kRealHeight(28));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kRealHeight(6));
        if (self.filterView.isHidden) {
            make.bottom.equalTo(self.mas_bottom);
        }
    }];

    [self.filterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.filterView.isHidden) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.bottomLineView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom);
        }
    }];

    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(0, 0, kScreenWidth, size.height);

    [super updateConstraints];
}

- (void)setViewModel:(WMStoreReviewsViewModel *)viewModel {
    _viewModel = viewModel;

    self.scoreLabel.text = [NSString stringWithFormat:@"%.1f", self.viewModel.score];
    self.startView.score = self.viewModel.score;
    self.positiverateLabel.text = [NSString stringWithFormat:@"%.0f%%", self.viewModel.rate];

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SALabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[SALabel alloc] init];
        _scoreLabel.textColor = HDAppTheme.color.G1;
        _scoreLabel.font = HDAppTheme.font.amountOnly;
        _scoreLabel.text = @"5.0";
        [_scoreLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _scoreLabel;
}

- (SALabel *)scoreTitleLabel {
    if (!_scoreTitleLabel) {
        _scoreTitleLabel = [[SALabel alloc] init];
        _scoreTitleLabel.textColor = HDAppTheme.color.G3;
        _scoreTitleLabel.font = HDAppTheme.font.standard4;
        _scoreTitleLabel.text = WMLocalizedString(@"merchant_score", @"商店评分");
        _scoreTitleLabel.numberOfLines = 0;
        [_scoreTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _scoreTitleLabel;
}

- (HDRatingStarView *)startView {
    if (!_startView) {
        _startView = [[HDRatingStarView alloc] init];
        _startView.starImage = [UIImage imageNamed:@"star_rating_level_1"];
        _startView.starWidth = 10;
        _startView.itemMargin = 2;
        _startView.renderColors = @[HDAppTheme.color.mainColor];
        _startView.countForOneStar = 1;
        _startView.score = 5;
        _startView.allowTouchToSelectScore = NO;
        _startView.allowSlideToChangeScore = NO;
    }
    return _startView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.color.G4;
    }
    return _lineView;
}

- (SALabel *)positiverateLabel {
    if (!_positiverateLabel) {
        _positiverateLabel = [[SALabel alloc] init];
        _positiverateLabel.textColor = HDAppTheme.color.G1;
        _positiverateLabel.font = HDAppTheme.font.amountOnly;
        _positiverateLabel.text = @"97%";
        [_positiverateLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _positiverateLabel;
}

- (SALabel *)positiverateTitleLabel {
    if (!_positiverateTitleLabel) {
        _positiverateTitleLabel = [[SALabel alloc] init];
        _positiverateTitleLabel.textColor = HDAppTheme.color.G3;
        _positiverateTitleLabel.font = HDAppTheme.font.standard4;
        _positiverateTitleLabel.text = WMLocalizedString(@"positive_rate", @"好评率");
        _positiverateTitleLabel.numberOfLines = 0;
        [_positiverateTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _positiverateTitleLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = HDAppTheme.color.G5;
    }
    return _bottomLineView;
}

- (WMReviewFilterView *)filterView {
    if (!_filterView) {
        _filterView = WMReviewFilterView.new;
        _filterView.defaultHasContentButtonStatus = YES;

        NSString *countStr = @"(0)";
        NSMutableArray<WMReviewFilterButtonConfig *> *dataSource = [NSMutableArray arrayWithCapacity:4];

        WMReviewFilterButtonConfig *config = [WMReviewFilterButtonConfig configWithTitle:[NSString stringWithFormat:@"%@%@", WMLocalizedString(@"store_reviews_all", @"全部"), countStr]
                                                                                    type:WMReviewFilterTypeAll];
        config.isSelected = true;
        [dataSource addObject:config];

        config = [WMReviewFilterButtonConfig configWithTitle:[NSString stringWithFormat:@"%@%@", WMLocalizedString(@"store_reviews_praise", @"好评"), countStr] type:WMReviewFilterTypeGood];
        [dataSource addObject:config];
        
        config = [WMReviewFilterButtonConfig configWithTitle:[NSString stringWithFormat:@"%@%@", WMLocalizedString(@"wm_evaluation_medium_reviews", @"中评"), countStr] type:WMReviewFilterTypeMiddle];
        [dataSource addObject:config];


        config = [WMReviewFilterButtonConfig configWithTitle:[NSString stringWithFormat:@"%@%@", WMLocalizedString(@"store_reviews_critical", @"差评"), countStr] type:WMReviewFilterTypeBad];
        [dataSource addObject:config];

        config = [WMReviewFilterButtonConfig configWithTitle:[NSString stringWithFormat:@"%@%@", WMLocalizedString(@"store_reviews_image", @"有图"), countStr] type:WMReviewFilterTypeWithImage];
        [dataSource addObject:config];

        _filterView.dataSource = dataSource;

        @HDWeakify(self);
        _filterView.clickedFilterButtonBlock = ^(HDUIGhostButton *_Nonnull button, WMReviewFilterButtonConfig *_Nonnull config) {
            @HDStrongify(self);
            self.viewModel.filterType = config.type;
            [self.viewModel getNewData];
        };
        _filterView.clickedHasContentButtonBlock = ^(BOOL isSelected) {
            @HDStrongify(self);
            self.viewModel.hasDetailCondition = isSelected ? WMReviewFilterConditionHasDetailRequired : WMReviewFilterConditionHasDetailOrNone;
            [self.viewModel getNewData];
        };
    }
    return _filterView;
}

@end
