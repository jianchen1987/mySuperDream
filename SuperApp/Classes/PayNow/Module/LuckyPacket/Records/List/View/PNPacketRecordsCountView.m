//
//  PNPacketRecordsCountView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketRecordsCountView.h"
#import "NSDate+Extension.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNSingleSelectedAlertView.h"


@interface PNPacketRecordsCountView ()
@property (nonatomic, strong) SALabel *countLabel;
@property (nonatomic, strong) HDUIButton *dateBtn;
@property (nonatomic, strong) SALabel *amountLabel;

@property (nonatomic, copy) NSString *currentSelectDateYear;

@end


@implementation PNPacketRecordsCountView

- (void)hd_setupViews {
    self.currentSelectDateYear = [NSString stringWithFormat:@"%zd", [NSDate.date year]];

    [self addSubview:self.countLabel];
    [self addSubview:self.dateBtn];
    [self addSubview:self.amountLabel];
    self.backgroundColor = [UIColor clearColor];
}

- (void)updateConstraints {
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(16));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(16));
    }];

    [self.dateBtn sizeToFit];
    [self.dateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(16));
        make.height.equalTo(@(kRealWidth(28)));
        make.centerY.mas_equalTo(self.countLabel.mas_centerY);
    }];

    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel);
        make.top.mas_equalTo(self.countLabel.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(20));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNPacketRecordRspModel *)model {
    _model = model;

    NSString *higStr = [NSString stringWithFormat:@"%zd", self.model.totalCount];
    NSString *allStr = @"";
    if ([self.viewType isEqualToString:@"send"]) {
        allStr = [NSString stringWithFormat:PNLocalizedString(@"pn_send_count_packet", @"共发出%@个红包"), higStr];
    } else {
        allStr = [NSString stringWithFormat:PNLocalizedString(@"pn_reciver_count_packet", @"共收到%@个红包"), higStr];
    }

    self.countLabel.attributedText = [NSMutableAttributedString highLightString:higStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard12 highLightColor:HDAppTheme.PayNowColor.cFFFFFF
                                                                        norFont:HDAppTheme.PayNowFont.standard12
                                                                       norColor:[UIColor hd_colorWithHexString:@"#FDA5B2"]];

    NSString *amountHigStr = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:self.model.totalAmt ?: @"0" currencyCode:PNCurrencyTypeKHR];
    NSString *amountAllStr = [NSString stringWithFormat:@"%@%@", [PNCommonUtils getCurrencySymbolByCode:PNCurrencyTypeKHR], amountHigStr];
    self.amountLabel.attributedText = [NSMutableAttributedString highLightString:amountHigStr inWholeString:amountAllStr highLightFont:[HDAppTheme.PayNowFont fontDINBold:40]
                                                                  highLightColor:HDAppTheme.PayNowColor.cFFFFFF
                                                                         norFont:[HDAppTheme.PayNowFont fontDINBold:30]
                                                                        norColor:HDAppTheme.PayNowColor.cFFFFFF];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (NSString *)setYearStr:(NSString *)year {
    //    return [NSString stringWithFormat:@"%@%@", PNLocalizedString(@"DATEPICKER_YEAR", @"年"), year];
    return year;
}

- (void)handleYearAlerView {
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger endYear = [NSDate.date year];

    for (NSInteger i = 2022; i <= endYear; i++) {
        PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
        NSString *iStr = [NSString stringWithFormat:@"%zd", i];
        model.name = [self setYearStr:iStr];
        model.itemId = iStr;
        if ([self.currentSelectDateYear isEqualToString:model.itemId]) {
            model.isSelected = YES;
        }

        [arr addObject:model];
    }

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:arr title:PNLocalizedString(@"pn_select_year", @"请选择年份")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        self.currentSelectDateYear = model.itemId;

        [self.dateBtn setTitle:model.name forState:UIControlStateNormal];
        [self setNeedsUpdateConstraints];

        !self.selectBlock ?: self.selectBlock(model.itemId);
    };
    [alertView show];
}

#pragma mark
- (SALabel *)countLabel {
    if (!_countLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = [UIColor hd_colorWithHexString:@"#FDA5B2"];
        label.font = HDAppTheme.PayNowFont.standard12;
        _countLabel = label;
    }
    return _countLabel;
}

- (SALabel *)amountLabel {
    if (!_amountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = [HDAppTheme.PayNowFont fontBold:40];
        label.adjustsFontSizeToFitWidth = YES;
        _amountLabel = label;
    }
    return _amountLabel;
}

- (HDUIButton *)dateBtn {
    if (!_dateBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self setYearStr:self.currentSelectDateYear] forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14M;
        button.imagePosition = HDUIButtonImagePositionRight;
        [button setImage:[UIImage imageNamed:@"pn_packet_btn_down_white"] forState:0];
        button.adjustsButtonWhenHighlighted = NO;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(8));
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kRealWidth(12));
        button.layer.cornerRadius = kRealWidth(14);
        button.layer.borderColor = HDAppTheme.PayNowColor.cFFFFFF.CGColor;
        button.layer.borderWidth = 1;

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self handleYearAlerView];
        }];

        _dateBtn = button;
    }
    return _dateBtn;
}
@end
