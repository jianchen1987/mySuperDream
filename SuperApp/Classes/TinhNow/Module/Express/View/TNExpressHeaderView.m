//
//  TNExpressHeaderView.m
//  SuperApp
//
//  Created by xixi on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressHeaderView.h"
#import "HDAppTheme+TinhNow.h"


@interface TNExpressHeaderView ()
/// 小卡车icon
@property (nonatomic, strong) UIImageView *iconImgView;
/// 物流公司名称
@property (nonatomic, strong) UILabel *expressName;
/// 物流单号
@property (nonatomic, strong) UILabel *expressNo;
/// 物流时间
@property (nonatomic, strong) UILabel *createTimeLabel;

@end


@implementation TNExpressHeaderView

- (void)hd_setupViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.expressName];
    [self addSubview:self.expressNo];
    [self addSubview:self.createTimeLabel];

    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setGradualChangingColorFromColor:HDAppTheme.TinhNowColor.C1 toColor:HDAppTheme.TinhNowColor.C2];
    };
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15.f);
        make.top.mas_equalTo(self.mas_top).offset(20.f);
        make.size.mas_equalTo(self.iconImgView.image.size);
    }];

    [self.expressName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10.f);
        make.right.mas_equalTo(self.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.mas_top).offset(22.f);
    }];

    [self.expressNo mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10.f);
        make.top.mas_equalTo(self.expressName.mas_bottom).offset(5.f);
        make.right.mas_equalTo(self.mas_right).offset(-15.f);
    }];

    [self.createTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10.f);
        make.right.mas_equalTo(self.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.expressNo.mas_bottom).offset(10.f);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20.f);
    }];

    [super updateConstraints];
}

- (void)setModel:(TNExpressDetailsModel *)model {
    _model = model;
    self.expressName.text = model.deliveryCorp;
    self.expressNo.text = model.trackingNo;

    NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:[model.createdDate doubleValue] / 1000.0];
    self.createTimeLabel.text = [SAGeneralUtil getDateStrWithDate:createdDate format:@"dd/MM/yyyy HH:mm:ss"];

    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"tn_order_detail_express_car"];
    }
    return _iconImgView;
}

- (UILabel *)expressName {
    if (!_expressName) {
        _expressName = [[UILabel alloc] init];
        _expressName.font = [HDAppTheme.TinhNowFont fontMedium:15.f];
        _expressName.textColor = [UIColor whiteColor];
    }
    return _expressName;
}

- (UILabel *)expressNo {
    if (!_expressNo) {
        _expressNo = [[UILabel alloc] init];
        _expressNo.font = [HDAppTheme.TinhNowFont fontMedium:15.f];
        _expressNo.textColor = [UIColor whiteColor];
    }
    return _expressNo;
}

- (UILabel *)createTimeLabel {
    if (!_createTimeLabel) {
        _createTimeLabel = [[UILabel alloc] init];
        _createTimeLabel.font = [HDAppTheme.TinhNowFont fontMedium:12.f];
        _createTimeLabel.textColor = [UIColor whiteColor];
    }
    return _createTimeLabel;
}


@end
