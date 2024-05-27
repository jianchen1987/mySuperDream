//
//  SAPaymentMarketTipsView.m
//  SuperApp
//
//  Created by seeu on 2022/5/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAPaymentMarketTipsView.h"


@interface SAPaymentMarketTipsView ()

///<
@property (nonatomic, strong) UIView *container;
///< info
@property (nonatomic, strong) NSMutableArray<HDLabel *> *infos;

@end


@implementation SAPaymentMarketTipsView

- (void)hd_setupViews {
    [self addSubview:self.container];
    self.infos = [[NSMutableArray alloc] initWithCapacity:1];
}

- (void)updateConstraints {
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.mas_bottom).offset(-kRealHeight(15));
    }];

    __block UIView *refView = nil;
    [self.container.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.container.mas_left).offset(kRealWidth(10));
            make.right.equalTo(self.mas_right).offset(-kRealWidth(10));
            if (refView) {
                make.top.equalTo(refView.mas_bottom).offset(kRealHeight(5));
            } else {
                make.top.equalTo(self.container.mas_top).offset(kRealHeight(6.5));
            }
        }];
        refView = obj;
    }];

    if (refView) {
        [refView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.container.mas_bottom).offset(-kRealHeight(6.5));
        }];
    }

    [super updateConstraints];
}

- (void)setMarketingInfo:(NSArray<NSString *> *)marketingInfo {
    _marketingInfo = [marketingInfo copy];

    [self.container hd_removeAllSubviews];
    [self.infos removeAllObjects];

    [_marketingInfo enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        HDLabel *label = HDLabel.new;
        label.text = obj;
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.hd_edgeInsets = UIEdgeInsetsMake(3, 0, 3, 0);
        [self.container addSubview:label];
        [self.infos addObject:label];
    }];

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)container {
    if (!_container) {
        _container = UIView.new;
        _container.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setGradualChangingColorFromColor:[UIColor hd_colorWithHexString:@"#FC7200"] toColor:[UIColor hd_colorWithHexString:@"#F83E00"] startPoint:CGPointMake(0, 0.5)
                                          endPoint:CGPointMake(1, 0.5)];
            [view setRoundedCorners:UIRectCornerAllCorners radius:5.0];
        };
    }
    return _container;
}

@end
