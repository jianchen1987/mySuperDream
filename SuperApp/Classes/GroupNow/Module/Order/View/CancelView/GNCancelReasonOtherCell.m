//
//  GNCancelReasonOtherCell.m
//  SuperApp
//
//  Created by wmz on 2022/8/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCancelReasonOtherCell.h"


@interface GNCancelReasonOtherCell () <YYTextViewDelegate>
///输入原因
@property (nonatomic, strong) YYTextView *reasonView;

@end


@implementation GNCancelReasonOtherCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.reasonView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeNotification:) name:YYTextViewTextDidChangeNotification object:nil];
}

- (void)textViewDidChangeNotification:(NSNotification *)obj {
    YYTextView *textView = (YYTextView *)obj.object;
    NSString *string = textView.text;
    NSInteger maxLength = 250;
    //获取高亮部分
    YYTextRange *selectedRange = [textView valueForKey:@"_markedTextRange"];
    NSRange range = [selectedRange asRange];
    NSString *realString = [string substringWithRange:NSMakeRange(0, string.length - range.length)];
    if (realString.length >= maxLength) {
        textView.text = [realString substringWithRange:NSMakeRange(0, maxLength)];
    }
}

- (void)updateConstraints {
    [self.reasonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(8));
        make.bottom.mas_equalTo(-kRealWidth(16));
        make.height.mas_equalTo(kRealWidth(96));
    }];
    [super updateConstraints];
}
- (void)setGNModel:(GNCellModel *)data {
    self.model = data;
    self.contentView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
}

- (void)textViewDidChange:(YYTextView *)textView {
    self.model.title = textView.text;
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (YYTextView *)reasonView {
    if (!_reasonView) {
        _reasonView = YYTextView.new;
        _reasonView.backgroundColor = UIColor.whiteColor;
        _reasonView.textColor = HDAppTheme.color.gn_333Color;
        _reasonView.font = [HDAppTheme.font gn_ForSize:12 weight:UIFontWeightMedium];
        _reasonView.tintColor = HDAppTheme.color.gn_mainColor;
        _reasonView.placeholderText = GNLocalizedString(@"gn_other_reason", @"Please Enter Other Reason");
        _reasonView.delegate = self;
        _reasonView.returnKeyType = UIReturnKeyDone;
        _reasonView.placeholderFont = [HDAppTheme.font gn_ForSize:12];
        _reasonView.placeholderTextColor = HDAppTheme.color.gn_cccccc;
        _reasonView.textContainerInset = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(12), kRealWidth(12), kRealWidth(12));
        _reasonView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (@available(iOS 13.0, *)) {
            _reasonView.automaticallyAdjustsScrollIndicatorInsets = false;
        }
    }
    return _reasonView;
}
@end
