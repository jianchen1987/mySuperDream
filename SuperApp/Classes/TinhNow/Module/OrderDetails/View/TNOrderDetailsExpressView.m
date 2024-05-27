//
//  TNOrderDetailsExpressView.m
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsExpressView.h"
#import "HDAppTheme+TinhNow.h"


@implementation TNOrderDetailsExpressView

- (void)hd_setupViews {
    [self addSubview:self.line];
    [self addSubview:self.iconImgView];
    [self addSubview:self.arrowBtn];
    [self addSubview:self.expressNoLabel];
    [self addSubview:self.timeLabel];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToExpressDetailsViewController)];
    [self addGestureRecognizer:tap];
}

- (void)updateConstraints {
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15.f);
        make.right.mas_equalTo(self.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.mas_top);
        make.height.equalTo(@(PixelOne));
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15.f);
        make.size.mas_equalTo(self.iconImgView.image.size);
        if (self.expressNoLabel.hidden) {
            make.top.mas_equalTo(self.line.mas_bottom).offset(14.f);
        } else {
            make.top.mas_equalTo(self.line.mas_bottom).offset(24.f);
        }
    }];

    [self.arrowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-5.f);
        make.width.height.equalTo(@(40.f));
        make.centerY.mas_equalTo(self.iconImgView.mas_centerY);
    }];

    [self.expressNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10.f);
        make.top.mas_equalTo(self.line.mas_bottom).offset(14.f);
        make.right.mas_equalTo(self.arrowBtn.mas_left).offset(-10.f);
    }];

    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10.f);
        make.right.mas_equalTo(self.expressNoLabel.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-16.f);
        if (self.expressNoLabel.hidden) {
            make.top.mas_equalTo(self.line.mas_bottom).offset(16.f);
        } else {
            make.top.mas_equalTo(self.expressNoLabel.mas_bottom).offset(5.f);
        }
    }];

    [super updateConstraints];
}

#pragma mark -
- (void)setExpressOrderModel:(TNOrderDetailExpressOrderModel *)expressOrderModel {
    _expressOrderModel = expressOrderModel;

    NSString *expressNo = self.expressOrderModel.trackingNo ?: @"";

    if (HDIsStringEmpty(expressNo)) {
        self.expressNoLabel.hidden = YES;
    } else {
        self.expressNoLabel.hidden = NO;
        NSString *nameStr = self.expressOrderModel.name ?: @"";
        self.expressNoLabel.text = [NSString stringWithFormat:@"%@%@%@", nameStr, HDIsStringNotEmpty(nameStr) ? @":" : @"", expressNo];
    }


    NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[self.expressOrderModel.createTime doubleValue] / 1000.0];
    NSString *timeStr = [SAGeneralUtil getDateStrWithDate:orderDate format:@"dd/MM/yyyy HH:mm:ss"];
    self.timeLabel.text = timeStr;

    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (void)goToExpressDetailsViewController {
    [[HDMediator sharedInstance] navigaveToExpressDetails:@{@"bizOrderId": self.expressOrderModel.unifiedOrderNo}];
    //    [[HDMediator sharedInstance] navigaveToExpressDetails:@{@"bizOrderId" : @"1350892513173237760"}];
}

#pragma mark -
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor whiteColor];
    }
    return _line;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"tn_order_detail_express_car"];
    }
    return _iconImgView;
}

- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBtn setImage:[UIImage imageNamed:@"tinhnow_white_back_arrow"] forState:0];
        [_arrowBtn addTarget:self action:@selector(goToExpressDetailsViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}

- (UILabel *)expressNoLabel {
    if (!_expressNoLabel) {
        _expressNoLabel = [[UILabel alloc] init];
        _expressNoLabel.textColor = [UIColor whiteColor];
        _expressNoLabel.font = [HDAppTheme.TinhNowFont fontSemibold:14.f];
    }
    return _expressNoLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [HDAppTheme.TinhNowFont fontMedium:12.f];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

@end
