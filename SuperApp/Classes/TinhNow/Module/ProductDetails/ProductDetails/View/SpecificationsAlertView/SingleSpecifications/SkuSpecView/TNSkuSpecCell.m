//
//  TNSpecificationCollectionCell.m
//  SuperApp
//
//  Created by xixi on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSkuSpecCell.h"
#import "HDAppTheme+TinhNow.h"
#import "UIView+FrameChangedHandler.h"


@interface TNSkuSpecCell ()
///
@property (nonatomic, strong) HDLabel *titleLabel;
///
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end


@implementation TNSkuSpecCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [super updateConstraints];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    // 获取自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = size.width;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (void)setSpecNameStr:(NSString *)specNameStr {
    _specNameStr = specNameStr;

    self.titleLabel.text = specNameStr;
    [self setNeedsUpdateConstraints];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.cFF8824;
        self.titleLabel.layer.borderColor = HDAppTheme.TinhNowColor.cFF8824.CGColor;
    } else {
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        self.titleLabel.layer.borderColor = HDAppTheme.TinhNowColor.cADB6C8.CGColor;
    }
}

- (void)setHasStock:(BOOL)hasStock {
    _hasStock = hasStock;
    if (_hasStock) {
        self.shapeLayer.opaque = YES;
        self.titleLabel.layer.borderWidth = 1;
        if (self.isSelected) {
            self.titleLabel.textColor = HDAppTheme.TinhNowColor.cFF8824;
        } else {
            self.titleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        }
    } else {
        self.shapeLayer.opaque = NO;
        self.titleLabel.layer.borderWidth = 0;
        self.titleLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
    }
}

#pragma mark -
- (HDLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12.f];
        _titleLabel.hd_edgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
        _titleLabel.layer.cornerRadius = 4.f;
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        @HDWeakify(self);
        _titleLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:4.f];
            self.shapeLayer.path = path.CGPath;
            self.shapeLayer.frame = view.bounds;
            [view.layer addSublayer:self.shapeLayer];
        };
    }
    return _titleLabel;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.strokeColor = HDAppTheme.TinhNowColor.cADB6C8.CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;

        _shapeLayer.lineWidth = 1.f;
        _shapeLayer.lineDashPattern = @[@4, @2];
    }

    return _shapeLayer;
}

@end
