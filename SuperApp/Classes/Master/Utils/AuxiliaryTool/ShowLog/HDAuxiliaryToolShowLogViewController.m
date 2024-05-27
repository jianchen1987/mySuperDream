//
//  HDAuxiliaryToolShowLogViewController.m
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolShowLogViewController.h"
#import "HDAuxiliaryToolMacro.h"
#import <HDKitCore/HDKitCore.h>


@interface HDAuxiliaryToolShowLogViewController ()
@property (nonatomic, strong) UITextView *textView; ///< 控制器显示
@end


@implementation HDAuxiliaryToolShowLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI {
    // 控制台打印显示框
    UITextView *textView = UITextView.new;
    textView.backgroundColor = UIColor.blackColor;
    textView.showsVerticalScrollIndicator = false;
    textView.textColor = HexColor(0x45AAE0);
    textView.frame = (CGRect){0, 0, self.preferredContentSize};
    textView.editable = false;
    textView.userInteractionEnabled = false;
    [self.view addSubview:textView];
    self.textView = textView;

    CGFloat value = [[[NSUserDefaults standardUserDefaults] valueForKey:kHDAuxiliaryToolShowLogViewAlphaValueKey] floatValue];
    self.textView.alpha = value;
}

- (void)logStr:(NSString *)str {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.textView.isHidden)
            return;
        self.textView.text = [NSString stringWithFormat:@"%@\n%@", self.textView.text, str];
        NSRange range;
        range.location = [self.textView.text length] - 1;
        range.length = 0;
        [self.textView scrollRangeToVisible:range];
    });
}

- (void)setLogCanScroll:(BOOL)canScroll {
    if (self.textView.userInteractionEnabled == canScroll)
        return;

    self.textView.userInteractionEnabled = canScroll;

    if (!canScroll) {
        NSRange range;
        range.location = [self.textView.text length] - 1;
        range.length = 0;
        [self.textView scrollRangeToVisible:range];
    }
}

- (void)setLogTextViewAlpha:(CGFloat)alpha {
    self.textView.alpha = alpha;
}

- (void)clearLog {
    self.textView.text = nil;
}

- (UITextView *)logTextView {
    return self.textView;
}
@end
