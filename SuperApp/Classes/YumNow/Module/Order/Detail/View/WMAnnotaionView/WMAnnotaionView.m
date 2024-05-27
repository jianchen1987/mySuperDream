//
//  WMAnnotaionView.m
//  SuperApp
//
//  Created by wmz on 2022/10/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMAnnotaionView.h"
#import "SAAnnotation.h"
#import "SAView.h"


@interface WMAnnotaionView ()
/// 图片
@property (nonatomic, strong) UIImageView *logoIV;
/// 提示
@property (nonatomic, strong) UIView *tipView;
/// 提示
@property (nonatomic, strong) UIImageView *tipBgIV;
/// 提示
@property (nonatomic, strong) UIImageView *rightIV;
/// 提示
@property (nonatomic, strong) SALabel *tipLabel;

@end


@implementation WMAnnotaionView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.logoIV];
        [self addSubview:self.tipView];
        [self.tipView addSubview:self.tipBgIV];
        [self.tipView addSubview:self.tipLabel];
        [self.tipView addSubview:self.rightIV];
    }
    return self;
}

- (void)updateConstraints {
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.logoIV.isHidden) {
            make.left.mas_equalTo(kRealWidth(9));
            make.top.mas_equalTo(kRealWidth(3));
            make.right.mas_equalTo(-kRealWidth(9));
            make.bottom.mas_equalTo(-kRealWidth(15));
            make.width.height.mas_lessThanOrEqualTo(kRealWidth(32));
        }
    }];

    [self.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipView.isHidden) {
            make.bottom.equalTo(self.mas_top).offset(-kRealWidth(8));
            make.centerX.equalTo(self);
        }
    }];

    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipView.isHidden) {
            make.left.top.mas_equalTo(0).priorityHigh();
            make.bottom.mas_equalTo(-kRealWidth(6)).priorityHigh();
            make.right.mas_equalTo(0);
            make.width.mas_lessThanOrEqualTo(kRealWidth(120));
        }
    }];

    [self.tipBgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipView.isHidden) {
            make.edges.mas_equalTo(0);
        }
    }];

    [self.rightIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rightIV.isHidden) {
            make.size.mas_equalTo(CGSizeMake(kRealWidth(16), kRealWidth(16)));
            make.right.mas_equalTo(-kRealWidth(12));
            make.centerY.equalTo(self.tipLabel);
        }
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];

    WMAnnotation *ann = (WMAnnotation *)annotation;

    if (ann.type == SAAnnotationTypeMerchant) {
        self.logoIV.hidden = NO;
    } else {
        self.logoIV.hidden = YES;
    }

    if (!self.logoIV.isHidden) {
        if (HDIsStringNotEmpty(ann.logoImageURL)) {
            [HDWebImageManager setImageWithURL:ann.logoImageURL placeholderImage:HDHelper.circlePlaceholderImage imageView:self.logoIV];
        } else {
            self.logoIV.image = ann.logoImage;
        }
    }
    self.tipView.hidden = HDIsStringEmpty(ann.tipTitle);
    if (!self.tipView.isHidden) {
        self.tipLabel.text = ann.tipTitle;
        NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.tipLabel.text];
        mstr.yy_lineSpacing = kRealWidth(4);
        mstr.yy_alignment = NSTextAlignmentCenter;
        self.tipLabel.attributedText = mstr;
    }

    if (ann.type == SAAnnotationTypeMerchant) {
        UIImage *image = [UIImage imageNamed:@"yn_order_detail_map_bg"];
        self.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.3, image.size.width * 0.7, image.size.height * 0.3, image.size.width * 0.2)
                                           resizingMode:UIImageResizingModeStretch];
    } else {
        self.image = ann.logoImage;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)logoIV {
    if (!_logoIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.hidden = true;
        _logoIV = imageView;
        _logoIV.layer.cornerRadius = kRealWidth(4);
        _logoIV.clipsToBounds = YES;
    }
    return _logoIV;
}

- (SALabel *)tipLabel {
    if (!_tipLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:12 weight:UIFontWeightMedium];
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 2;
        label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(8), kRealWidth(8), kRealWidth(8));
        label.textAlignment = NSTextAlignmentCenter;
        _tipLabel = label;
    }
    return _tipLabel;
}

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = UIView.new;
    }
    return _tipView;
}

- (UIImageView *)tipBgIV {
    if (!_tipBgIV) {
        UIImage *image = [UIImage imageNamed:@"yn_order_detail_map_textbg"];
        _tipBgIV = UIImageView.new;
        _tipBgIV.image = image;
        _tipBgIV.contentMode = UIViewContentModeScaleAspectFill;
        _tipBgIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.shadowColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:0.2500].CGColor;
            view.layer.shadowOffset = CGSizeMake(0, 13);
            view.layer.shadowOpacity = 1;
            view.layer.shadowRadius = 14;
        };
    }
    return _tipBgIV;
}

- (UIImageView *)rightIV {
    if (!_rightIV) {
        _rightIV = UIImageView.new;
        _rightIV.image = [UIImage imageNamed:@"yn_submit_gengd"];
        _rightIV.hidden = YES;
    }
    return _rightIV;
}
@end


@implementation WMAnnotation

@end
