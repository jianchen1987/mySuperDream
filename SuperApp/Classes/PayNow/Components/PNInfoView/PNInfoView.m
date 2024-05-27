//
//  PNInfoView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/10/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInfoView.h"
#import <HDKitCore/HDFrameLayout.h>
#import <HDUIKit/HDUIButton.h>


@interface PNInfoView ()
/// 背景图
@property (nonatomic, strong) UIImageView *backgroundImageView;
/// 左图
@property (nonatomic, strong) UIImageView *leftImageView;
/// keyButton
@property (nonatomic, strong) HDUIButton *keyButton;
/// 最右按钮
@property (nonatomic, strong) HDUIButton *rightButton;
/// valueButton
@property (nonatomic, strong) HDUIButton *valueButton;
/// 底部提示文案【在左边 keyButton的底部 】
@property (nonatomic, strong) UILabel *bottomTipsLabel;
/// 线条
@property (nonatomic, strong) UIView *bottomLine;
/// 点击手势，添加在 cell 中禁用解决手势冲突
@property (nonatomic, strong) UITapGestureRecognizer *tapRecoginzer;
/// 是否已经提交需要更新布局命令
@property (nonatomic, assign) BOOL hasSubmitNeedUpdateConstraints;
@end


@implementation PNInfoView

+ (instancetype)infoViewWithModel:(PNInfoViewModel *)model {
    PNInfoView *view = [PNInfoView new];
    view.model = model;
    return view;
}

#pragma mark - life cycle
- (void)commonInit {
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.leftImageView];
    [self addSubview:self.keyButton];
    [self addSubview:self.valueButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.bottomLine];
    [self addSubview:self.bottomTipsLabel];
    // 添加点击事件监听
    [self addGestureRecognizer:self.tapRecoginzer];

    @HDWeakify(self);
    self.leftImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.model.needLeftImageRounded) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        }
    };
    self.valueButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (self.model.needValueImageRounded) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        }
    };
    self.backgroundImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        if (!self.backgroundImageView.isHidden && self.model.cornerRadius > 0) {
            [view setRoundedCorners:self.model.rectCorner radius:self.model.cornerRadius];
        }
    };
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

#pragma mark - event response
- (void)clickedLeftImageHandler {
    !self.model.clickedLeftImageHandler ?: self.model.clickedLeftImageHandler();
}

- (void)clickedView {
    !self.model.eventHandler ?: self.model.eventHandler();
}

- (void)clickOnKeyButtonHandler {
    !self.model.clickedKeyButtonHandler ?: self.model.clickedKeyButtonHandler();
}

- (void)clickOnValueButtonHandler {
    !self.model.clickedValueButtonHandler ?: self.model.clickedValueButtonHandler();
}

- (void)clickOnRightButtonHandler {
    !self.model.clickedRightButtonHandler ?: self.model.clickedRightButtonHandler();
}

#pragma mark - public methods
- (void)showRightButton:(BOOL)isShow {
    self.rightButton.hidden = !isShow;
    [self adjustSetNeedsUpdateConstraints];
}

- (void)setNeedsUpdateContent {
    [self setProperties];
    [self adjustSetNeedsUpdateConstraints];
}

#pragma mark - getters and setters
- (void)setModel:(PNInfoViewModel *)model {
    _model = model;

    [self setProperties];
    [self adjustSetNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)adjustSetNeedsUpdateConstraints {
    if (!self.hasSubmitNeedUpdateConstraints) {
        [self setNeedsUpdateConstraints];
        self.hasSubmitNeedUpdateConstraints = true;
    }
}

- (void)setProperties {
    self.backgroundImageView.hidden = !self.model.backgroundImage;
    if (self.model.backgroundImage) {
        self.backgroundImageView.image = self.model.backgroundImage;
        self.backgroundColor = UIColor.clearColor;
    } else {
        self.backgroundColor = self.model.backgroundColor;
    }
    self.layer.cornerRadius = self.model.cornerRadius;

    self.leftImageView.hidden = !self.model.leftImage && HDIsStringEmpty(self.model.leftImageURL);

    if (!self.leftImageView.isHidden) {
        if (self.model.leftImage) {
            self.leftImageView.image = self.model.leftImage;
        } else if (HDIsStringNotEmpty(self.model.leftImageURL)) {
            [HDWebImageManager setImageWithURL:self.model.leftImageURL
                              placeholderImage:self.model.leftPlaceholderImage ? self.model.leftPlaceholderImage : [HDHelper placeholderImageWithSize:CGSizeMake(18, 18)]
                                     imageView:self.leftImageView];
        }
    }

    self.keyButton.hidden = HDIsObjectNil(self.model.attrKey) && HDIsStringEmpty(self.model.keyText) && !self.model.keyImage;
    if (!self.keyButton.isHidden) {
        self.keyButton.titleLabel.font = self.model.keyFont;
        self.keyButton.enabled = self.model.clickedKeyButtonHandler != nil;
        self.keyButton.titleLabel.textAlignment = self.model.keyTextAlignment;
        if (self.model.alignType == PNInfoViewAlignTypeHorizontal) {
            self.keyButton.contentEdgeInsets = self.model.keyContentEdgeInsets;
            self.keyButton.titleEdgeInsets = self.model.keyTitletEdgeInsets;
        }
        self.keyButton.titleLabel.numberOfLines = self.model.keyNumbersOfLines;

        if (!HDIsObjectNil(self.model.attrKey)) {
            [self.keyButton setAttributedTitle:self.model.attrKey forState:UIControlStateNormal];
        } else {
            [self.keyButton setAttributedTitle:nil forState:UIControlStateNormal];
            [self.keyButton setTitleColor:self.model.keyColor forState:UIControlStateNormal];
            [self.keyButton setTitle:self.model.keyText forState:UIControlStateNormal];
        }

        if (self.model.keyImage) {
            [self.keyButton setImage:self.model.keyImage forState:UIControlStateNormal];
            self.keyButton.imagePosition = self.model.keyImagePosition;
            self.keyButton.imageEdgeInsets = self.model.keyImageEdgeInsets;
        } else {
            [self.keyButton setImage:nil forState:UIControlStateNormal];
        }
    }

    self.valueButton.hidden = HDIsStringEmpty(self.model.attrValue) && HDIsStringEmpty(self.model.valueText) && !self.model.valueImage && !self.model.valueImagePlaceholderImage;
    if (!self.valueButton.isHidden) {
        self.valueButton.titleLabel.font = self.model.valueFont;
        self.valueButton.enabled = self.model.clickedValueButtonHandler != nil;
        self.valueButton.titleLabel.textAlignment = self.model.valueTextAlignment;
        if (self.model.alignType == PNInfoViewAlignTypeHorizontal) {
            self.valueButton.contentEdgeInsets = self.model.valueContentEdgeInsets;
            self.valueButton.titleEdgeInsets = self.model.valueTitleEdgeInsets;
        }
        self.valueButton.titleLabel.numberOfLines = self.model.valueNumbersOfLines;
        if (!HDIsObjectNil(self.model.attrValue)) {
            [self.valueButton setAttributedTitle:self.model.attrValue forState:UIControlStateNormal];
        } else {
            [self.valueButton setAttributedTitle:nil forState:UIControlStateNormal];
            [self.valueButton setTitleColor:self.model.valueColor forState:UIControlStateNormal];
            [self.valueButton setTitle:self.model.valueText forState:UIControlStateNormal];
        }

        if (self.model.valueImage) {
            [self.valueButton setImage:self.model.valueImage forState:UIControlStateNormal];
            self.valueButton.imagePosition = self.model.valueImagePosition;
            self.valueButton.imageEdgeInsets = self.model.valueImageEdgeInsets;
        } else if (self.model.valueImagePlaceholderImage) {
            [self.valueButton sd_setImageWithURL:[NSURL URLWithString:self.model.valueImageURL] forState:UIControlStateNormal placeholderImage:self.model.valueImagePlaceholderImage];
        }
        if (!self.model.valueImage && self.valueButton.currentImage != nil && self.model.resetValueImage) {
            [self.valueButton setImage:nil forState:UIControlStateNormal];
        }
    }

    self.rightButton.hidden = HDIsStringEmpty(self.model.rightButtonTitle) && !self.model.rightButtonImage;
    if (!self.rightButton.isHidden) {
        self.rightButton.titleLabel.font = self.model.rightButtonFont;
        self.rightButton.enabled = self.model.clickedRightButtonHandler != nil;
        self.rightButton.titleLabel.textAlignment = self.model.rightButtonTextAlignment;
        self.rightButton.contentEdgeInsets = self.model.rightButtonContentEdgeInsets;
        [self.rightButton setTitleColor:self.model.rightButtonColor forState:UIControlStateNormal];
        [self.rightButton setTitle:self.model.rightButtonTitle forState:UIControlStateNormal];
        self.rightButton.titleEdgeInsets = self.model.rightButtonTitletEdgeInsets;
        if (self.model.rightButtonImage) {
            [self.rightButton setImage:self.model.rightButtonImage forState:UIControlStateNormal];
            self.rightButton.imagePosition = self.model.rightButtonImagePosition;
            self.rightButton.imageEdgeInsets = self.model.rightButtonImageEdgeInsets;
        }
    }

    if (self.model.alignType == PNInfoViewAlignTypeHorizontal && HDIsStringNotEmpty(self.model.bottomTipsText) && !self.keyButton.isHidden) {
        self.bottomTipsLabel.hidden = NO;
        self.bottomTipsLabel.text = self.model.bottomTipsText;
        self.bottomTipsLabel.font = self.model.bottomTipsFont;
        self.bottomTipsLabel.textColor = self.model.bottomTipsColor;
    } else {
        self.bottomTipsLabel.hidden = YES;
    }

    _tapRecoginzer.enabled = _model.enableTapRecognizer;

    _bottomLine.hidden = _model.lineWidth <= 0;
    if (!self.bottomLine.isHidden) {
        _bottomLine.backgroundColor = _model.lineColor;
    }

    self.valueButton.layer.backgroundColor = _model.valueBackGroundColor.CGColor;
    self.valueButton.layer.cornerRadius = _model.valueCornerRadio;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.backgroundImageView.isHidden) {
            make.edges.equalTo(self);
        }
    }];

    CGSize leftImageSize = HDIsStringEmpty(self.model.leftImageURL) ? self.leftImageView.image.size : self.model.leftImageSize;
    BOOL existLeftImage = !self.leftImageView.isHidden;
    [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (existLeftImage) {
            make.size.mas_equalTo(leftImageSize);
            make.left.equalTo(self).offset(self.model.leftImageViewEdgeInsets.left + self.model.contentEdgeInsets.left);
            make.centerY.equalTo(self);
        }
    }];

    BOOL existRightButton = !self.rightButton.isHidden;
    [self.rightButton sizeToFit];
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (existRightButton) {
            make.size.mas_equalTo(self.rightButton.bounds.size);
            make.right.equalTo(self).offset(-(self.model.rightButtonContentEdgeInsets.right + self.model.contentEdgeInsets.right));
            if (self.model.rightButtonaAlignKey) {
                make.centerY.equalTo(self.keyButton);
            } else {
                if (self.bottomTipsLabel.hidden) {
                    make.centerY.equalTo(self);
                } else {
                    make.centerY.equalTo(self.keyButton);
                }
            }
        }
    }];

    // value 不能超过指定比例，估算，忽略了间距和标题，事实上按钮应该超过一半
    CGSize valueButtonSize = CGSizeZero;
    if (self.model.alignType == PNInfoViewAlignTypeVertical) {
        CGFloat maxTitleWidth = kScreenWidth - UIEdgeInsetsGetHorizontalValue(self.model.contentEdgeInsets);
        if (existLeftImage) {
            maxTitleWidth -= self.model.leftImageViewEdgeInsets.left;
        }
        if (existRightButton) {
            maxTitleWidth -= CGRectGetWidth(self.rightButton.frame);
        }
        valueButtonSize = [self.valueButton sizeThatFits:CGSizeMake(maxTitleWidth, MAXFLOAT)];
    } else {
        valueButtonSize = [self.valueButton sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];

        CGFloat valueSpecifiedWidth = kScreenWidth / (CGFloat)((1 + self.model.keyToValueWidthRate)) * 1;
        BOOL isValueWidthOverHalfScreen = valueButtonSize.width > valueSpecifiedWidth;
        if (isValueWidthOverHalfScreen) {
            valueButtonSize = [self.valueButton sizeThatFits:CGSizeMake(valueSpecifiedWidth, MAXFLOAT)];
        }
    }

    if (self.model.valueImagePlaceholderImage) {
        valueButtonSize = self.model.valueImageSize;
    }

    [self.valueButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.valueButton.isHidden) {
            if (self.model.alignType == PNInfoViewAlignTypeVertical) {
                if (self.keyButton.isHidden) {
                    make.top.equalTo(self).offset(self.model.contentEdgeInsets.top + self.model.valueContentEdgeInsets.top);
                } else {
                    make.top.equalTo(self.keyButton.mas_bottom).offset(self.model.keyContentEdgeInsets.bottom + self.model.valueContentEdgeInsets.top);
                }
                make.left.equalTo(self).offset((self.leftImageView.isHidden ? 0 : self.model.leftImageViewEdgeInsets.left) + self.model.contentEdgeInsets.left);
                make.size.mas_equalTo(valueButtonSize);
                make.bottom.equalTo(self).offset(-(self.model.contentEdgeInsets.bottom + self.model.valueContentEdgeInsets.bottom));
            } else {
                // 处理 value 相对于其他控件的位置处理
                if (self.model.valueAlignmentToOther == NSTextAlignmentRight) {
                    if (existRightButton) {
                        make.right.equalTo(self.rightButton.mas_left).offset(-self.model.rightButtonContentEdgeInsets.left);
                    } else {
                        make.right.equalTo(self).offset(-self.model.contentEdgeInsets.right);
                    }
                } else {
                    if (!self.keyButton.isHidden) {
                        make.left.equalTo(self.keyButton.mas_right);
                    } else if (existLeftImage) {
                        make.left.equalTo(self.leftImageView.mas_right);
                    } else {
                        make.left.equalTo(self).offset(self.model.contentEdgeInsets.left);
                    }
                }
                make.size.mas_equalTo(valueButtonSize);
                make.top.greaterThanOrEqualTo(self).offset(self.model.contentEdgeInsets.top);
                if (self.model.needFixedBottom) {
                    make.bottom.equalTo(self).offset(-self.model.contentEdgeInsets.bottom);
                } else {
                    if (self.bottomTipsLabel.hidden) {
                        make.bottom.lessThanOrEqualTo(self).offset(-self.model.contentEdgeInsets.bottom);
                    } else {
                        make.bottom.mas_equalTo(self.bottomTipsLabel.mas_top).offset(-kRealWidth(10));
                    }
                }
            }
        }
    }];

    // 计算剩余宽度
    CGFloat maxKeyButtonWidth = kScreenWidth - UIEdgeInsetsGetHorizontalValue(self.model.contentEdgeInsets);
    if (self.model.alignType == PNInfoViewAlignTypeVertical) {
        if (existLeftImage) {
            maxKeyButtonWidth -= self.model.leftImageViewEdgeInsets.left;
        }
        if (existRightButton) {
            maxKeyButtonWidth -= self.rightButton.width;
        }
    } else {
        if (!self.valueButton.isHidden) {
            maxKeyButtonWidth -= valueButtonSize.width;
        }
        if (existLeftImage) {
            maxKeyButtonWidth -= (leftImageSize.width + UIEdgeInsetsGetHorizontalValue(self.model.leftImageViewEdgeInsets));
        }
        if (existRightButton) {
            maxKeyButtonWidth -= CGRectGetWidth(self.rightButton.frame);
        }
    }

    //如果有指定宽度 按钮为指定宽度
    if (self.model.keyWidth > 0) {
        maxKeyButtonWidth = self.model.keyWidth;
        self.keyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }

    [self.keyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.keyButton.isHidden) {
            CGSize keyButtonSize = [self.keyButton sizeThatFits:CGSizeMake(maxKeyButtonWidth, MAXFLOAT)];
            if (self.model.keyWidth > 0) {
                keyButtonSize.width = self.model.keyWidth;
            }
            if (self.model.alignType == PNInfoViewAlignTypeVertical) {
                make.size.mas_equalTo(keyButtonSize);
                make.top.equalTo(self).offset(self.model.contentEdgeInsets.top + self.model.keyContentEdgeInsets.top);
                make.left.equalTo(self).offset((self.leftImageView.isHidden ? 0 : self.model.leftImageViewEdgeInsets.left) + self.model.contentEdgeInsets.left);
                if (self.valueButton.isHidden) {
                    make.bottom.equalTo(self).offset(-(self.model.contentEdgeInsets.bottom + self.model.keyContentEdgeInsets.bottom));
                }
            } else {
                make.size.mas_equalTo(keyButtonSize);
                if (self.leftImageView.isHidden) {
                    make.left.equalTo(self).offset(self.model.contentEdgeInsets.left);
                } else {
                    make.left.equalTo(self.leftImageView.mas_right).offset(self.model.leftImageViewEdgeInsets.right);
                }
                if (self.model.contentEdgeInsets.top != self.model.contentEdgeInsets.bottom) {
                    make.top.greaterThanOrEqualTo(self).offset(self.model.contentEdgeInsets.top);
                    make.bottom.lessThanOrEqualTo(self).offset(-self.model.contentEdgeInsets.bottom);
                } else {
                    if (self.valueButton.isHidden) {
                        make.top.greaterThanOrEqualTo(self).offset(self.model.contentEdgeInsets.top);
                        make.bottom.lessThanOrEqualTo(self).offset(-self.model.contentEdgeInsets.bottom);
                    } else {
                        if (self.bottomTipsLabel.hidden) {
                            make.centerY.equalTo(self);
                        } else {
                            make.top.greaterThanOrEqualTo(self).offset(self.model.contentEdgeInsets.top);
                        }
                    }
                }
            }
        }
    }];

    [self.bottomTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomTipsLabel.hidden) {
            make.left.equalTo(self).offset(self.model.contentEdgeInsets.left);
            make.right.equalTo(self).offset(-self.model.contentEdgeInsets.right);
            make.top.equalTo(self.keyButton.mas_bottom).offset(kRealWidth(10));
            if (self.model.needFixedBottom) {
                make.bottom.equalTo(self).offset(-self.model.contentEdgeInsets.bottom);
            } else {
                make.bottom.lessThanOrEqualTo(self).offset(-self.model.contentEdgeInsets.bottom);
            }
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.height.mas_equalTo(self.model.lineWidth);
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(self.model.lineEdgeInsets.left);
            make.right.equalTo(self).offset(-self.model.lineEdgeInsets.right);
        }
    }];

    [super updateConstraints];

    self.hasSubmitNeedUpdateConstraints = false;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - lazy load
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = UIImageView.new;
        _backgroundImageView.hidden = true;
    }
    return _backgroundImageView;
}

- (HDUIButton *)keyButton {
    if (!_keyButton) {
        _keyButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _keyButton.adjustsButtonWhenDisabled = false;
        _keyButton.adjustsButtonWhenHighlighted = false;
        [_keyButton addTarget:self action:@selector(clickOnKeyButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keyButton;
}

- (HDUIButton *)valueButton {
    if (!_valueButton) {
        _valueButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _valueButton.adjustsButtonWhenDisabled = false;
        _valueButton.adjustsButtonWhenHighlighted = false;
        [_valueButton addTarget:self action:@selector(clickOnValueButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _valueButton;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = UIImageView.new;
        _leftImageView.userInteractionEnabled = true;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedLeftImageHandler)];
        [_leftImageView addGestureRecognizer:recognizer];
    }
    return _leftImageView;
}

- (HDUIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.adjustsButtonWhenDisabled = false;
        _rightButton.adjustsButtonWhenHighlighted = false;
        [_rightButton addTarget:self action:@selector(clickOnRightButtonHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)bottomTipsLabel {
    if (!_bottomTipsLabel) {
        _bottomTipsLabel = [[UILabel alloc] init];
        _bottomTipsLabel.numberOfLines = 0;
    }
    return _bottomTipsLabel;
}

- (UIView *)bottomLine {
    return _bottomLine ?: ({ _bottomLine = UIView.new; });
}

- (UITapGestureRecognizer *)tapRecoginzer {
    if (!_tapRecoginzer) {
        _tapRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedView)];
    }
    return _tapRecoginzer;
}

@end
