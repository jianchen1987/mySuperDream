//
//  TNMyCustomerItemHederView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyCustomerItemHederView.h"
#import "HDAppTheme+TinhNow.h"
#import "HDLabel.h"
#import "TNMultiLanguageManager.h"
#import <Masonry/Masonry.h>


@interface TNMyCustomerItemHederView ()

@property (nonatomic, strong) HDLabel *nickNameLabel;

@property (nonatomic, strong) HDLabel *phoneLabel;

@property (nonatomic, strong) HDLabel *orderTimeLabel;

@end


@implementation TNMyCustomerItemHederView

+ (instancetype)viewWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"TNMyCustomerItemHederView";
    TNMyCustomerItemHederView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!view) {
        view = [[TNMyCustomerItemHederView alloc] initWithReuseIdentifier:identifier];
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
    self.contentView.backgroundColor = HDAppTheme.TinhNowColor.cFFFFFF;
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.phoneLabel];
    [self addSubview:self.orderTimeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSArray *viewArray = @[self.nickNameLabel, self.phoneLabel, self.orderTimeLabel];
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(12);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
    }];
}

#pragma mark
- (HDLabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[HDLabel alloc] init];
        _nickNameLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _nickNameLabel.font = HDAppTheme.TinhNowFont.standard14;
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.text = TNLocalizedString(@"jgHcuYmH", @"昵称");
    }
    return _nickNameLabel;
}

- (HDLabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[HDLabel alloc] init];
        _phoneLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _phoneLabel.font = HDAppTheme.TinhNowFont.standard14;
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
        _phoneLabel.text = TNLocalizedString(@"EflnCwt2", @"手机号");
    }
    return _phoneLabel;
}

- (HDLabel *)orderTimeLabel {
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[HDLabel alloc] init];
        _orderTimeLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _orderTimeLabel.font = HDAppTheme.TinhNowFont.standard14;
        _orderTimeLabel.textAlignment = NSTextAlignmentCenter;
        _orderTimeLabel.text = TNLocalizedString(@"AegA4yhW", @"下单时间");
    }
    return _orderTimeLabel;
}

@end
