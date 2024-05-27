//
//  HDCommonInfoRowView.m
//  customer
//
//  Created by VanJay on 2019/5/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCommonInfoRowView.h"
#import "HDAppTheme.h"
#import "HDDealCommonInfoRowViewModel.h"
#import "Masonry.h"
#import "UIMacro.h"
#import "UtilMacro.h"
#import "WJFrameLayout.h"


@interface HDCommonInfoRowView ()
@property (nonatomic, strong) UILabel *keyLB;          ///< 属性 Label
@property (nonatomic, strong) UILabel *valueLB;        ///< 属性值 Label
@property (nonatomic, strong) UIImageView *arrowImage; ///< 箭头
@end


@implementation HDCommonInfoRowView
+ (instancetype)commonInfoRowViewWithModel:(HDDealCommonInfoRowViewModel *)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(HDDealCommonInfoRowViewModel *)model {
    if (self = [super init]) {
        _model = model;

        [self commonInit];
    }
    return self;
}

#pragma mark - life cycle
- (void)commonInit {
    if (!_keyLB) {
        _keyLB = [[UILabel alloc] init];
        _keyLB.numberOfLines = 0;
        [self addSubview:_keyLB];
    }
    _keyLB.font = _model.keyFont;
    _keyLB.textColor = _model.keyColor;
    _keyLB.text = _model.key;
    _keyLB.textAlignment = _model.keyTextAlignment;

    if (!_valueLB) {
        _valueLB = [[UILabel alloc] init];
        _valueLB.numberOfLines = 0;
        [self addSubview:_valueLB];
    }
    _valueLB.font = _model.valueFont;
    _valueLB.textColor = _model.valueColor;
    _valueLB.text = _model.value;
    _valueLB.textAlignment = _model.valueTextAlignment;

    if (_model.needRightArrow && !_arrowImage) {
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_arrow"]];
        [self addSubview:_arrowImage];

        // 添加手势
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:recognizer];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - public methods
- (void)updateKeyText:(NSString *)keyText valueText:(NSString *)valueText {
    self.model.key = keyText;
    self.model.value = valueText;

    [self commonInit];

    [self setNeedsUpdateConstraints];
}

#pragma mark - getters and setters
- (void)setModel:(HDDealCommonInfoRowViewModel *)model {
    _model = model;

    [self commonInit];

    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)tappedView {
    if (_model.needRightArrow) {
        !self.tappedHandler ?: self.tappedHandler();
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [_keyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.model.contentInsets.left);
        make.top.greaterThanOrEqualTo(self).offset(self.model.contentInsets.top);
        make.centerY.equalTo(self);
        make.width.lessThanOrEqualTo(self).multipliedBy(0.4);
    }];

    [_valueLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self).offset(self.model.contentInsets.top);
        make.centerY.equalTo(self);
        if (self.arrowImage) {
            make.right.equalTo(self.arrowImage.mas_left).offset(-kRealWidth(10));
        } else {
            make.right.equalTo(self).offset(-self.model.contentInsets.right);
        }
        make.left.equalTo(self.keyLB.mas_right).offset(20);
    }];

    if (_arrowImage) {
        [_arrowImage sizeToFit];
        [_arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.arrowImage.size);
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-self.model.contentInsets.right);
        }];
    }
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
@end
