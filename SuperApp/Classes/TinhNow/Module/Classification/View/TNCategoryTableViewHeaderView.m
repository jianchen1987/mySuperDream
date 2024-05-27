//
//  TNCategoryTableViewHeaderView.m
//  SuperApp
//
//  Created by seeu on 2020/7/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCategoryTableViewHeaderView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAInternationalizationModel.h"
#import <Masonry/Masonry.h>


@interface TNCategoryTableViewHeaderView ()

/// title
@property (nonatomic, strong) UILabel *titleLable;
/// line
@property (nonatomic, strong) UIView *line;

@end


@implementation TNCategoryTableViewHeaderView

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.line];
    self.contentView.backgroundColor = HDAppTheme.TinhNowColor.G5;
}

- (void)updateConstraints {
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable.mas_right).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(0.5);
        make.centerY.equalTo(self.titleLable.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(50);
    }];

    [super updateConstraints];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLable.text = _title;
    [self setNeedsUpdateConstraints];
}
#pragma mark - lazy load
/** @lazy titleLabel */
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = HDAppTheme.TinhNowColor.C1;
        _titleLable.font = HDAppTheme.TinhNowFont.standard15B;
    }
    return _titleLable;
}

/** @lazy line */
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.TinhNowColor.C1;
    }
    return _line;
}

@end
