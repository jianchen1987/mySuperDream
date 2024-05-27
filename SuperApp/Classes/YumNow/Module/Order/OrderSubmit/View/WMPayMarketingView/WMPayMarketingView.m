//
//  WMPayMarketingView.m
//  SuperApp
//
//  Created by wmz on 2022/9/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMPayMarketingView.h"


@interface WMPayMarketingView ()
/// iconIV
@property (nonatomic, strong) UIImageView *iconIV;
/// nameLB
@property (nonatomic, strong) HDLabel *nameLB;

@end


@implementation WMPayMarketingView
- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.WMColor.bg3;
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLB];
}

- (void)updateConstraints {
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_top).offset(kRealWidth(11));
        make.left.equalTo(self.iconIV.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.iconIV.mas_right).offset(-kRealWidth(8));
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(-kRealWidth(6));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(-kRealWidth(15));
        make.bottom.mas_equalTo(-kRealWidth(12));
    }];
    [super updateConstraints];
}

- (void)setMarketingInfo:(NSArray<NSString *> *)marketingInfo {
    _marketingInfo = marketingInfo;
    self.nameLB.text = [marketingInfo componentsJoinedByString:@"\n"];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = kRealWidth(4);
    self.nameLB.attributedText = [[NSMutableAttributedString alloc] initWithString:self.nameLB.text attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = HDLabel.new;
        _nameLB.textColor = HDAppTheme.WMColor.mainRed;
        _nameLB.font = [HDAppTheme.WMFont wm_ForSize:11];
        _nameLB.numberOfLines = 0;
    }
    return _nameLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        UIImage *image = [UIImage imageNamed:@"yn_submit_pic_payment"];
        _iconIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.2, image.size.width * 0.3, image.size.height * 0.6, image.size.width * 0.5)
                                              resizingMode:UIImageResizingModeStretch];
    }
    return _iconIV;
}
@end
