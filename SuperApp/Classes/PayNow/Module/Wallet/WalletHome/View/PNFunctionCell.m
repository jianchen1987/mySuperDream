//
//  FunctionCell.m
//  SuperApp
//
//  Created by Quin on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNFunctionCell.h"


@implementation PNFunctionCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImage];
    [self.bgView addSubview:self.titleLB];
    [self.bgView addSubview:self.countLabel];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView.mas_top);
        make.width.equalTo(@(kRealWidth(40)));
        make.height.equalTo(@(kRealWidth(40)));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImage.mas_bottom).offset(kRealWidth(5));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(5));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-5));
    }];

    if (!self.countLabel.hidden) {
        [self.countLabel sizeToFit];
        [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.countLabel.width + kRealWidth(8));
            make.height.mas_equalTo(self.countLabel.height + kRealWidth(4));
            make.top.mas_equalTo(self.iconImage.mas_top);
            make.centerX.mas_equalTo(self.iconImage.mas_right);
        }];
    }

    [super updateConstraints];
}
#pragma mark - getters and setters
- (void)setModel:(PNFunctionCellModel *)model {
    _model = model;
    if ([model.imageName hasPrefix:@"http"]) {
        [HDWebImageManager setImageWithURL:model.imageName placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(40, 40)] imageView:self.iconImage];
    } else {
        self.iconImage.image = [UIImage imageNamed:model.imageName];
    }
    self.titleLB.text = _model.title;

    if (self.model.count > 0) {
        self.countLabel.hidden = NO;
        if (self.model.count > 99) {
            self.countLabel.text = @"99+";
        } else {
            self.countLabel.text = [NSString stringWithFormat:@"%zd", model.count];
        }
    } else {
        self.countLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    }
    return _bgView;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = UIImageView.new;
    }
    return _iconImage;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:13];
        label.textColor = HDAppTheme.PayNowColor.c2A251F;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)countLabel {
    if (!_countLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 4;
        label.layer.masksToBounds = YES;
        _countLabel = label;
    }
    return _countLabel;
}
@end
