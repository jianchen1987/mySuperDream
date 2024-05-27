//
//  TNSubmitReviewFooterView.m
//  SuperApp
//
//  Created by xixi on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSubmitReviewFooterView.h"
#import "HDAppTheme+TinhNow.h"
#import "HDRatingStarView.h"
#import "TNSubmitReviewModel.h"


@interface TNSubmitReviewFooterView ()
@property (nonatomic, strong) UILabel *titleLabel;
/// 服务态度
@property (nonatomic, strong) UILabel *serviceScoreLabel;
@property (nonatomic, strong) HDRatingStarView *serviceScoreStarView;
/// 物流服务
@property (nonatomic, strong) UILabel *logisticsScoreLabel;
@property (nonatomic, strong) HDRatingStarView *logisticsScoreStarView;

@end


@implementation TNSubmitReviewFooterView

- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.serviceScoreLabel];
    [self addSubview:self.serviceScoreStarView];
    [self addSubview:self.logisticsScoreLabel];
    [self addSubview:self.logisticsScoreStarView];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15.f));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(15.f));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15.f));
    }];

    [self.serviceScoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(15.f));
    }];

    [self.serviceScoreStarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self.serviceScoreStarView sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)]);
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15.f));
        make.centerY.equalTo(self.serviceScoreLabel);
    }];

    [self.logisticsScoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.serviceScoreLabel.mas_left);
        make.top.mas_equalTo(self.serviceScoreLabel.mas_bottom).offset(kRealWidth(15.f));
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-15.f));
    }];

    [self.logisticsScoreStarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self.logisticsScoreStarView sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)]);
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15.f));
        make.centerY.equalTo(self.logisticsScoreLabel);
    }];

    [super updateConstraints];
}

#pragma mark -
- (void)setModel:(TNSubmitReviewModel *)model {
    _model = model;
    self.serviceScoreStarView.score = model.serviceScore;
    self.logisticsScoreStarView.score = model.logisticsScore;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:15.f];
        _titleLabel.text = TNLocalizedString(@"tn_storeReview", @"商家评价");
    }
    return _titleLabel;
}

- (UILabel *)serviceScoreLabel {
    if (!_serviceScoreLabel) {
        _serviceScoreLabel = [[UILabel alloc] init];
        _serviceScoreLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _serviceScoreLabel.font = [HDAppTheme.TinhNowFont fontRegular:15.f];
        _serviceScoreLabel.text = TNLocalizedString(@"tn_serviceAttitude", @"服务态度");
    }
    return _serviceScoreLabel;
}

- (HDRatingStarView *)serviceScoreStarView {
    if (!_serviceScoreStarView) {
        _serviceScoreStarView = [[HDRatingStarView alloc] init];
        _serviceScoreStarView.starImage = [UIImage imageNamed:@"star_rating_level_1"];
        _serviceScoreStarView.starWidth = 20;
        _serviceScoreStarView.itemMargin = 8;
        _serviceScoreStarView.renderColors = @[HDAppTheme.TinhNowColor.C1, HexColor(0xFFC95F)];
        _serviceScoreStarView.countForOneStar = 1;
        _serviceScoreStarView.score = 0;
        _serviceScoreStarView.allowSlideToChangeScore = NO;
        @HDWeakify(self);
        _serviceScoreStarView.selectScoreHandler = ^(CGFloat score) {
            @HDStrongify(self);
            self.model.serviceScore = (NSInteger)score;
        };
    }
    return _serviceScoreStarView;
}

- (UILabel *)logisticsScoreLabel {
    if (!_logisticsScoreLabel) {
        _logisticsScoreLabel = [[UILabel alloc] init];
        _logisticsScoreLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _logisticsScoreLabel.font = [HDAppTheme.TinhNowFont fontRegular:15.f];
        _logisticsScoreLabel.text = TNLocalizedString(@"tn_shippingServices", @"物流服务");
    }
    return _logisticsScoreLabel;
}

- (HDRatingStarView *)logisticsScoreStarView {
    if (!_logisticsScoreStarView) {
        _logisticsScoreStarView = [[HDRatingStarView alloc] init];
        _logisticsScoreStarView.starImage = [UIImage imageNamed:@"star_rating_level_1"];
        _logisticsScoreStarView.starWidth = 20;
        _logisticsScoreStarView.itemMargin = 8;
        _logisticsScoreStarView.renderColors = @[HDAppTheme.TinhNowColor.C1, HexColor(0xFFC95F)];
        _logisticsScoreStarView.countForOneStar = 1;
        _logisticsScoreStarView.score = 0;
        _logisticsScoreStarView.allowSlideToChangeScore = NO;
        @HDWeakify(self);
        _logisticsScoreStarView.selectScoreHandler = ^(CGFloat score) {
            @HDStrongify(self);
            self.model.logisticsScore = (NSInteger)score;
        };
    }
    return _logisticsScoreStarView;
}
@end
