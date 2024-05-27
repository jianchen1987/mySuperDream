//
//  PayHDCheckstandTextField.m
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandTextField.h"
#import "HDKeyBoard.h"
#import "PNKeyBoard.h"
#import "PNMultiLanguageManager.h"
#import "UIColor+HDKitCore.h"

NS_ASSUME_NONNULL_BEGIN

static NSInteger const DEFAULT_COUNT_CHARACTERS = 6;
static CGFloat const DEFAULT_RADIUS = 6.f;
static CGFloat const DEFAULT_BODER_WIDTH = 1.f;
static CGFloat const DEFAULT_HORIZONTALLINE_WIDTH = 20.f;
static CGFloat const DEFAULT_CUSTOMIMAGE_WIDTH = 20.f;


@interface PayHDCheckstandTextField () <UIKeyInput, UITextInputTraits> {
    int completion_count;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray<CALayer *> *lines;
@property (nonatomic, strong) NSMutableArray<CALayer *> *boxs;
/**
 An array of layers holding secure placeholders.
 */
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *dots;
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *plaintexts;
@property (nonatomic, strong) NSMutableArray<CALayer *> *horizontalLines;
@property (nonatomic, strong) NSMutableArray<CALayer *> *customImages;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray *> *placeholderDic;

- (CAShapeLayer *)createSecurityDot;
- (CALayer *)createSeparaterLine;
- (CATextLayer *)createCharacter;
- (CALayer *)createCustomImage;
- (CALayer *)createHorizontalLine;

@end


@implementation PayHDCheckstandTextField

- (instancetype)initWithNumberOfCharacters:(NSInteger)numberOfCharacters
                     securityCharacterType:(PayHDCheckstandSecurityCharacterType)securityCharacterType
                                borderType:(PayHDCheckstandTextFieldBorderType)borderType {
    self = [self init];
    self.numberOfCharacters = numberOfCharacters;
    self.securityCharacterType = securityCharacterType;
    self.borderType = borderType;
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentView = ({
            UIView *contentView = [[UIView alloc] init];
            contentView.backgroundColor = UIColor.clearColor;
            contentView.userInteractionEnabled = NO;
            contentView;
        });
        [self addSubview:self.contentView];

        self.diameterOfDot = 8;
        self.colorOfCharacter = UIColor.blackColor;
        self.text = @"";
        self.placeholderDic = [NSMutableDictionary dictionary];
        self.lines = [NSMutableArray array];
        [self addTarget:self action:@selector(hangdleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame" context:NULL];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.contentView.frame = self.bounds;

    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat boxW = width / self.numberOfCharacters - 3;
    boxW = boxW > height ? height : boxW;
    CGFloat pieceWidth = width / self.numberOfCharacters;

    !self.placeholderDic[@(self.securityCharacterType)] ?:
                                                          [self.placeholderDic[@(self.securityCharacterType)] enumerateObjectsUsingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.position = CGPointMake(pieceWidth / 2.f + (pieceWidth * idx), height / 2.f);
        }];

    if (self.borderType != PayHDCheckstandTextFieldBorderTypeNoBorder) {
        [self.lines enumerateObjectsUsingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [self.contentView.layer addSublayer:obj];
            obj.frame = CGRectMake(pieceWidth * (idx + 1) - self.layer.borderWidth / 2.f, 0, self.layer.borderWidth, height);
        }];
    } else if (self.borderType == PayHDCheckstandTextFieldBorderTypeNoBorder) {
        [self.boxs enumerateObjectsUsingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [self.contentView.layer addSublayer:obj];
            obj.frame = CGRectMake(pieceWidth * idx + (pieceWidth - boxW) / 2, (height - boxW) / 2, boxW, boxW);
        }];
    }
}

#pragma mark - createPlaceholderCharacter

/**
 Create a black dot.

 @return dot
 */
- (CAShapeLayer *)createSecurityDot {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.bounds = CGRectMake(0, 0, self.diameterOfDot, self.diameterOfDot);
    layer.path = [UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:self.diameterOfDot / 2.f].CGPath;
    layer.opacity = 0;
    [self.contentView.layer addSublayer:layer];
    return layer;
}

- (CAShapeLayer *)createSecurityBox {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];

    layer.bounds = CGRectMake(0, 0, self.frame.size.height - 5, self.frame.size.height - 5);
    layer.borderWidth = 1.0;
    layer.borderColor = [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:1.0].CGColor;
    layer.cornerRadius = 5.0f;

    return layer;
}

/**
 Create a split line.

 @return line
 */
- (CALayer *)createSeparaterLine {
    CALayer *layer = [[CALayer alloc] init];
    layer.backgroundColor = self.tintColor.CGColor ?: self.layer.borderColor;
    return layer;
}

/**
 Create an unencrypted character.

 @return character
 */
- (CATextLayer *)createCharacter {
    CATextLayer *layer = [[CATextLayer alloc] init];
    layer.bounds = CGRectMake(0, 0, self.diameterOfDot * 3, self.diameterOfDot * 3);
    layer.foregroundColor = UIColor.blackColor.CGColor;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.wrapped = YES;
    layer.opacity = 0;
    [self.contentView.layer addSublayer:layer];
    return layer;
}

/**
 Customize a picture that represents security.

 @return layer
 */
- (CALayer *)createCustomImage {
    CALayer *layer = [[CALayer alloc] init];
    layer.opacity = 0;
    [self.contentView.layer addSublayer:layer];
    return layer;
}

- (CALayer *)createHorizontalLine {
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, DEFAULT_HORIZONTALLINE_WIDTH, 5);
    layer.backgroundColor = UIColor.blackColor.CGColor;
    layer.opacity = 0;
    [self.contentView.layer addSublayer:layer];
    return layer;
}

#pragma mark - set
- (void)setNumberOfCharacters:(NSInteger)numberOfCharacters {
    numberOfCharacters = (numberOfCharacters <= 0) ? DEFAULT_COUNT_CHARACTERS : numberOfCharacters;

    if (numberOfCharacters != _numberOfCharacters) {
        _numberOfCharacters = numberOfCharacters;

        [self.lines removeAllObjects];
        for (int i = 0; i < self.numberOfCharacters - 1; i++) {
            [self.lines addObject:[self createSeparaterLine]];
        }

        [self.boxs removeAllObjects];
        for (int i = 0; i < self.numberOfCharacters; i++) {
            [self.boxs addObject:[self createSecurityBox]];
        }
    }
}

- (void)setDiameterOfDot:(CGFloat)diameterOfDot {
    _diameterOfDot = diameterOfDot;
    if (self.placeholderDic[@(PayHDCheckstandSecurityCharacterTypeSecurityDot)]) {
        [self.dots enumerateObjectsUsingBlock:^(CAShapeLayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.bounds = CGRectMake(0, 0, diameterOfDot, diameterOfDot);
            obj.path = [UIBezierPath bezierPathWithRoundedRect:obj.bounds cornerRadius:diameterOfDot / 2.f].CGPath;
        }];
    }
}

- (void)setSecurityImage:(UIImage *)securityImage {
    _securityImage = securityImage;
    !self.placeholderDic[@(self.securityCharacterType)] ?:
                                                          [self.placeholderDic[@(self.securityCharacterType)] enumerateObjectsUsingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.contents = (id)securityImage.CGImage;
        }];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.layer.borderColor = tintColor.CGColor;

    for (CALayer *layer in self.lines) {
        layer.backgroundColor = tintColor.CGColor;
    }
}

- (void)setColorOfCharacter:(UIColor *)colorOfCharacter {
    _colorOfCharacter = colorOfCharacter;

    if (self.securityCharacterType == PayHDCheckstandSecurityCharacterTypeSecurityDot) {
        [self.placeholderDic[@(self.securityCharacterType)] enumerateObjectsUsingBlock:^(CAShapeLayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.strokeColor = colorOfCharacter.CGColor;
        }];
    } else if (self.securityCharacterType == PayHDCheckstandSecurityCharacterTypePlainText) {
        [self.placeholderDic[@(self.securityCharacterType)] enumerateObjectsUsingBlock:^(CATextLayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.foregroundColor = colorOfCharacter.CGColor;
        }];
    } else if (self.securityCharacterType == PayHDCheckstandSecurityCharacterTypeHorizontalLine) {
        [self.placeholderDic[@(self.securityCharacterType)] enumerateObjectsUsingBlock:^(CATextLayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.backgroundColor = colorOfCharacter.CGColor;
        }];
    }
}

- (void)setSecurityCharacterType:(PayHDCheckstandSecurityCharacterType)securityCharacterType {
    _securityCharacterType = securityCharacterType;

    if (!self.placeholderDic[@(securityCharacterType)]) {
        if (securityCharacterType == PayHDCheckstandSecurityCharacterTypeSecurityDot) {
            self.placeholderDic[@(securityCharacterType)] = self.dots;
        } else if (securityCharacterType == PayHDCheckstandSecurityCharacterTypePlainText) {
            self.placeholderDic[@(securityCharacterType)] = self.plaintexts;
        } else if (securityCharacterType == PayHDCheckstandSecurityCharacterTypeCustomImage) {
            self.placeholderDic[@(securityCharacterType)] = self.customImages;
        } else if (securityCharacterType == PayHDCheckstandSecurityCharacterTypeHorizontalLine) {
            self.placeholderDic[@(securityCharacterType)] = self.horizontalLines;
        }
    }
}

- (void)setBorderType:(PayHDCheckstandTextFieldBorderType)borderType {
    _borderType = borderType;

    switch (borderType) {
        case PayHDCheckstandTextFieldBorderTypeHaveRoundedCorner: {
            self.layer.borderColor = self.tintColor.CGColor;
            self.layer.borderWidth = DEFAULT_BODER_WIDTH;
            self.layer.cornerRadius = DEFAULT_RADIUS;
            break;
        }
        case PayHDCheckstandTextFieldBorderTypeNoRoundedCorner: {
            self.layer.borderColor = self.tintColor.CGColor;
            self.layer.borderWidth = DEFAULT_BODER_WIDTH;
            self.layer.cornerRadius = 0;
            break;
        }
        case PayHDCheckstandTextFieldBorderTypeNoBorder: {
            self.layer.borderWidth = 0;
            break;
        }
        default:
            break;
    }
}

#pragma mark - get

- (NSInteger)countOfVerification {
    return completion_count;
}

- (NSMutableArray<CAShapeLayer *> *)dots {
    if (!_dots) {
        _dots = [NSMutableArray array];
        for (int i = 0; i < self.numberOfCharacters; i++) {
            [_dots addObject:[self createSecurityDot]];
        }
    }
    return _dots;
}

- (NSMutableArray<CATextLayer *> *)plaintexts {
    if (!_plaintexts) {
        _plaintexts = [NSMutableArray array];
        for (int i = 0; i < self.numberOfCharacters; i++) {
            [_plaintexts addObject:[self createCharacter]];
        }
    }
    return _plaintexts;
}

- (NSMutableArray<CALayer *> *)horizontalLines {
    if (!_horizontalLines) {
        _horizontalLines = [NSMutableArray array];
        for (int i = 0; i < self.numberOfCharacters; i++) {
            [_horizontalLines addObject:[self createHorizontalLine]];
        }
    }
    return _horizontalLines;
}

- (NSMutableArray<CALayer *> *)customImages {
    if (!_customImages) {
        _customImages = [NSMutableArray array];
        for (int i = 0; i < self.numberOfCharacters; i++) {
            [_customImages addObject:[self createCustomImage]];
        }
    }
    return _customImages;
}

- (NSMutableArray<CALayer *> *)boxs {
    if (!_boxs) {
        _boxs = [NSMutableArray array];
    }
    return _boxs;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        if (self.securityCharacterType == PayHDCheckstandSecurityCharacterTypeSecurityDot || self.securityCharacterType == PayHDCheckstandSecurityCharacterTypeHorizontalLine) {
        } else if (self.securityCharacterType == PayHDCheckstandSecurityCharacterTypePlainText) {
            [self.placeholderDic[@(self.securityCharacterType)] enumerateObjectsUsingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame) / self.numberOfCharacters, CGRectGetHeight(self.frame));
            }];
        } else {
            [self.placeholderDic[@(self.securityCharacterType)] enumerateObjectsUsingBlock:^(CALayer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (self.securityImageSize.width == 0) {
                    obj.bounds = CGRectMake(0, 0, DEFAULT_CUSTOMIMAGE_WIDTH, DEFAULT_CUSTOMIMAGE_WIDTH);
                } else {
                    obj.bounds = CGRectMake(0, 0, self.securityImageSize.width, self.securityImageSize.height);
                }
            }];
        }
    }
}

#pragma mark - UITextInputTraits

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

- (BOOL)isSecureTextEntry {
    return YES;
}

- (UIView *__nullable)inputView {
    //    HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad isRandom:NO];
    //    kb.inputSource = self;
    //    return kb;
    HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
    theme.enterpriseText = SALocalizedString(@"keyboard_brand_title", @"WOWNOW 安全键盘");

    //    HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad theme:theme isRandom:false];
    //    kb.inputSource = self;

    PNKeyBoard *kb = [[PNKeyBoard alloc] initKeyboardWithType:HDKeyBoardTypeNumberPad theme:theme isRandom:YES];
    kb.backgroundColor = [UIColor whiteColor];
    kb.keyBoard.inputSource = self;
    return kb;
}

#pragma mark - UIKeyInput

- (BOOL)hasText {
    return self.text.length > 0;
}

- (void)insertText:(NSString *)text {
    if (self.text.length < self.numberOfCharacters) {
        NSInteger index = self.text.length;
        NSMutableArray<CALayer *> *placeholders = self.placeholderDic[@(self.securityCharacterType)];
        placeholders[index].opacity = 1;

        if (self.securityCharacterType == PayHDCheckstandSecurityCharacterTypePlainText) {
            CATextLayer *layer = (CATextLayer *)placeholders[index];
            layer.string = text;
        }

        self.text = [self.text stringByAppendingString:text];
        if (self.borderType == PayHDCheckstandTextFieldBorderTypeNoBorder) {
            [self hightBoxs];
        }

        if (index == self.numberOfCharacters - 1) {
            completion_count++;
            if (@protocol(PayHDCheckstandTextFieldDelegate) && [self.delegate respondsToSelector:@selector(checkStandTextFieldDidFinishedEditing:)]) {
                [self.delegate checkStandTextFieldDidFinishedEditing:self];
            }
            !self.completion ?: self.completion(self, self.text);
        } else {
            if (@protocol(PayHDCheckstandTextFieldDelegate) && [self.delegate respondsToSelector:@selector(checkStandTextFieldDidBeginEditing:)]) {
                [self.delegate checkStandTextFieldDidBeginEditing:self];
            }
        }

        [self setNeedsLayout];
    }
}

- (void)deleteBackward {
    if (self.text.length > 0) {
        self.text = [self.text substringWithRange:NSMakeRange(0, self.text.length - 1)];
        NSInteger index = self.text.length;
        NSMutableArray<CALayer *> *placeholders = self.placeholderDic[@(self.securityCharacterType)];
        placeholders[index].opacity = 0;

        if (self.borderType == PayHDCheckstandTextFieldBorderTypeNoBorder) {
            [self hightBoxs];
        }

        if (@protocol(PayHDCheckstandTextFieldDelegate) && [self.delegate respondsToSelector:@selector(checkStandTextFieldDidDelete:)]) {
            [self.delegate checkStandTextFieldDidDelete:self];
        }

        if (!self.text.length) {
            if (@protocol(PayHDCheckstandTextFieldDelegate) && [self.delegate respondsToSelector:@selector(checkStandTextFieldDidClear:)]) {
                [self.delegate checkStandTextFieldDidClear:self];
            }
        } else {
            if (@protocol(PayHDCheckstandTextFieldDelegate) && [self.delegate respondsToSelector:@selector(checkStandTextFieldDidBeginEditing:)]) {
                [self.delegate checkStandTextFieldDidBeginEditing:self];
            }
        }
    }
}

- (void)hightBoxs {
    for (int i = 0; i < self.boxs.count; i++) {
        CALayer *box = self.boxs[i];
        if (i == self.text.length) {
            box.borderColor = [UIColor hd_colorWithHexString:@"#F83460"].CGColor;
        } else {
            box.borderColor = [UIColor hd_colorWithHexString:@"#262626"].CGColor;
        }
    }
}

- (void)darkAllBoxs {
    for (int i = 0; i < self.boxs.count; i++) {
        CALayer *box = self.boxs[i];
        box.borderColor = [UIColor hd_colorWithHexString:@"#262626"].CGColor;
    }
}

#pragma mark - firstReponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)hangdleAction:(id)sender {
    [self becomeFirstResponder];
}

- (BOOL)becomeFirstResponder {
    [self hightBoxs];

    if (@protocol(PayHDCheckstandTextFieldDelegate) && [self.delegate respondsToSelector:@selector(checkStandTextFieldBecomeFirstResponder:)]) {
        [self.delegate checkStandTextFieldBecomeFirstResponder:self];
    }

    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self darkAllBoxs];
    if (@protocol(PayHDCheckstandTextFieldDelegate) && [self.delegate respondsToSelector:@selector(checkStandTextFieldResignFirstResponder:)]) {
        [self.delegate checkStandTextFieldResignFirstResponder:self];
    }
    return [super resignFirstResponder];
}

#pragma mark - public methods

- (void)clear {
    self.text = @"";
    [self.placeholderDic[@(self.securityCharacterType)] setValue:@0 forKeyPath:@"opacity"];

    if (@protocol(PayHDCheckstandTextFieldDelegate) && [self.delegate respondsToSelector:@selector(checkStandTextFieldDidClear:)]) {
        [self.delegate checkStandTextFieldDidClear:self];
    }
}

@end

NS_ASSUME_NONNULL_END
