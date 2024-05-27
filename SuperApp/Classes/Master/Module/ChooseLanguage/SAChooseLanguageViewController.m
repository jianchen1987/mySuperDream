//
//  SAChooseLanguageViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/9/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChooseLanguageViewController.h"
#import "SAChooseLanguageButton.h"


@interface SAChooseLanguageViewController ()
/// 背景
@property (nonatomic, strong) UIImageView *bgIV;
/// 主图
@property (nonatomic, strong) UIImageView *mainIV;
/// 下方容器
@property (nonatomic, strong) UIView *downPartContainer;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 语言按钮容器
@property (nonatomic, strong) UIView *buttonContainer;
/// logo
@property (nonatomic, strong) UIImageView *logoIV;
@end


@implementation SAChooseLanguageViewController

- (void)hd_setupViews {
    [self.view addSubview:self.bgIV];
    [self.view addSubview:self.mainIV];
    [self.view addSubview:self.downPartContainer];
    [self.downPartContainer addSubview:self.titleLB];
    [self.downPartContainer addSubview:self.buttonContainer];
    NSArray<NSString *> *languages = SAMultiLanguageManager.supportLanguageDisplayNames;
    for (NSString *language in languages) {
        SAChooseLanguageButton *button = [SAChooseLanguageButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:language forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[SAMultiLanguageManager imageNameForLanguageType:[SAMultiLanguageManager languageTypeForDisplayName:language]]] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.hd_associatedObject = language;
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard2Bold;
        [button addTarget:self action:@selector(clickedLanguageButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainer addSubview:button];

        SALanguageType type = [SAMultiLanguageManager languageTypeForDisplayName:language];
        if ([type isEqualToString:SALanguageTypeEN]) {
            [button updateBackgroundWithGradientLayerColors:@[
                (__bridge id)[UIColor colorWithRed:255 / 255.0 green:136 / 255.0 blue:18 / 255.0 alpha:1.0].CGColor,
                (__bridge id)[UIColor colorWithRed:255 / 255.0 green:85 / 255.0 blue:18 / 255.0 alpha:1.0].CGColor
            ]];
        } else if ([type isEqualToString:SALanguageTypeKH]) {
            [button updateBackgroundWithGradientLayerColors:@[
                (__bridge id)[UIColor colorWithRed:254 / 255.0 green:125 / 255.0 blue:148 / 255.0 alpha:1.0].CGColor,
                (__bridge id)[UIColor colorWithRed:252 / 255.0 green:65 / 255.0 blue:88 / 255.0 alpha:1.0].CGColor
            ]];
        } else {
            [button updateBackgroundWithGradientLayerColors:@[
                (__bridge id)[UIColor colorWithRed:254 / 255.0 green:176 / 255.0 blue:1 / 255.0 alpha:1.0].CGColor,
                (__bridge id)[UIColor colorWithRed:254 / 255.0 green:215 / 255.0 blue:1 / 255.0 alpha:1.0].CGColor
            ]];
        }
    }
    [self.downPartContainer addSubview:self.logoIV];
}

- (void)hd_languageDidChanged {
    self.titleLB.text = SALocalizedString(@"choose_language", @"选择语言");
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSUserDefaults.standardUserDefaults setObject:@(1) forKey:@"hasShownChooseLanguageWindow"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark - event response
- (void)clickedLanguageButtonHandler:(SAChooseLanguageButton *)button {
    SALanguageType type = [SAMultiLanguageManager languageTypeForDisplayName:button.hd_associatedObject];
    [SAMultiLanguageManager setLanguage:type];

    !self.actionCompletionBlock ?: self.actionCompletionBlock();
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.downPartContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleLB.mas_top).offset(-kRealWidth(20));
    }];
    [self.logoIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.downPartContainer);
        make.size.mas_equalTo(self.logoIV.image.size);
        make.bottom.equalTo(self.downPartContainer).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(30)));
    }];
    [self.buttonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(self.downPartContainer);
        make.bottom.equalTo(self.logoIV.mas_top);
    }];
    [self.buttonContainer.subviews sa_distributeSudokuViewsWithFixedLineSpacing:0 fixedInteritemSpacing:8 columnCount:3 heightToWidthScale:62 / 105.0 topSpacing:20 bottomSpacing:20 leadSpacing:20
                                                                    tailSpacing:20];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.downPartContainer).offset(-2 * 20);
        make.centerX.equalTo(self.downPartContainer);
        make.bottom.equalTo(self.buttonContainer.mas_top);
    }];
    [self.mainIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.view);
        make.bottom.equalTo(self.downPartContainer.mas_top).offset(20);
        make.height.equalTo(self.mainIV.mas_width).multipliedBy(self.mainIV.image.size.height / self.mainIV.image.size.width);
    }];
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.top.equalTo(self.view);
        make.bottom.equalTo(self.mainIV);
    }];

    [super updateViewConstraints];
}

#pragma mark - lazy load
- (UIImageView *)bgIV {
    if (!_bgIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"choose_language_bg"];
        _bgIV = imageView;
    }
    return _bgIV;
}

- (UIImageView *)mainIV {
    if (!_mainIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:SALocalizedString(@"choose_language_main", @"choose_language_main")];
        [imageView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        _mainIV = imageView;
    }
    return _mainIV;
}

- (UIView *)downPartContainer {
    if (!_downPartContainer) {
        _downPartContainer = UIView.new;
        _downPartContainer.backgroundColor = UIColor.whiteColor;
        _downPartContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
        };
        [_downPartContainer setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _downPartContainer;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _titleLB = label;
    }
    return _titleLB;
}

- (UIView *)buttonContainer {
    if (!_buttonContainer) {
        _buttonContainer = UIView.new;
    }
    return _buttonContainer;
}

- (UIImageView *)logoIV {
    if (!_logoIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:SALocalizedString(@"choose_language_logo", @"choose_language_logo")];
        _logoIV = imageView;
    }
    return _logoIV;
}
@end
