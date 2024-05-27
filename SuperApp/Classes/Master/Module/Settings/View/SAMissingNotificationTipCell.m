//
//  SAMissingNotificationTipCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMissingNotificationTipCell.h"


@interface SAMissingNotificationTipCell ()
/// 内容
@property (nonatomic, strong) SAMissingNotificationTipView *view;
@end


@implementation SAMissingNotificationTipCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
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
- (void)setModel:(SAMissingNotificationTipModel *)model {
    _model = model;

    self.view.model = model;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SAMissingNotificationTipView *)view {
    return _view ?: ({ _view = SAMissingNotificationTipView.new; });
}
@end
