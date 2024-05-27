//
//  WMStoreDetailHeaderTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDetailHeaderTableViewCell.h"


@implementation WMStoreDetailHeaderTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.headView];
    self.backgroundColor = self.contentView.backgroundColor = UIColor.clearColor;
}

- (void)setModel:(WMStoreDetailRspModel *)model {
    _model = model;
    self.headView.model = model;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (WMStoreDetailHeaderView *)headView {
    if (!_headView) {
        _headView = WMStoreDetailHeaderView.new;
    }
    return _headView;
}

@end
