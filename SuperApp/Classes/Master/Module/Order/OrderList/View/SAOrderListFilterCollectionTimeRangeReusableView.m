//
//  SAOrderListFilterCollectionTimeRangeReusableView.m
//  SuperApp
//
//  Created by Tia on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderListFilterCollectionTimeRangeReusableView.h"
#import "SAAppTheme.h"
#import "SAMultiLanguageManager.h"
#import "UIColor+HDKitCore.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDUIKit.h>
#import <Masonry.h>


@interface SAOrderListFilterCollectionTimeRangeReusableView ()

@property (nonatomic, strong) HDUIGhostButton *startButton;

@property (nonatomic, strong) HDUIGhostButton *endButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) NSString *filterStartDate;

@property (nonatomic, copy) NSString *filterEndDate;

@end


@implementation SAOrderListFilterCollectionTimeRangeReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hd_setupViews];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.startButton];
    [self addSubview:self.endButton];
    [self addSubview:self.lineView];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.startButton);
        make.size.mas_equalTo(CGSizeMake(10, 1));
    }];

    [self.startButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth(32));
        make.right.equalTo(self.lineView.mas_left).offset(-12);
        make.left.equalTo(self);
        make.top.mas_equalTo(8);
    }];

    [self.endButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(self.startButton);
        make.left.equalTo(self.lineView.mas_right).offset(12);
        make.right.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - public method
- (void)updateStartDate:(NSString *)startDate endDate:(NSString *)endDate {
    self.filterStartDate = startDate;
    self.filterEndDate = endDate;

    [self btn:self.startButton setIsSelected:startDate ? YES : NO title:startDate ? self.filterStartDate : SALocalizedString(@"oc_start_time", @"起始时间")];
    [self btn:self.endButton setIsSelected:endDate ? YES : NO title:endDate ? self.filterEndDate : SALocalizedString(@"oc_end_time", @"结束时间")];
}

- (void)btn:(HDUIGhostButton *)btn setIsSelected:(BOOL)isSelected title:(NSString *)title {
    if (isSelected) {
        btn.ghostColor = HDAppTheme.color.sa_C1;
        btn.borderWidth = 1;
        //        btn.backgroundColor = [HDAppTheme.color.sa_C1 colorWithAlphaComponent:0.06];
    } else {
        btn.ghostColor = [UIColor hd_colorWithHexString:@"#999999"];
        btn.borderWidth = 0;
        //        btn.backgroundColor = [[UIColor hd_colorWithHexString:@"#999999"] colorWithAlphaComponent:0.1];
    }
    [btn setTitle:title forState:UIControlStateNormal];
}

#pragma mark lazy
- (HDUIGhostButton *)startButton {
    if (!_startButton) {
        HDUIGhostButton *button = [[HDUIGhostButton alloc] initWithGhostType:HDUIGhostButtonColorWhite];
        button.titleLabel.font = HDAppTheme.font.sa_standard12M;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
        //        button.backgroundColor = [[UIColor hd_colorWithHexString:@"#999999"] colorWithAlphaComponent:0.1];
        button.backgroundColor = UIColor.whiteColor;
        button.ghostColor = [UIColor hd_colorWithHexString:@"#999999"];
        [button setTitle:SALocalizedString(@"oc_start_time", @"起始时间") forState:UIControlStateNormal];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.chooseDateBlock ?: self.chooseDateBlock(NO);
        }];

        _startButton = button;
    }
    return _startButton;
}

- (HDUIGhostButton *)endButton {
    if (!_endButton) {
        HDUIGhostButton *button = [[HDUIGhostButton alloc] initWithGhostType:HDUIGhostButtonColorWhite];
        button.titleLabel.font = HDAppTheme.font.sa_standard12M;
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
        button.backgroundColor = UIColor.whiteColor;
        button.ghostColor = [UIColor hd_colorWithHexString:@"#999999"];
        [button setTitle:SALocalizedString(@"oc_end_time", @"终止时间") forState:UIControlStateNormal];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.chooseDateBlock ?: self.chooseDateBlock(YES);
        }];
        _endButton = button;
    }
    return _endButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.color.sa_separatorLineColor;
    }
    return _lineView;
}

@end
