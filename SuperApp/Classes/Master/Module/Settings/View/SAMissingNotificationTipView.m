//
//  SAMissingNotificationTipView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMissingNotificationTipView.h"
#import <HDServiceKit/HDSystemCapabilityUtil.h>
#import <YYText/YYText.h>


@implementation SAMissingNotificationTipModel
@end


@interface SAMissingNotificationTipView ()
/// 提示
@property (nonatomic, strong) YYLabel *contentLB;
@end


@implementation SAMissingNotificationTipView

- (void)hd_setupViews {
    [self addSubview:self.contentLB];
}

- (void)updateConstraints {
    self.contentLB.preferredMaxLayoutWidth = kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self).offset(kRealWidth(10));
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self).offset(-kRealWidth(5));
    }];

    if (self.model.shouldFittingSize) {
        CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.frame = CGRectMake(0, 0, kScreenWidth, size.height);
    }

    [super updateConstraints];
}

- (void)hd_languageDidChanged {
    [self updateAgreementText];
}

#pragma mark - setter
- (void)setModel:(SAMissingNotificationTipModel *)model {
    _model = model;

    [self updateAgreementText];
    [self setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)updateAgreementText {
    NSString *part1 = SALocalizedString(@"missing_notification_tip_1", @"You’re missing important messages! Enable notification via ");
    NSString *part2 = SALocalizedString(@"missing_notification_tip_2", @"Settings - Notifications ");
    NSString *part3 = SALocalizedString(@"missing_notification_tip_3", @"on your phone.");
    //    NSString *part4 = SALocalizedString(@"missing_notification_tip_4", @"Go to setup now!");

    NSAttributedString *part1Str = [[NSAttributedString alloc] initWithString:part1 attributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.color.G2}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:part1Str];
    NSAttributedString *part2Str = [[NSAttributedString alloc] initWithString:part2
                                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.standard3Bold, NSForegroundColorAttributeName: HDAppTheme.color.G1}];
    [text appendAttributedString:part2Str];
    NSAttributedString *part3Str = [[NSAttributedString alloc] initWithString:part3 attributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.color.G2}];
    [text appendAttributedString:part3Str];
    //    NSAttributedString *part4Str =
    //        [[NSAttributedString alloc] initWithString:part4
    //                                        attributes:
    //                                            @{NSFontAttributeName: HDAppTheme.font.standard3Bold,
    //                                              NSForegroundColorAttributeName: HDAppTheme.color.G1}];
    //    [text appendAttributedString:part4Str];

    [text yy_setTextHighlightRange:NSMakeRange(part1.length, part2.length) color:HDAppTheme.color.G1 backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             [HDSystemCapabilityUtil openAppSystemSettingPage];
                         }];

    //    [text yy_setTextHighlightRange:NSMakeRange(part1.length + part2.length + part3.length, part4.length)
    //                             color:HDAppTheme.color.G1
    //                   backgroundColor:[UIColor whiteColor]
    //                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
    //                             [HDSystemCapabilityUtil openAppSystemSettingPage];
    //                         }];

    self.contentLB.attributedText = text;
    self.contentLB.textAlignment = NSTextAlignmentLeft;
}

#pragma mark - lazy load
- (YYLabel *)contentLB {
    if (!_contentLB) {
        YYLabel *label = YYLabel.new;
        label.numberOfLines = 0;
        _contentLB = label;
    }
    return _contentLB;
}
@end
