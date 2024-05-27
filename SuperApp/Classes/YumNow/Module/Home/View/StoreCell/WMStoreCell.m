//
//  WMStoreCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreCell.h"
#import "WMStoreView.h"


@interface WMStoreCell ()
/// 内容
@property (nonatomic, strong) WMStoreView *view;
@end


@implementation WMStoreCell
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bg3;
    [self.contentView addSubview:self.view];
}

- (void)updateConstraints {
    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(WMBaseStoreModel *)model {
    _model = model;

    self.view.model = model;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (WMStoreView *)view {
    return _view ?: ({ _view = WMStoreView.new; });
}
@end
