//
//  TNExpressCostStandardAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/17.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNExplanationAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface TNExplanationAlertView ()
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 确认按钮
@property (strong, nonatomic) SAOperationButton *doneBtn;
/// 文本展示
@property (strong, nonatomic) UITextView *contentTextView;
/// 内容
@property (nonatomic, copy) NSString *content;
/// 标题
@property (nonatomic, copy) NSString *title;
@end


@implementation TNExplanationAlertView
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content {
    self = [super init];
    if (self) {
        self.title = title;
        self.content = content;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}
#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}
- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.contentTextView];
    [self.containerView addSubview:self.doneBtn];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    CGFloat height = [self.contentTextView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT)].height;
    if (height > kScreenHeight * 0.7) {
        height = kScreenHeight * 0.7;
        self.contentTextView.scrollEnabled = YES;
    }
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(height);
    }];
    [self.doneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.contentTextView.mas_bottom).offset(kRealWidth(20));
        make.height.mas_equalTo(kRealWidth(45));
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];
}

/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = self.title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
/** @lazy contentTextView */
- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.textColor = HDAppTheme.TinhNowColor.G1;
        _contentTextView.font = HDAppTheme.TinhNowFont.standard12;
        _contentTextView.editable = NO;
        _contentTextView.scrollEnabled = NO;
        _contentTextView.selectable = NO;
        _contentTextView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, -4);
        if (HDIsStringNotEmpty(self.content)) {
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            style.lineSpacing = 5;
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:[self.content dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                                 documentAttributes:nil
                                                                                              error:nil];
            ;
            [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.content.length)];
            _contentTextView.attributedText = attrString;
        }
    }
    return _contentTextView;
}
- (SAOperationButton *)doneBtn {
    if (!_doneBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.cornerRadius = 0;
        button.titleLabel.font = HDAppTheme.TinhNowFont.standard17B;
        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        [button setTitle:TNLocalizedString(@"1GuBJmHn", @"我知道了") forState:UIControlStateNormal];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _doneBtn = button;
    }
    return _doneBtn;
}
@end
