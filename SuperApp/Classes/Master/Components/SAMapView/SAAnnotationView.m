//
//  SAAnnotaionView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAnnotationView.h"
#import "SAAnnotation.h"
#import "SAView.h"


@interface SAAnnotationView ()
/// 图片
@property (nonatomic, strong) UIImageView *logoIV;
/// 提示
@property (nonatomic, strong) SALabel *tipLabel;
@end


@implementation SAAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.logoIV];
        [self addSubview:self.tipLabel];
    }
    return self;
}

- (void)updateConstraints {
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.logoIV.isHidden) {
            make.width.equalTo(self).offset(-2 * 5);
            make.height.equalTo(self.logoIV.mas_width);
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(5);
        }
    }];

    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tipLabel.isHidden) {
            make.left.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_top);
        }
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];

    SAAnnotation *ann = (SAAnnotation *)annotation;

    if (ann.type == SAAnnotationTypeCustom) {
        self.logoIV.hidden = YES;
    } else {
        self.logoIV.hidden = HDIsStringEmpty(ann.logoImageURL) && HDIsObjectNil(ann.logoImage);
    }

    if (!self.logoIV.isHidden) {
        if (HDIsStringNotEmpty(ann.logoImageURL)) {
            [HDWebImageManager setImageWithURL:ann.logoImageURL placeholderImage:HDHelper.circlePlaceholderImage imageView:self.logoIV];
        } else {
            self.logoIV.image = ann.logoImage;
        }

        self.logoIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        };
    }

    self.tipLabel.hidden = HDIsStringEmpty(ann.tipTitle);
    if (!self.tipLabel.isHidden) {
        self.tipLabel.text = ann.tipTitle;
        self.tipLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view.layer.sublayers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (![obj isKindOfClass:NSClassFromString(@"_UILabelContentLayer")]) {
                    [obj removeFromSuperlayer];
                }
            }];
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight radius:precedingFrame.size.height * 0.5 borderWidth:1 borderColor:HDAppTheme.color.C1];
        };
    }

    if (ann.type == SAAnnotationTypeMerchant) {
        self.image = [[UIImage imageNamed:@"annotaion_bg"] hd_imageWithTintColor:HDAppTheme.color.mainColor];
    } else if (ann.type == SAAnnotationTypeDeliveryMan) {
        self.image = [[UIImage imageNamed:@"annotaion_bg"] hd_imageWithTintColor:HDAppTheme.color.mainColor];
    } else if (ann.type == SAAnnotationTypeConsignee) {
        self.image = [[UIImage imageNamed:@"annotaion_bg"] hd_imageWithTintColor:HexColor(0xFB811B)];
    } else if (ann.type == SAAnnotationTypeCustom) {
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
    }
    return _logoIV;
}

- (SALabel *)tipLabel {
    if (!_tipLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:10];
        label.textColor = HDAppTheme.color.C1;
        label.numberOfLines = 1;
        label.backgroundColor = UIColor.whiteColor;
        label.hd_edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        _tipLabel = label;
    }
    return _tipLabel;
}
@end
