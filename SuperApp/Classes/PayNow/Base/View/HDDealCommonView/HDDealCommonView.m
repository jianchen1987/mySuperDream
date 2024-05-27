//
//  HDDealCommonView.m
//  customer
//
//  Created by VanJay on 2019/5/2.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDDealCommonView.h"
#import "HDAppTheme.h"
#import "HDCommonInfoRowView.h"
#import "Masonry.h"
#import "UIMacro.h"
#import "UtilMacro.h"
#import "WJFrameLayout.h"


@implementation HDDealCommonViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置默认值
        _titleFont = [HDAppTheme HDFontStandard3Bold];
        _titleColor = [HDAppTheme HDColorG2];
        _subTitleFont = [HDAppTheme HDFontStandard3];
        _subTitleColor = [HDAppTheme HDColorG2];
        _descFont = [HDAppTheme HDFontAmountOnly];
        _descColor = [HDAppTheme HDColorG1];
        _needDividingLine = YES;
        _dividingLineIndex = 0;
        _dividingLineHMargin = kRealWidth(17);
        _dividingLineColor = [HDAppTheme HDColorG4];
        _dividingLineWidth = 0.5;
        _remarkTextFont = [HDAppTheme HDFontStandard3];
        _remarkTextColor = [HDAppTheme HDColorG3];
        _remarkTextAlignment = NSTextAlignmentLeft;
    }
    return self;
}
@end


@interface HDDealCommonView ()
@property (nonatomic, strong) UIView *containerView;                               ///< 容器，用于设置背景和圆角
@property (nonatomic, strong) UIImageView *imageV;                                 ///< 图片
@property (nonatomic, strong) UILabel *titleLB;                                    ///< 标题
@property (nonatomic, strong) UILabel *subTitleLB;                                 ///< 子标题
@property (nonatomic, strong) UILabel *descLB;                                     ///< 描述
@property (nonatomic, strong) UIView *lineView;                                    ///< 线条
@property (nonatomic, strong) UILabel *remarkLB;                                   ///< 备注
@property (nonatomic, strong) NSMutableArray<HDCommonInfoRowView *> *infoRowViews; ///< 存放所有的信息展示 View
@end


@implementation HDDealCommonView

+ (instancetype)dealCommonViewWithModel:(HDDealCommonViewModel *)model {
    return [[self alloc] initWithModel:model];
}

- (instancetype)initWithModel:(HDDealCommonViewModel *)model {
    if (self = [super init]) {
        _model = model;

        [self commonInit];
    }
    return self;
}

#pragma mark - life cycle
- (void)commonInit {
    self.backgroundColor = UIColor.clearColor;

    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_containerView];
    }

    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        [_containerView addSubview:_imageV];
    }
    _imageV.image = [UIImage imageNamed:_model.imageName];

    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.numberOfLines = 0;
        [_containerView addSubview:_titleLB];
    }
    _titleLB.font = _model.titleFont;
    _titleLB.textColor = _model.titleColor;
    _titleLB.text = _model.title;
    _titleLB.textAlignment = NSTextAlignmentCenter;

    if (WJIsStringNotEmpty(_model.subTitle)) {
        if (!_subTitleLB) {
            _subTitleLB = [[UILabel alloc] init];
            _subTitleLB.numberOfLines = 0;
            [_containerView addSubview:_subTitleLB];
        }
        _subTitleLB.font = _model.subTitleFont;
        _subTitleLB.textColor = _model.subTitleColor;
        _subTitleLB.text = _model.subTitle;
        _subTitleLB.textAlignment = NSTextAlignmentCenter;
    }

    if (!_descLB) {
        _descLB = [[UILabel alloc] init];
        _descLB.numberOfLines = 0;
        [_containerView addSubview:_descLB];
    }
    _descLB.font = _model.descFont;
    _descLB.textColor = _model.descColor;
    _descLB.text = _model.desc;
    _descLB.textAlignment = NSTextAlignmentCenter;

    if (_model.needDividingLine) {
        if (!_lineView) {
            _lineView = [[UIView alloc] init];
            [_containerView addSubview:_lineView];
        }
        _lineView.backgroundColor = _model.dividingLineColor;
    }

    if (WJIsStringNotEmpty(_model.remarkText)) {
        if (!_remarkLB) {
            _remarkLB = [[UILabel alloc] init];
            _remarkLB.numberOfLines = 0;
            [self addSubview:_remarkLB];
        }
        _remarkLB.font = _model.remarkTextFont;
        _remarkLB.textColor = _model.remarkTextColor;
        _remarkLB.text = _model.remarkText;
        _remarkLB.textAlignment = _model.remarkTextAlignment;
    }

    [self.infoRowViews removeAllObjects];

    for (HDDealCommonInfoRowViewModel *model in _model.list) {
        // 无值隐藏
        if (WJIsStringNotEmpty(model.value)) {
            HDCommonInfoRowView *infoRowView = [HDCommonInfoRowView commonInfoRowViewWithModel:model];
            infoRowView.model = model;
            [_containerView addSubview:infoRowView];
            [self.infoRowViews addObject:infoRowView];
        }
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

#pragma mark - getters and setters
- (void)setModel:(HDDealCommonViewModel *)model {
    _model = model;

    [self commonInit];

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [super updateConstraints];

    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(kRealWidth(20));
        make.centerX.equalTo(self.containerView);
    }];

    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_bottom).offset(kRealWidth(10));
        make.centerX.equalTo(self.containerView);
        make.width.equalTo(self.containerView).offset(-2 * kRealWidth(15));
    }];

    if (self.subTitleLB) {
        [_subTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(5));
            make.centerX.equalTo(self.containerView);
            make.width.equalTo(self.containerView).offset(-2 * kRealWidth(15));
        }];
    }

    [_descLB mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.subTitleLB) {
            make.top.equalTo(self.subTitleLB.mas_bottom).offset(kRealWidth(5));
        } else {
            make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(5));
        }
        make.width.equalTo(self.containerView).offset(-2 * kRealWidth(15));
        make.centerX.equalTo(self.containerView);
    }];

    HDCommonInfoRowView *lastInfoRowView;
    for (short i = 0; i < _infoRowViews.count; i++) {
        HDCommonInfoRowView *infoRowView = _infoRowViews[i];
        [infoRowView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoRowView) {
                make.top.equalTo(lastInfoRowView.mas_bottom).offset(kRealWidth(15));
            } else {
                make.top.equalTo(self.descLB.mas_bottom).offset(kRealWidth(46));
            }
            make.width.equalTo(self.containerView).offset(-2 * kRealWidth(15));
            make.centerX.equalTo(self.containerView);
        }];
        lastInfoRowView = infoRowView;
    }

    if (_infoRowViews.count > 0) {
        // 取出最后一个
        HDCommonInfoRowView *lastInfoRowView = _infoRowViews.lastObject;
        [lastInfoRowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.containerView);
        }];

        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(lastInfoRowView).offset(kRealWidth(15));
            if (!self.remarkLB) {
                make.bottom.equalTo(self);
            }
        }];
    } else {
        if (_lineView) {
            [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.bottom.equalTo(self.lineView).offset(kRealWidth(15));
                if (!self.remarkLB) {
                    make.bottom.equalTo(self);
                }
            }];
        } else {
            [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.bottom.equalTo(self.descLB).offset(kRealWidth(15));
                if (!self.remarkLB) {
                    make.bottom.equalTo(self);
                }
            }];
        }
    }

    if (_remarkLB) {
        [_remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_bottom).offset(kRealWidth(10));
            make.width.centerX.equalTo(self.containerView);
            make.bottom.equalTo(self);
        }];
    }

    // 线条约束
    if (_lineView) {
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.containerView).offset(-2 * self.model.dividingLineHMargin);
            make.height.mas_equalTo(self.model.dividingLineWidth);
            make.centerX.equalTo(self.containerView);
            if (self.infoRowViews.count > self.model.dividingLineIndex) {
                if (self.model.dividingLineIndex > 0) {
                    HDCommonInfoRowView *referencedInfoRowViewTopView = self.infoRowViews[self.model.dividingLineIndex - 1];
                    make.top.equalTo(referencedInfoRowViewTopView.mas_bottom).offset(kRealWidth(15));
                }

                HDCommonInfoRowView *referencedInfoRowView = self.infoRowViews[self.model.dividingLineIndex];
                make.bottom.equalTo(referencedInfoRowView.mas_top).offset(-kRealWidth(15));
            } else {
                make.bottom.equalTo(self.descLB.mas_bottom).offset(kRealWidth(30));
            }
        }];
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // 设置圆角
    self.containerView.layer.cornerRadius = 3;
    self.containerView.layer.masksToBounds = YES;
}

#pragma mark - lazy load
/** @lazy infoRowViews */
- (NSMutableArray<HDCommonInfoRowView *> *)infoRowViews {
    if (!_infoRowViews) {
        _infoRowViews = [[NSMutableArray alloc] init];
    }
    return _infoRowViews;
}
@end
