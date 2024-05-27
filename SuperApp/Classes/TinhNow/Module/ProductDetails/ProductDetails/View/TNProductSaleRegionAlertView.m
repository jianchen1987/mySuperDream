//
//  TNProductSaleRegionAlertView.m
//  SuperApp
//
//  Created by xixi on 2021/2/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductSaleRegionAlertView.h"
#import "HDAppTheme+TinhNow.h"


@interface TNProductSaleRegionAlertView ()
/// 显示内容的文本
@property (nonatomic, strong) UILabel *contentLabel;
@end


@implementation TNProductSaleRegionAlertView

- (instancetype)initWithFrame:(CGRect)frame data:(NSString *)showStr {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentLabel.text = showStr;
    }
    return self;
}

- (void)hd_setupViews {
    self.contentLabel.frame = CGRectMake(0, 0, self.hd_width, 10);
    [self addSubview:self.contentLabel];
}

- (void)layoutyImmediately {
    [self.contentLabel sizeToFit];
    CGFloat height = self.contentLabel.bottom + kRealHeight(50);
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), height);
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _contentLabel.font = [HDAppTheme.TinhNowFont fontRegular:14.f];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
