//
//  TNSpecificationNameReusableView.m
//  SuperApp
//
//  Created by xixi on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSkuSpecTitleReusableView.h"
#import "HDAppTheme+TinhNow.h"
#import <Masonry.h>


@interface TNSkuSpecTitleReusableView ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *sectionTitleLabel;
@end


@implementation TNSkuSpecTitleReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self hd_setupViews];
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.line];
    [self addSubview:self.sectionTitleLabel];
}

- (void)updateConstraints {
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(PixelOne);
    }];
    [self.sectionTitleLabel sizeToFit];
    [self.sectionTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [super updateConstraints];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.sectionTitleLabel.text = titleStr;
    [self setNeedsUpdateConstraints];
}

#pragma mark -
- (UILabel *)sectionTitleLabel {
    if (!_sectionTitleLabel) {
        _sectionTitleLabel = [[UILabel alloc] init];
        _sectionTitleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15.f];
        _sectionTitleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
    }
    return _sectionTitleLabel;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hd_colorWithHexString:@"E1E1E1"];
    }
    return _line;
}
@end
