//
//  WMOrderRefundReasonCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderRefundReasonCell.h"


@interface WMOrderRefundReasonCell ()
/// 顶部线
@property (nonatomic, strong) UIView *topLine;
/// 底部线
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation WMOrderRefundReasonCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.bottomLine];

    self.textLabel.font = HDAppTheme.font.standard2;
    self.textLabel.textColor = HDAppTheme.color.G2;
    self.textLabel.numberOfLines = 0;

    self.imageView.image = [UIImage imageNamed:@"icon_tick"];
    self.imageView.hidden = true;
}

- (void)updateConstraints {
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.imageView.isHidden) {
            make.size.mas_equalTo(self.imageView.image.size);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.centerY.equalTo(self.contentView);
        }
    }];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        if (self.imageView.isHidden) {
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        } else {
            make.right.equalTo(self.imageView.mas_left).offset(-5);
        }
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        make.centerY.equalTo(self.contentView);
    }];
    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.topLine.isHidden) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.height.mas_equalTo(PixelOne);
        }
    }];
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.height.mas_equalTo(PixelOne);
        }
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.imageView.hidden = !selected;
    [self setNeedsUpdateConstraints];
}

- (void)setModel:(WMOrderRefundReasonCellModel *)model {
    _model = model;

    self.textLabel.text = model.text;
    self.topLine.hidden = !model.needTopLine;
    self.bottomLine.hidden = !model.needBottomLine;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.new;
        _topLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
