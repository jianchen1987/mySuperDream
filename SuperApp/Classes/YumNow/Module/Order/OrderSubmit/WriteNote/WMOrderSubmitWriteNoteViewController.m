//
//  WMOrderSubmitWriteNoteViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitWriteNoteViewController.h"
#import "LKDataRecord.h"
#import "WMCustomViewActionView.h"
#import "WMOrderChangeReminderView.h"
#import "WMWriteNoteTagRspModel.h"


@interface WMOrderSubmitWriteNoteViewController () <HDTextViewDelegate>
/// 传入内容
@property (nonatomic, copy) NSString *contentText;
/// 找零文本
@property (nonatomic, copy) NSString *changeReminderText;
/// 回调
@property (nonatomic, copy) void (^callback)(NSString *content, NSString *changeReminder);
/// 回调标签数据
@property (nonatomic, copy) void (^tagCallback)(NSArray<WMWriteNoteTagRspModel *> *tagArray);
/// 输入框包裹底部
@property (nonatomic, strong) UIView *textViewContainView;
/// 输入框
@property (nonatomic, strong) HDTextView *textView;
/// 提示文本
@property (nonatomic, strong) HDLabel *tipLB;
/// 快速编辑文本
@property (nonatomic, strong) HDLabel *quickLB;
/// 文本长度显示
@property (nonatomic, strong) SALabel *textLengthLabel;
/// 提交按钮
@property (nonatomic, strong) SAOperationButton *submitBTN;
/// 标签视图
@property (nonatomic, strong) HDFloatLayoutView *floatView;
/// 输入框最小高度
@property (nonatomic, assign) CGFloat textViewMinimumHeight;
/// 是否已经填充过传入内容
@property (nonatomic, assign) BOOL hasFilledContentText;
/// 货到付款
@property (nonatomic, assign) BOOL onCashPay;
/// 应付金额
@property (nonatomic, strong) SAMoneyModel *payMoney;
/// 找零弹窗
@property (nonatomic, strong) WMCustomViewActionView *actionView;
/// 记录键盘是否弹出
@property (nonatomic, assign) BOOL keyBoardlsVisible;
/// 快捷输入数组
@property (nonatomic, strong) NSMutableArray<WMWriteNoteTagRspModel *> *dataSource;

@property (nonatomic, assign) NSInteger serviceType;
@end


@implementation WMOrderSubmitWriteNoteViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    void (^callback)(NSString *_Nullable, NSString *_Nullable) = [parameters objectForKey:@"callback"];
    void (^tagCallback)(NSArray<WMWriteNoteTagRspModel *> *_Nullable) = [parameters objectForKey:@"tagCallback"];
    self.callback = callback;
    self.tagCallback = tagCallback;
    self.contentText = [parameters objectForKey:@"contentText"];
    self.changeReminderText = [parameters objectForKey:@"changeReminderText"];
    if ([parameters objectForKey:@"onCashPay"]) {
        self.onCashPay = [[parameters objectForKey:@"onCashPay"] boolValue];
    }
    self.payMoney = [parameters objectForKey:@"payMoney"];
    self.serviceType = [[parameters objectForKey:@"serviceType"] integerValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"remark_title", @"填写备注");
}

- (void)hd_setupViews {
    self.textViewMinimumHeight = kRealWidth(81);
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.submitBTN];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.tipLB];
    [self.scrollViewContainer addSubview:self.textViewContainView];
    [self.scrollViewContainer addSubview:self.quickLB];
    [self.scrollViewContainer addSubview:self.floatView];
    [self.textViewContainView addSubview:self.textView];
    [self.textViewContainView addSubview:self.textLengthLabel];
    [self activeViewConstraints];
    if (self.serviceType != 20) {
        [self getFastDatasource];
    } else {
        self.quickLB.hidden = YES;
        self.floatView.hidden = YES;
        [self quickInputSubView];
    }
    [LKDataRecord.shared traceEvent:@"enterRemarkDetail" name:@"enterRemarkDetail"
                         parameters:@{@"type": @"enterRemarkDetail", @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000]}
                                SPM:nil];
}

///获取标签
- (void)getFastDatasource {
    self.dataSource = NSMutableArray.new;
    if (self.onCashPay) {
        WMWriteNoteTagRspModel *changeModel = WMWriteNoteTagRspModel.new;
        changeModel.name = [[SAInternationalizationModel alloc] initWithWMInternationalKey:@"note_Need_changes_optional" value:@"希望骑手找零" table:nil];
        changeModel.infactStr = self.changeReminderText ?: changeModel.name.desc;
        [self.dataSource addObject:changeModel];
    }
    @HDWeakify(self) CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/takeaway-order/app/user/fast/remark";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self) SARspModel *rspModel = response.extraData;
        NSArray *dataSource = [NSArray yy_modelArrayWithClass:WMWriteNoteTagRspModel.class json:rspModel.data];
        [self.dataSource addObjectsFromArray:dataSource];
        [self quickInputSubView];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self)[self quickInputSubView];
    }];
}

///快捷输入数据源
- (void)quickInputSubView {
    if (self.tagCallback) {
        self.tagCallback(self.dataSource);
    }
    if (HDIsStringNotEmpty(self.contentText)) {
        self.textView.text = self.contentText;
        [self textViewDidChange:self.textView];
    }
    self.quickLB.hidden = self.floatView.hidden = HDIsArrayEmpty(self.dataSource);
    [self.floatView hd_removeAllSubviews];
    @HDWeakify(self)[self.dataSource enumerateObjectsUsingBlock:^(WMWriteNoteTagRspModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:obj.name.desc forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(7), kRealWidth(8), kRealWidth(7), kRealWidth(8));
        [btn setTitleColor:HDAppTheme.WMColor.B3 forState:UIControlStateNormal];
        btn.adjustsButtonWhenHighlighted = NO;
        btn.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12];
        btn.layer.cornerRadius = kRealWidth(4);
        btn.layer.backgroundColor = HDAppTheme.WMColor.white.CGColor;
        btn.layer.borderWidth = 0.7;
        btn.layer.borderColor = [UIColor hd_colorWithHexString:@"#D7D8E2"].CGColor;
        [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [LKDataRecord.shared traceEvent:@"touchFastIocn" name:@"touchFastIocn"
                                 parameters:@{@"type": @"touchFastIocn", @"time": [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970 * 1000], @"fastCode": obj.codeStr ?: @"找零"}
                                        SPM:nil];
            if (idx == 0 && !obj.codeStr) {
                @HDStrongify(self)[self changeReminderAlert:obj];
            } else {
                [self clickTagQuickAction:obj];
            }
        }];
        [btn sizeToFit];
        [self.floatView addSubview:btn];
    }];
    [self.view setNeedsUpdateConstraints];
}

///找零
- (void)changeReminderAlert:(WMWriteNoteTagRspModel *)model {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    config.containerMinHeight = kRealWidth(100);
    config.marginTitleToContentView = kRealWidth(16);
    config.textAlignment = HDCustomViewActionViewTextAlignmentLeft;
    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), 0, kRealWidth(12));
    config.title = WMLocalizedString(@"order_submit_Change_reminder", @"找零提醒");
    config.titleFont = [HDAppTheme.WMFont wm_ForSize:20 weight:UIFontWeightHeavy];
    config.titleColor = HDAppTheme.WMColor.B3;
    config.style = HDCustomViewActionViewStyleClose;
    config.iPhoneXFillViewBgColor = UIColor.whiteColor;
    config.shouldAddScrollViewContainer = NO;
    config.contentHorizontalEdgeMargin = 0;
    WMOrderChangeReminderView *reasonView = [[WMOrderChangeReminderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(300))];
    reasonView.isShowDontshowBTN = NO;
    reasonView.payModel = self.payMoney;
    [reasonView layoutyImmediately];
    WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:reasonView config:config];
    [actionView show];
    self.actionView = actionView;
    @HDWeakify(self) @HDWeakify(actionView) reasonView.clickedConfirmBlock = ^(NSString *_Nonnull inputStr) {
        @HDStrongify(self) @HDStrongify(actionView)[actionView dismiss];
        model.infactStr = [NSString stringWithFormat:WMLocalizedString(@"order_submit_Need_changes", @"希望骑手找零,已备好%@零钱"), inputStr];
        [self clickQuickAction:model];
    };
}

///找零文本
- (void)clickQuickAction:(WMWriteNoteTagRspModel *)model {
    NSMutableString *text = [[NSMutableString alloc] initWithString:self.textView.text ?: @""];
    if (self.changeReminderText && [text rangeOfString:self.changeReminderText].length > 0) {
        NSRange range = [text rangeOfString:self.changeReminderText];
        [text replaceCharactersInRange:range withString:model.infactStr];
    } else {
        BOOL notEmpty = text.length > 0;
        [text insertString:model.infactStr atIndex:0];
        if (notEmpty) {
            [text insertString:@"," atIndex:model.infactStr.length];
        }
    }
    self.textView.text = text;
    self.changeReminderText = model.infactStr;
    self.submitBTN.enabled = HDIsStringNotEmpty(self.textView.text);
}

///标签文本
- (void)clickTagQuickAction:(WMWriteNoteTagRspModel *)model {
    NSMutableString *text = [[NSMutableString alloc] initWithString:self.textView.text ?: @""];
    NSString *insertStr = model.name.desc;
    if (text.length > 0) {
        insertStr = [@"," stringByAppendingString:insertStr];
    }
    NSRange range = self.textView.selectedRange;
    [text insertString:insertStr atIndex:range.location];
    self.textView.text = text;
    self.submitBTN.enabled = HDIsStringNotEmpty(self.textView.text);
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        if (self.submitBTN.isHidden) {
            make.bottom.equalTo(self.view);
        } else {
            make.bottom.equalTo(self.submitBTN.mas_top);
        }
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.submitBTN.isHidden) {
            make.right.mas_equalTo(-kRealWidth(12));
            make.left.mas_equalTo(kRealWidth(12));
            make.height.mas_equalTo(kRealWidth(44));
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-kRealWidth(8));
        }
    }];

    [self.textViewContainView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(15));
        make.left.mas_equalTo(kRealWidth(15));
        make.top.equalTo(self.tipLB.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
    }];

    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(-kRealWidth(15));
    }];

    [self.quickLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.quickLB.isHidden) {
            make.left.right.equalTo(self.tipLB);
            make.top.equalTo(self.textViewContainView.mas_bottom).offset(kRealWidth(24));
        }
    }];

    [self.floatView sizeToFit];
    [self.floatView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatView.isHidden) {
            make.left.right.equalTo(self.tipLB);
            make.top.equalTo(self.quickLB.mas_bottom).offset(kRealWidth(12));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(8));
            CGFloat width = kScreenWidth - kRealWidth(30);
            CGSize size = [self.floatView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
        }
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(12) - 5);
        make.left.mas_equalTo(kRealWidth(12) - 5);
        make.right.mas_equalTo(-kRealWidth(12));
        const CGFloat textViewWidth = kScreenWidth - kRealWidth(54);
        const CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(textViewWidth, CGFLOAT_MAX)];
        make.height.mas_equalTo(fmax(textViewSize.height, self.textViewMinimumHeight));
    }];

    [self.textLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(8));
        make.bottom.mas_equalTo(-kRealWidth(8));
    }];

    [super updateViewConstraints];
}

- (void)activeViewConstraints {
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(12) - 5);
        make.left.mas_equalTo(kRealWidth(12) - 5);
        make.right.mas_equalTo(-kRealWidth(12));
        const CGFloat textViewWidth = kScreenWidth - kRealWidth(54);
        const CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(textViewWidth, CGFLOAT_MAX)];
        make.height.mas_equalTo(fmax(textViewSize.height, self.textViewMinimumHeight));
    }];
}

#pragma mark - HDTextViewDelegate
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmax(height, self.textViewMinimumHeight);
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        // 实现自适应高度
        @HDWeakify(self);
        void (^updateConstraintsWithAnimation)(void) = ^(void) {
            @HDStrongify(self);
            [self activeViewConstraints];
        };
        updateConstraintsWithAnimation();
    }
}

- (BOOL)textViewShouldReturn:(HDTextView *)textView {
    [self.view.window endEditing:true];
    return YES;
}

- (void)textViewDidChange:(HDTextView *)textView {
    NSInteger realLength = textView.text.length;
    NSInteger length = [self getRealInputLength];
    self.textLengthLabel.text = [NSString stringWithFormat:@"%zd/%d", length, 100];
    self.submitBTN.enabled = HDIsStringNotEmpty(textView.text);
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos)
        return;
    if (length > 100 && self.dataSource.count) {
        self.textLengthLabel.text = [NSString stringWithFormat:@"%d/%d", 100, 100];
        textView.text = [textView.text substringToIndex:realLength - 1];
        [HDTips showError:[NSString stringWithFormat:WMLocalizedString(@"text_not_longer_than", @"文字不能超过 %@ 个字符"), @(100)] inView:self.view];
    }
}

///获取真实文本长度 不算标签
- (NSInteger)getRealInputLength {
    __block NSInteger length = self.textView.text.length;
    NSString *text = self.textView.text;
    [self.dataSource enumerateObjectsUsingBlock:^(WMWriteNoteTagRspModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (text) {
            NSString *pattern = [NSString stringWithFormat:@"%@", obj.infactStr];
            if (pattern) {
                if (obj.codeStr) {
                    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
                    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
                    if (!HDIsArrayEmpty(matches)) {
                        for (NSTextCheckingResult *result in [matches objectEnumerator]) {
                            if (result.range.location == 0) {
                                length -= (result.range.length);
                            } else {
                                if ([[text substringWithRange:NSMakeRange(result.range.location - 1, 1)] isEqualToString:@","]) {
                                    length -= (result.range.length + 1);
                                }
                            }
                        }
                    }
                } else {
                    if ([text containsString:obj.infactStr]) {
                        NSRange range = [text rangeOfString:obj.infactStr];
                        if (range.location == 0) {
                            length -= (range.length);
                        } else {
                            if ([[text substringWithRange:NSMakeRange(range.location - 1, 1)] isEqualToString:@","]) {
                                length -= (range.length + 1);
                            }
                        }
                    }
                }
            }
        }
    }];
    return length;
}

#pragma mark - event response
- (void)clickedSubmitButtonHandler {
    !self.callback ?: self.callback(self.textView.text, self.changeReminderText);
    [self dismissAnimated:true completion:nil];
}

// 键盘打开
- (void)keyBoardWillShow:(NSNotification *)note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    //    self.actionView.containerView.hd_top = kScreenHeight - kRealWidth(300);
    if (self.actionView && !self.keyBoardlsVisible) {
        [UIView animateWithDuration:0.3 animations:^{
            self.actionView.containerView.hd_top -= keyBoardHeight;
        }];
        self.keyBoardlsVisible = YES;
    }
}
//键盘收起
- (void)keyBoardWillHide:(NSNotification *)note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    if (self.actionView && self.keyBoardlsVisible) {
        [UIView animateWithDuration:0.3 animations:^{
            self.actionView.containerView.hd_top += keyBoardHeight;
        }];
        self.keyBoardlsVisible = NO;
    }
}

#pragma mark - lazy load
- (HDLabel *)tipLB {
    if (!_tipLB) {
        HDLabel *la = HDLabel.new;
        la.numberOfLines = 0;
        la.textColor = HDAppTheme.WMColor.B3;
        la.text = WMLocalizedString(@"note_Your_feedback_on_merchants_or_riders", @"您对商家或骑手的反馈");
        if (self.serviceType == 20) {
            la.text = WMLocalizedString(@"wm_pickup_Your remarks to the merchant", @"您对商家的反馈");
        }
        la.font = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        _tipLB = la;
    }
    return _tipLB;
}

- (HDLabel *)quickLB {
    if (!_quickLB) {
        HDLabel *la = HDLabel.new;
        la.numberOfLines = 0;
        la.textColor = HDAppTheme.WMColor.B3;
        la.text = WMLocalizedString(@"note_Write_quickly", @"快速填写");
        la.font = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        _quickLB = la;
    }
    return _quickLB;
}

- (HDFloatLayoutView *)floatView {
    if (!_floatView) {
        _floatView = HDFloatLayoutView.new;
        _floatView.maximumItemSize = CGSizeMake(kScreenWidth - kRealWidth(30), kRealWidth(28));
        _floatView.itemMargins = UIEdgeInsetsMake(0, 0, kRealWidth(12), kRealWidth(8));
    }
    return _floatView;
}

- (UIView *)textViewContainView {
    if (!_textViewContainView) {
        _textViewContainView = UIView.new;
        _textViewContainView.layer.cornerRadius = kRealWidth(4);
        _textViewContainView.layer.backgroundColor = HDAppTheme.WMColor.F6F6F6.CGColor;
    }
    return _textViewContainView;
}

- (HDTextView *)textView {
    if (!_textView) {
        _textView = HDTextView.new;
        _textView.placeholder = WMLocalizedString(@"describe_your_requirements", @"请描述您的要求。");
        _textView.placeholderColor = HDAppTheme.WMColor.CCCCCC;
        _textView.font = [HDAppTheme.WMFont wm_ForSize:14];
        _textView.placeholderMargins = UIEdgeInsetsZero;
        _textView.textColor = HDAppTheme.WMColor.B3;
        _textView.delegate = self;
        _textView.shouldResponseToProgrammaticallyTextChanges = NO;
        _textView.tintColor = HDAppTheme.WMColor.B3;
        //        _textView.maximumTextLength = 100;
        _textView.backgroundColor = UIColor.clearColor;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

- (SALabel *)textLengthLabel {
    if (!_textLengthLabel) {
        SALabel *label = SALabel.new;
        label.text = @"0/100";
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.textColor = HDAppTheme.WMColor.B9;
        _textLengthLabel = label;
    }
    return _textLengthLabel;
}

- (SAOperationButton *)submitBTN {
    if (!_submitBTN) {
        _submitBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _submitBTN.layer.cornerRadius = kRealWidth(22);
        _submitBTN.layer.masksToBounds = YES;
        _submitBTN.enabled = false;
        [_submitBTN applyPropertiesWithBackgroundColor:HDAppTheme.color.mainColor];
        [_submitBTN addTarget:self action:@selector(clickedSubmitButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        [_submitBTN setTitle:WMLocalizedStringFromTable(@"submit", @"提交", @"Buttons") forState:UIControlStateNormal];
    }
    return _submitBTN;
}
@end
