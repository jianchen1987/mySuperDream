//
//  WMCNStoreTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/12/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCNStoreTableViewCell.h"
#import "WMCNStoreView.h"

@interface WMCNStoreTableViewCell ()
/// 内容
@property (nonatomic, strong) WMCNStoreView *view;

@end


@implementation WMCNStoreTableViewCell

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
- (WMCNStoreView *)view {
    return _view ?: ({ _view = WMCNStoreView.new; });
}

@end
