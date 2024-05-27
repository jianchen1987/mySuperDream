//
//  PNApartmentComfirmMoreView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentComfirmMoreView.h"
#import "PNTableView.h"
#import "PNApartmentListCell.h"
#import "NSMutableAttributedString+Highlight.h"


@interface PNApartmentComfirmMoreView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SALabel *amountLabel;
@property (nonatomic, strong) SALabel *tipsLabel;
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) PNOperationButton *nextBtn;
@property (nonatomic, strong) PNTableView *tableView;
@end


@implementation PNApartmentComfirmMoreView

- (void)plus {
    if (!WJIsArrayEmpty(self.dataSource)) {
        SAMoneyModel *countAmountModel = ((PNApartmentListItemModel *)[self.dataSource firstObject]).paymentAmount;
        for (int i = 1; i < self.dataSource.count; i++) {
            PNApartmentListItemModel *itemModel = [self.dataSource objectAtIndex:i];
            countAmountModel = [countAmountModel plus:itemModel.paymentAmount];
        }

        NSString *hightStr = [countAmountModel thousandSeparatorAmountNoCurrencySymbol];
        NSString *allStr = [NSString stringWithFormat:@"%@%@", [PNCommonUtils getCurrencySymbolByCode:countAmountModel.cy], hightStr];
        self.amountLabel.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:[HDAppTheme.PayNowFont fontDINBold:32]
                                                                      highLightColor:HDAppTheme.PayNowColor.mainThemeColor
                                                                             norFont:[HDAppTheme.PayNowFont fontDINBold:14]
                                                                            norColor:HDAppTheme.PayNowColor.mainThemeColor];
    }
}

- (void)hd_setupViews {
    [self addSubview:self.amountLabel];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.tableView];
    [self addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.nextBtn];
}

- (void)updateConstraints {
    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(30));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(kRealWidth(4));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];

    [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
    }];

    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomBgView.mas_top).offset(kRealWidth(8));
        make.left.mas_equalTo(self.bottomBgView.mas_left).offset(kRealWidth(20));
        make.right.mas_equalTo(self.bottomBgView.mas_right).offset(-kRealWidth(20));
        make.bottom.mas_equalTo(self.bottomBgView.mas_bottom).offset(-(kRealWidth(8) + kiPhoneXSeriesSafeBottomHeight));
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(30));
        make.bottom.mas_equalTo(self.bottomBgView.mas_top);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setDataSource:(NSMutableArray<PNApartmentListItemModel *> *)dataSource {
    _dataSource = dataSource;
    [self.tableView successGetNewDataWithNoMoreData:NO];
    [self plus];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNApartmentListCell *cell = [PNApartmentListCell cellWithTableView:tableView];
    cell.cellType = PNApartmentListCellType_OnlyShow;
    cell.model = [self.dataSource objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
    }
    return _tableView;
}

- (SALabel *)amountLabel {
    if (!_amountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.textAlignment = NSTextAlignmentCenter;
        _amountLabel = label;
    }
    return _amountLabel;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = PNLocalizedString(@"bill_to_bo_paid", @"待缴费");
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0600].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, -4);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 8;
        _bottomBgView = view;
    }
    return _bottomBgView;
}

- (PNOperationButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_nextBtn setTitle:PNLocalizedString(@"pn_confirm", @"确认") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_nextBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.payNowBlock ?: self.payNowBlock(self.dataSource);
        }];
    }
    return _nextBtn;
}
@end
