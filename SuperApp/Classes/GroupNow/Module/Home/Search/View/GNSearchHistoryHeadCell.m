//
//  GNSearchHistoryHeadCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNSearchHistoryHeadCell.h"


@interface GNSearchHistoryHeadCell ()

@property (nonatomic, strong) HDLabel *leftLB;

@property (nonatomic, strong) HDUIButton *rightBtn;

@end


@implementation GNSearchHistoryHeadCell

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.contentView addSubview:self.leftLB];
    [self.contentView addSubview:self.rightBtn];
}

- (void)updateConstraints {
    [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(30), kRealWidth(30)));
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.gn_marginL);
        make.centerY.equalTo(self.contentView);
    }];

    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.gn_marginL);
        make.right.equalTo(self.rightBtn.mas_left).offset(-HDAppTheme.value.gn_marginL);
        make.centerY.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

- (void)clearAtion:(HDUIButton *)sender {
    [GNEvent eventResponder:self target:sender key:@"GNHistoryClear"];
}

- (void)setGNModel:(GNCellModel *)data {
    self.leftLB.text = data.title;
    self.lineView.hidden = YES;
    self.contentView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"gn_search_trash"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clearAtion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = HDLabel.new;
    }
    return _leftLB;
}

@end
