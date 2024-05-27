//
//  TNExpressInfoCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/4/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExpressInfoCell.h"
#import "TNExpressCopyView.h"


@implementation TNExpressInfoCellModel
@end


@interface TNExpressInfoCell ()
/// 物流公司名称
@property (strong, nonatomic) HDLabel *expressCompanyLB;
/// 物流单号
@property (strong, nonatomic) TNExpressCopyView *numberView;
/// 物流官网
@property (strong, nonatomic) TNExpressCopyView *websiteView;

@end


@implementation TNExpressInfoCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.expressCompanyLB];
    [self.contentView addSubview:self.numberView];
    [self.contentView addSubview:self.websiteView];
}
- (void)updateConstraints {
    [self.expressCompanyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(20));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    if (!self.numberView.isHidden) {
        [self.numberView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.expressCompanyLB.mas_bottom).offset(kRealWidth(8));
            if (self.websiteView.isHidden) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(7));
            }
        }];
    }
    if (!self.websiteView.isHidden) {
        [self.websiteView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            if (!self.numberView.isHidden) {
                make.top.equalTo(self.numberView.mas_bottom);
            } else {
                make.top.equalTo(self.expressCompanyLB.mas_bottom).offset(kRealWidth(8));
            }
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(7));
        }];
    }
    [super updateConstraints];
}
- (void)setModel:(TNExpressInfoCellModel *)model {
    _model = model;
    self.expressCompanyLB.text = model.deliveryCorp;
    if (HDIsStringNotEmpty(model.trackingNo)) {
        self.numberView.hidden = NO;
        self.numberView.dic = @{@"key": TNLocalizedString(@"yU7gBsjh", @"物流单号"), @"value": model.trackingNo};
    } else {
        self.numberView.hidden = YES;
    }
    if (HDIsStringNotEmpty(model.deliveryCorpUrl)) {
        self.websiteView.hidden = NO;
        self.websiteView.dic = @{@"key": TNLocalizedString(@"5lQYLbkc", @"物流官网"), @"value": model.deliveryCorpUrl};
    } else {
        self.websiteView.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
/** @lazy expressCompanyLB */
- (HDLabel *)expressCompanyLB {
    if (!_expressCompanyLB) {
        _expressCompanyLB = [[HDLabel alloc] init];
        _expressCompanyLB.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _expressCompanyLB.textColor = HDAppTheme.TinhNowColor.G1;
        _expressCompanyLB.numberOfLines = 0;
    }
    return _expressCompanyLB;
}
/** @lazy numberView */
- (TNExpressCopyView *)numberView {
    if (!_numberView) {
        _numberView = [[TNExpressCopyView alloc] init];
    }
    return _numberView;
}
/** @lazy websiteView */
- (TNExpressCopyView *)websiteView {
    if (!_websiteView) {
        _websiteView = [[TNExpressCopyView alloc] init];
    }
    return _websiteView;
}
@end
