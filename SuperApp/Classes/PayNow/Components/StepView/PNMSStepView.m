//
//  PNMSStepView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSStepView.h"
#import "PNMSStepItemView.h"
#import "UIView+HD_Extension.h"


@interface PNMSStepView ()
@property (nonatomic, strong) PNMSStepItemView *firstView;
@property (nonatomic, strong) PNMSStepItemView *secondView;
@property (nonatomic, strong) PNMSStepItemView *thirdView;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) CAShapeLayer *line1Layer;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) CAShapeLayer *line2Layer;

/// 总item个数
@property (nonatomic, assign) NSInteger itemCount;
/// 第一个距离的间距
@property (nonatomic, assign) CGFloat spaceLR;
/// item 间距
@property (nonatomic, assign) CGFloat itemSpace;
/// item 宽度
@property (nonatomic, assign) CGFloat itemWidth;

@end


@implementation PNMSStepView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.itemCount = 3;
        self.spaceLR = kRealWidth(15);
        self.itemSpace = kRealWidth(5);
        self.itemWidth = (kScreenWidth - (2 * self.spaceLR) - ((self.itemCount - 1) * self.itemSpace)) / self.itemCount;
    }
    return self;
}

- (void)hd_setupViews {
    [self addSubview:self.firstView];
    [self addSubview:self.secondView];
    [self addSubview:self.thirdView];
    [self addSubview:self.line1];
    [self addSubview:self.line2];
}

- (void)updateConstraints {
    [self.firstView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(self.spaceLR);
        make.width.equalTo(@(self.itemWidth));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(12));
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-12));
    }];

    [self.secondView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstView.mas_right).offset(self.itemSpace);
        make.top.mas_equalTo(self.firstView.mas_top);
        make.width.mas_equalTo(self.firstView.mas_width);
        make.height.mas_equalTo(self.firstView.mas_height);
    }];

    [self.thirdView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondView.mas_right).offset(self.itemSpace);
        make.top.mas_equalTo(self.firstView.mas_top);
        make.width.mas_equalTo(self.firstView.mas_width);
        make.height.mas_equalTo(self.firstView.mas_height);
    }];

    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kRealWidth(1)));
        make.left.mas_equalTo(self.firstView.mas_right).offset(kRealWidth(-24));
        make.right.mas_equalTo(self.secondView.mas_left).offset(kRealWidth(24));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(26));
    }];

    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(kRealWidth(1)));
        make.left.mas_equalTo(self.secondView.mas_right).offset(kRealWidth(-24));
        make.right.mas_equalTo(self.thirdView.mas_left).offset(kRealWidth(24));
        make.top.mas_equalTo(self.line1.mas_top);
    }];

    [super updateConstraints];
}

- (void)setModelList:(NSArray<PNMSStepItemModel *> *)listModel step:(NSInteger)step {
    NSAssert(listModel.count >= 3, @"数据不能少于3个");

    PNMSStepItemModel *firstModel = [listModel objectAtIndex:0];
    PNMSStepItemModel *secondModel = [listModel objectAtIndex:1];
    PNMSStepItemModel *thirdModel = [listModel objectAtIndex:2];

    self.firstView.model = firstModel;
    self.secondView.model = secondModel;
    self.thirdView.model = thirdModel;

    if (step == 0) {
        [self.line1Layer removeFromSuperlayer];
        [self.line1Layer setStrokeColor:HDAppTheme.PayNowColor.cD8DBE1.CGColor];
        [self.line1.layer addSublayer:self.line1Layer];
        [self.line2Layer removeFromSuperlayer];
        [self.line2Layer setStrokeColor:HDAppTheme.PayNowColor.cD8DBE1.CGColor];
        [self.line2.layer addSublayer:self.line2Layer];
    } else if (step == 1) {
        [self.line1Layer removeFromSuperlayer];
        [self.line1Layer setStrokeColor:HDAppTheme.PayNowColor.mainThemeColor.CGColor];
        [self.line1.layer addSublayer:self.line1Layer];
        [self.line2Layer removeFromSuperlayer];
        [self.line2Layer setStrokeColor:HDAppTheme.PayNowColor.cD8DBE1.CGColor];
        [self.line2.layer addSublayer:self.line2Layer];
    } else if (step == 2) {
        [self.line1Layer removeFromSuperlayer];
        [self.line1Layer setStrokeColor:HDAppTheme.PayNowColor.mainThemeColor.CGColor];
        [self.line1.layer addSublayer:self.line1Layer];
        [self.line2Layer removeFromSuperlayer];
        [self.line2Layer setStrokeColor:HDAppTheme.PayNowColor.mainThemeColor.CGColor];
        [self.line2.layer addSublayer:self.line2Layer];
    } else {
        [self.line1Layer removeFromSuperlayer];
        [self.line1Layer setStrokeColor:HDAppTheme.PayNowColor.cD8DBE1.CGColor];
        [self.line1.layer addSublayer:self.line1Layer];
        [self.line2Layer removeFromSuperlayer];
        [self.line2Layer setStrokeColor:HDAppTheme.PayNowColor.cD8DBE1.CGColor];
        [self.line2.layer addSublayer:self.line2Layer];
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (PNMSStepItemView *)firstView {
    return _firstView ?: ({ _firstView = [[PNMSStepItemView alloc] init]; });
}

- (PNMSStepItemView *)secondView {
    return _secondView ?: ({ _secondView = [[PNMSStepItemView alloc] init]; });
}

- (PNMSStepItemView *)thirdView {
    return _thirdView ?: ({ _thirdView = [[PNMSStepItemView alloc] init]; });
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        @HDWeakify(self);
        _line1.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            self.line1Layer = [self setShapeLayer:view color:[UIColor whiteColor]];
            [self.line1.layer addSublayer:self.line1Layer];
        };
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        @HDWeakify(self);
        _line2.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            self.line2Layer = [self setShapeLayer:view color:[UIColor whiteColor]];
            [self.line2.layer addSublayer:self.line2Layer];
        };
    }
    return _line2;
}

- (CAShapeLayer *)setShapeLayer:(UIView *)view color:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(view.frame) / 2, CGRectGetHeight(view.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];

    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];

    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(view.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];

    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:3], nil]];

    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(view.frame), 0);

    [shapeLayer setPath:path];
    CGPathRelease(path);

    //    shapeLayerArg = shapeLayer;
    return shapeLayer;
}

@end
