//
//  TNIncomeRecordListHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeRecordListHeaderView.h"
#import "HDAppTheme+TinhNow.h"
#import "HDCommonDefines.h"
#import "HDLabel.h"
#import "TNMultiLanguageManager.h"
#import "UIView+HD_Extension.h"
#import <HDKitCore/UIView+HDKitCore.h>
#import <Masonry/Masonry.h>


@interface TNIncomeRecordListHeaderView ()
///
@property (strong, nonatomic) UIView *containerView;
@property (nonatomic, strong) HDLabel *timerLabel;

@property (nonatomic, strong) HDLabel *moneyLabel;

@property (nonatomic, strong) HDLabel *descLabel;
@end


@implementation TNIncomeRecordListHeaderView

+ (instancetype)viewWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"TNIncomeRecordListHeaderView";
    TNIncomeRecordListHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!view) {
        view = [[TNIncomeRecordListHeaderView alloc] initWithReuseIdentifier:identifier];
    }

    return view;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews {
    self.contentView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.timerLabel];
    [self.containerView addSubview:self.moneyLabel];
    [self.containerView addSubview:self.descLabel];
}
- (void)setQueryMode:(NSInteger)queryMode {
    _queryMode = queryMode;
    if (queryMode == 1) {
        self.timerLabel.text = TNLocalizedString(@"8pF4Tooc", @"到账时间");
    } else if (queryMode == 2) {
        self.timerLabel.text = TNLocalizedString(@"tn_order_createtime", @"创建时间");
        ;
    }
}
- (void)layoutSubviews {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    NSArray *viewArray = @[self.timerLabel, self.moneyLabel, self.descLabel];
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_top).offset(12);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-12);
    }];
    [super layoutSubviews];
}

#pragma mark
- (HDLabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[HDLabel alloc] init];
        _timerLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _timerLabel.font = HDAppTheme.TinhNowFont.standard14;
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.text = TNLocalizedString(@"AZ3Za5xN", @"时间");
    }
    return _timerLabel;
}

- (HDLabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[HDLabel alloc] init];
        _moneyLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _moneyLabel.font = HDAppTheme.TinhNowFont.standard14;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.text = TNLocalizedString(@"kwCIcL1x", @"金额");
    }
    return _moneyLabel;
}

- (HDLabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[HDLabel alloc] init];
        _descLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _descLabel.font = HDAppTheme.TinhNowFont.standard14;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.text = TNLocalizedString(@"tn_remark", @"说明");
    }
    return _descLabel;
}
/** @lazy  containerView*/
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(8)];
        };
    }
    return _containerView;
}
@end
