//
//  PNNotifyView.m
//  SuperApp
//
//  Created by xixi on 2023/1/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNNotifyView.h"


@interface PNNotifyView ()
@property (nonatomic, strong) SALabel *contentLabel;
@end


@implementation PNNotifyView

- (void)hd_setupViews {
    self.backgroundColor = [UIColor hd_colorWithHexString:@"#804a2d"];
    [self addSubview:self.contentLabel];
}

- (void)updateConstraints {
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(8));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(8));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(8));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(8));
    }];

    [super updateConstraints];
}

- (void)setContent:(NSString *)content {
    _content = content;

    self.contentLabel.text = self.content;

    [self setNeedsUpdateConstraints];
}

- (CGFloat)getViewHeight {
    CGSize newSize = [self.contentLabel sizeThatFits:CGSizeMake(kScreenWidth - kRealWidth(16), MAXFLOAT)];
    return newSize.height + kRealWidth(16);
}

#pragma mark
- (SALabel *)contentLabel {
    if (!_contentLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 0;
        _contentLabel = label;
    }
    return _contentLabel;
}
@end
