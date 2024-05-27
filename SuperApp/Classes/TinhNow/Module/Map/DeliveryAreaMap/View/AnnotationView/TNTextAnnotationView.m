//
//  TNTextAnnotationView.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNTextAnnotationView.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>
#import <Masonry/Masonry.h>


@interface TNTextAnnotationView ()
/// 大头针
@property (strong, nonatomic) HDLabel *textLabel;
@end


@implementation TNTextAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.textLabel];
    }
    return self;
}
- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    self.textLabel.text = annotation.title;
    //    CGSize size = [annotation.title boundingAllRectWithSize:CGSizeMake(kRealWidth(120), MAXFLOAT) font:self.textLabel.font lineSpacing:0];  这个方法  中文和数字一起 有偏差
    CGSize size = [self.textLabel sizeThatFits:CGSizeMake(kRealWidth(130), MAXFLOAT)];
    CGFloat width = size.width + 10;
    CGFloat height = size.height + 6;
    CGRect newBounds = CGRectMake(0, 0, width > kRealWidth(130) ? kRealWidth(130) : width, height);
    [self setBounds:newBounds];
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
/** @lazy textLabel */
- (HDLabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[HDLabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:10];
        _textLabel.hd_edgeInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        _textLabel.preferredMaxLayoutWidth = kRealWidth(122);
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:78 / 255.0 blue:0 / 255.0 alpha:1.0];
        _textLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
        };
    }
    return _textLabel;
}
@end
