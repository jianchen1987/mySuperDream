//
//  PayHDCheckstandCustomNavBarView.m
//  ViPay
//
//  Created by VanJay on 2019/5/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandCustomNavBarView.h"
#import "HDAppTheme.h"
#import "HDCommonButton.h"
#import "Masonry.h"
#import "NSString+HD_Size.h"
#import "UIButton+EnlargeEdge.h"


@interface PayHDCheckstandCustomNavBarView ()
@property (nonatomic, strong) HDCommonButton *leftBtn;  ///< 左按钮
@property (nonatomic, strong) HDCommonButton *rightBtn; ///< 右按钮
@property (nonatomic, strong) HDCommonButton *titleBtn; ///< 标题
@property (nonatomic, strong) UIView *bottomLine;       ///< 底部线条
@end


@implementation PayHDCheckstandCustomNavBarView
#pragma mark - life cycle
- (void)commonInit {
    _leftBtn = [HDCommonButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn addTarget:self action:@selector(clickedLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn setEnlargeEdge:20];
    [self addSubview:_leftBtn];

    _rightBtn = [HDCommonButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn addTarget:self action:@selector(clickedRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setEnlargeEdge:20];
    [self addSubview:_rightBtn];

    _titleBtn = [HDCommonButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.enabled = NO;
    _titleBtn.adjustsImageWhenDisabled = NO;
    [_titleBtn setTitleColor:[HDAppTheme.color G1] forState:UIControlStateNormal];
    [self addSubview:_titleBtn];

    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [HDAppTheme.color G4];
    [self addSubview:_bottomLine];
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

- (void)updateConstraints {
    [super updateConstraints];

    [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];

    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];

    [self.titleBtn sizeToFit];
    //    CGSize size = CGSizeMake(self.titleBtn.width + self.titleBtn.imageViewEdgeInsets.left + self.titleBtn.imageViewEdgeInsets.right + self.titleBtn.labelEdgeInsets.left +
    //    self.titleBtn.labelEdgeInsets.right+10, self.titleBtn.bounds.size.height);
    self.titleBtn.titleLabel.adjustsFontSizeToFitWidth = true;
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        //        make.size.mas_equalTo(size);
    }];

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - event response
- (void)clickedLeftBtn {
    !self.clickedLeftBtnHandler ?: self.clickedLeftBtnHandler();
}

- (void)clickedRightBtn {
    !self.clickedRightBtnHandler ?: self.clickedRightBtnHandler();
}

#pragma mark - getters and setters
- (void)setLeftBtnImage:(NSString *)imageName title:(NSString *)title {
    [_leftBtn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_leftBtn setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleBtnImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font {
    if (imageName) {
        _titleBtn.imageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    }
    if (font) {
        _titleBtn.titleLabel.font = font;
    } else {
        _titleBtn.titleLabel.font = [HDAppTheme.font standard2Bold];
    }

    [_titleBtn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_titleBtn setTitle:title forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

- (void)setRightBtnImage:(NSString *)imageName title:(NSString *)title {
    [_rightBtn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_rightBtn setTitle:title forState:UIControlStateNormal];
}
@end
