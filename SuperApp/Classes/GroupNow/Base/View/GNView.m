//
//  GNView.m
//  SuperApp
//
//  Created by wmz on 2021/5/31.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNView.h"


@implementation GNView

- (void)commonInit {
    [self hd_setupViews];
    [self hd_bindViewModel];
    if ([self gn_firstGetNewData])
        [self gn_getNewData];
    [self setNeedsUpdateConstraints];
}

- (BOOL)gn_firstGetNewData {
    return NO;
}

- (void)gn_getNewData {
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.color.gn_lineColor;
        [self addSubview:_lineView];
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(HDAppTheme.value.pixelOne);
            make.left.right.mas_equalTo(0);
        }];
    }
    return _lineView;
}

@end
