//
//  WMSpecialActivesPictureView.m
//  SuperApp
//
//  Created by seeu on 2020/8/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMSpecialActivesPictureView.h"


@interface WMSpecialActivesPictureView ()
/// bg
@property (nonatomic, strong) UIImageView *bgImageView;
///提示文本
@property (nonatomic, strong) HDLabel *tipLB;
///时间文本
@property (nonatomic, strong) HDLabel *timeLB;
///遮罩层
@property (nonatomic, strong) UIImageView *bgShadomView;

@end


@implementation WMSpecialActivesPictureView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.tipLB];
    [self addSubview:self.timeLB];
    [self addSubview:self.bgShadomView];
    self.tipLB.hidden = self.timeLB.hidden = self.bgShadomView.hidden = YES;
    self.backgroundColor = HDAppTheme.WMColor.bg3;
}

- (void)updateConstraints {
    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.bgShadomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bgShadomView.isHidden) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(kRealWidth(50));
        }
    }];

    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.timeLB.isHidden) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(kNavigationBarH + kRealWidth(10));
        }
    }];

    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipLB.isHidden) {
            make.centerX.mas_equalTo(0);
            make.width.lessThanOrEqualTo(self).multipliedBy(0.9);
            if (!self.timeLB.isHidden) {
                make.top.equalTo(self.timeLB.mas_bottom).offset(kRealWidth(10));
            } else {
                make.centerY.mas_equalTo(0);
            }
        }
    }];

    [super updateConstraints];
}

- (void)setBuinessTime:(NSString *)buinessTime {
    _buinessTime = buinessTime;
    self.tipLB.hidden = self.timeLB.hidden = self.bgShadomView.hidden = NO;
    self.timeLB.text = [NSString stringWithFormat:@"%@ %@", WMLocalizedString(@"wm_every_day", @"每天"), buinessTime];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"backgroundImageUrl" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        CGSize imageSize;
        if ([self.viewModel.type isEqualToString:WMSpecialActiveTypeImage]) {
            imageSize = CGSizeMake(kScreenWidth, kScreenHeight - kNavigationBarH);
        } else {
            imageSize = CGSizeMake(kScreenWidth, kRealWidth(200));
        }

        if ([self.viewModel.backgroundImageUrl isKindOfClass:NSString.class] && self.viewModel.backgroundImageUrl.length) {
            [HDWebImageManager setImageWithURL:self.viewModel.backgroundImageUrl
                              placeholderImage:[HDHelper placeholderImageWithSize:imageSize logoWidth:imageSize.height * 0.5]
                                     imageView:self.bgImageView completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                         if (!error) {
                                             CGFloat height = kScreenWidth / (image.size.width / image.size.height);
                                             self.frame = CGRectMake(0, 0, kScreenWidth, height);

                                             if (self.viewModel.addBottomRadio)
                                                 self.radian = kRealWidth(15);

                                             if (self.frameBlock)
                                                 self.frameBlock(height);
                                         } else {
                                             self.frame = CGRectMake(0, 0, kScreenWidth, imageSize.height);
                                             if (self.frameBlock)
                                                 self.frameBlock(imageSize.height);
                                         }
                                     }];
        } else {
            if (self.frameBlock)
                self.frameBlock(0);
        }
    }];
}

- (void)setRadian:(CGFloat)radian {
    if (radian == 0)
        return;
    CGFloat t_width = CGRectGetWidth(self.frame);   // 宽
    CGFloat t_height = CGRectGetHeight(self.frame); // 高
    CGFloat height = fabs(radian);                  // 圆弧高度
    CGFloat x = 0;
    CGFloat y = 0;

    CGFloat _maxRadian = 0;
    switch (self.direction) {
        case WMRadianDirectionBottom:
        case WMRadianDirectionTop:
            _maxRadian = MIN(t_height, t_width / 2);
            break;
        case WMRadianDirectionLeft:
        case WMRadianDirectionRight:
            _maxRadian = MIN(t_height / 2, t_width);
            break;
        default:
            break;
    }
    if (height > _maxRadian) {
        NSLog(@"圆弧半径过大, 跳过设置。");
        return;
    }

    // 计算半径
    CGFloat radius = 0;
    switch (self.direction) {
        case WMRadianDirectionBottom:
        case WMRadianDirectionTop: {
            CGFloat c = sqrt(pow(t_width / 2, 2) + pow(height, 2));
            CGFloat sin_bc = height / c;
            radius = c / (sin_bc * 2);
        } break;
        case WMRadianDirectionLeft:
        case WMRadianDirectionRight: {
            CGFloat c = sqrt(pow(t_height / 2, 2) + pow(height, 2));
            CGFloat sin_bc = height / c;
            radius = c / (sin_bc * 2);
        } break;
        default:
            break;
    }

    /// 画圆
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor yellowColor] CGColor]];
    [shapeLayer setStrokeColor:UIColor.redColor.CGColor];
    [shapeLayer setBackgroundColor:UIColor.blueColor.CGColor];
    CGMutablePathRef path = CGPathCreateMutable();
    switch (self.direction) {
        case WMRadianDirectionBottom: {
            if (radian > 0) {
                CGPathMoveToPoint(path, NULL, t_width, t_height - height);
                CGPathAddArc(path, NULL, t_width / 2, t_height - radius, radius, asin((radius - height) / radius), M_PI - asin((radius - height) / radius), NO);
            } else {
                CGPathMoveToPoint(path, NULL, t_width, t_height);
                CGPathAddArc(path, NULL, t_width / 2, t_height + radius - height, radius, 2 * M_PI - asin((radius - height) / radius), M_PI + asin((radius - height) / radius), YES);
            }
            CGPathAddLineToPoint(path, NULL, x, y);
            CGPathAddLineToPoint(path, NULL, t_width, y);
        } break;
        case WMRadianDirectionTop: {
            if (radian > 0) {
                CGPathMoveToPoint(path, NULL, t_width, height);
                CGPathAddArc(path, NULL, t_width / 2, radius, radius, 2 * M_PI - asin((radius - height) / radius), M_PI + asin((radius - height) / radius), YES);
            } else {
                CGPathMoveToPoint(path, NULL, t_width, y);
                CGPathAddArc(path, NULL, t_width / 2, height - radius, radius, asin((radius - height) / radius), M_PI - asin((radius - height) / radius), NO);
            }
            CGPathAddLineToPoint(path, NULL, x, t_height);
            CGPathAddLineToPoint(path, NULL, t_width, t_height);
        } break;
        case WMRadianDirectionLeft: {
            if (radian > 0) {
                CGPathMoveToPoint(path, NULL, height, y);
                CGPathAddArc(path, NULL, radius, t_height / 2, radius, M_PI + asin((radius - height) / radius), M_PI - asin((radius - height) / radius), YES);
            } else {
                CGPathMoveToPoint(path, NULL, x, y);
                CGPathAddArc(path, NULL, height - radius, t_height / 2, radius, 2 * M_PI - asin((radius - height) / radius), asin((radius - height) / radius), NO);
            }
            CGPathAddLineToPoint(path, NULL, t_width, t_height);
            CGPathAddLineToPoint(path, NULL, t_width, y);
        } break;
        case WMRadianDirectionRight: {
            if (radian > 0) {
                CGPathMoveToPoint(path, NULL, t_width - height, y);
                CGPathAddArc(path, NULL, t_width - radius, t_height / 2, radius, 1.5 * M_PI + asin((radius - height) / radius), M_PI / 2 + asin((radius - height) / radius), NO);
            } else {
                CGPathMoveToPoint(path, NULL, t_width, y);
                CGPathAddArc(path, NULL, t_width + radius - height, t_height / 2, radius, M_PI + asin((radius - height) / radius), M_PI - asin((radius - height) / radius), YES);
            }
            CGPathAddLineToPoint(path, NULL, x, t_height);
            CGPathAddLineToPoint(path, NULL, x, y);
        } break;
        default:
            break;
    }

    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);
    self.layer.mask = shapeLayer;
}

#pragma mark - lazy load
/** @lazy bgImageView */
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.backgroundColor = HDAppTheme.WMColor.bg3;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bgImageView;
}

- (HDLabel *)timeLB {
    if (!_timeLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = UIColor.whiteColor;
        la.font = [HDAppTheme.WMFont wm_ForSize:14];
        la.textAlignment = NSTextAlignmentCenter;
        la.layer.backgroundColor = UIColor.clearColor.CGColor;
        la.layer.borderColor = UIColor.whiteColor.CGColor;
        la.layer.borderWidth = 1;
        la.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(5), kRealWidth(30), kRealWidth(5), kRealWidth(30));
        la.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
        };
        _timeLB = la;
    }
    return _timeLB;
}

- (HDLabel *)tipLB {
    if (!_tipLB) {
        HDLabel *la = HDLabel.new;
        la.textColor = UIColor.whiteColor;
        la.text = [NSString stringWithFormat:@"• %@\t• %@", WMLocalizedString(@"wm_exclusive_offer", @"专属定制"), WMLocalizedString(@"wm_lower_price", @"更低价格")];
        la.textAlignment = NSTextAlignmentCenter;
        la.font = [HDAppTheme.WMFont wm_ForSize:12];
        _tipLB = la;
    }
    return _tipLB;
}

- (UIImageView *)bgShadomView {
    if (!_bgShadomView) {
        _bgShadomView = UIImageView.new;
        _bgShadomView.image = [UIImage imageNamed:@"yn_special_bg"];
    }
    return _bgShadomView;
}

@end
