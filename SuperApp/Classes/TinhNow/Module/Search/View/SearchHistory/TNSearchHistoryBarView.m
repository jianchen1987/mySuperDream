//
//  TNSearchHistoryBarView.m
//  SuperApp
//
//  Created by seeu on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSearchHistoryBarView.h"
#import "TNSearchBaseViewModel.h"


@interface TNSearchHistoryBarView ()
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// 清空按钮
@property (nonatomic, strong) HDUIButton *clearAllButton;
/// vm
@property (nonatomic, strong) TNSearchBaseViewModel *viewModel;

@end


@implementation TNSearchHistoryBarView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.clearAllButton];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];

    [self.clearAllButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [super updateConstraints];
}

#pragma mark - private methods
- (void)clearAllHistorySearch:(HDUIButton *)button {
    HDAlertView *alertView = [HDAlertView alertViewWithTitle:@"" message:TNLocalizedString(@"tn_alert_clearhistory_title", @"Are you sure to delete the history?") config:nil];
    [alertView addButton:[HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_button_cancel_title", @"Cancel") type:HDAlertViewButtonTypeCancel
                                                    handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                        [alertView dismiss];
                                                    }]];
    @HDWeakify(self);
    [alertView addButton:[HDAlertViewButton buttonWithTitle:TNLocalizedString(@"tn_button_confirm_title", @"Sure") type:HDAlertViewButtonTypeDefault
                                                    handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                                        [alertView dismiss];
                                                        @HDStrongify(self);
                                                        [self.viewModel clearAllSearchHistory];
                                                    }]];
    [alertView show];
}

#pragma mark - lazy load
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HDAppTheme.font.standard3;
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _titleLabel.text = TNLocalizedString(@"tn_page_searchhistory_title", @"Search History");
    }
    return _titleLabel;
}
/** @lazy clearAllButton */
- (HDUIButton *)clearAllButton {
    if (!_clearAllButton) {
        _clearAllButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_clearAllButton setImage:[UIImage imageNamed:@"tinhnow-ic-history-clearall"] forState:UIControlStateNormal];
        [_clearAllButton addTarget:self action:@selector(clearAllHistorySearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearAllButton;
}

@end
