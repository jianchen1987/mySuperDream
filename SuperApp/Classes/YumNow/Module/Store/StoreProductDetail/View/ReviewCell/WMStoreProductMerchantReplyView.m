//
//  WMStoreProductMerchantReplyView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductMerchantReplyView.h"
#import <YYText/YYText.h>

#define kSideMargin kRealWidth(10)


@interface WMStoreProductMerchantReplyView ()
/// icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 评分、评价
@property (nonatomic, strong) YYLabel *contentLB;
/// 文字最宽宽度
@property (nonatomic, assign, readonly) CGFloat contentLabelPreferredMaxLayoutWidth;
@end


@implementation WMStoreProductMerchantReplyView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.iconIV];
    [self addSubview:self.titleLB];
    [self addSubview:self.contentLB];

    self.backgroundColor = HDAppTheme.color.G5;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:5];
    };
}

#pragma mark - public methods
- (void)updateMerchantReply:(NSString *)reply
    isMerchantReplyExpanded:(BOOL)isMerchantReplyExpanded
    showReadMoreMaxRowCount:(NSUInteger)showReadMoreMaxRowCount
              numberOfLines:(NSUInteger)numberOfLines {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSAttributedString *appendingStr = [[NSMutableAttributedString alloc] initWithString:reply
                                                                              attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard3}];

    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.contentLabelPreferredMaxLayoutWidth, CGFLOAT_MAX) text:appendingStr];
    self.contentLB.numberOfLines = 0;
    if (showReadMoreMaxRowCount > 0 && textLayout.rowCount > showReadMoreMaxRowCount) {
        if (isMerchantReplyExpanded) {
            [text appendAttributedString:appendingStr];
            // 查看更少
            NSAttributedString *readLessStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"read_less", @"收起")
                                                                                     attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.C1, NSFontAttributeName: HDAppTheme.font.standard3}];
            [text appendAttributedString:readLessStr];

            @HDWeakify(self);
            [text yy_setTextHighlightRange:NSMakeRange(appendingStr.length, text.length - appendingStr.length) color:HDAppTheme.color.C1 backgroundColor:UIColor.clearColor
                                 tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                     @HDStrongify(self);
                                     !self.clickedReadMoreOrReadLessBlock ?: self.clickedReadMoreOrReadLessBlock();
                                 }];
        } else {
            // 查看更多
            NSAttributedString *readMoreStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"read_more", @"展开")
                                                                                     attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.C3, NSFontAttributeName: HDAppTheme.font.standard3}];
            // 省略号
            NSAttributedString *rellipsisStr =
                [[NSMutableAttributedString alloc] initWithString:@" ... " attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard3}];

            // 获取前 maxRowCount 行内容
            YYTextLine *thirdLine = textLayout.lines[showReadMoreMaxRowCount - 1];
            appendingStr = [appendingStr attributedSubstringFromRange:NSMakeRange(0, thirdLine.range.location + thirdLine.range.length)];

            [text appendAttributedString:appendingStr];
            [text appendAttributedString:rellipsisStr];

            // 查看更多之前
            NSAttributedString *strBeforeReadMore;
            [text appendAttributedString:readMoreStr];

            // 取了前 maxRowCount 行，拼接内容肯定超过 maxRowCount 行
            BOOL isNewRowCountLessThanMaxRowCount = false;
            // 循环判断拼接后的内容是否在 maxRowCount 行以内，超过 maxRowCount 行内容减 1，兼容了 emoji 字符情况
            while (!isNewRowCountLessThanMaxRowCount) {
                NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] init];
                NSString *newAppendingStr = [appendingStr.string hd_substringAvoidBreakingUpCharacterSequencesToIndex:appendingStr.string.length - 1 lessValue:true
                                                                                       countingNonASCIICharacterAsTwo:false];

                appendingStr = [[NSMutableAttributedString alloc] initWithString:newAppendingStr
                                                                      attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard3}];

                [newText appendAttributedString:appendingStr];
                [newText appendAttributedString:rellipsisStr];

                strBeforeReadMore = newText.mutableCopy;
                [newText appendAttributedString:readMoreStr];

                YYTextLayout *newTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.contentLabelPreferredMaxLayoutWidth, CGFLOAT_MAX) text:newText];
                isNewRowCountLessThanMaxRowCount = newTextLayout.rowCount <= showReadMoreMaxRowCount;
                text = newText;
            }

            @HDWeakify(self);
            [text yy_setTextHighlightRange:NSMakeRange(strBeforeReadMore.length, text.length - strBeforeReadMore.length) color:HDAppTheme.color.C1 backgroundColor:UIColor.clearColor
                                 tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                     @HDStrongify(self);
                                     !self.clickedReadMoreOrReadLessBlock ?: self.clickedReadMoreOrReadLessBlock();
                                 }];
        }
    } else {
        self.contentLB.numberOfLines = numberOfLines;
        [text appendAttributedString:appendingStr];
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = [SAMultiLanguageManager isCurrentLanguageCN] ? 9 : 7.2;
    NSRange range = NSMakeRange(0, [text length]);
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];

    self.contentLB.attributedText = text;

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSideMargin);
        make.top.equalTo(self).offset(kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(16), kRealWidth(16)));
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(5));
        make.top.equalTo(self).offset(kRealWidth(10));
        make.right.equalTo(self).offset(-kSideMargin);
    }];
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kSideMargin);
        make.top.greaterThanOrEqualTo(self.iconIV.mas_bottom).offset(kRealWidth(10));
        make.top.greaterThanOrEqualTo(self.titleLB.mas_bottom).offset(kRealWidth(10));
        make.bottom.equalTo(self).offset(-kRealWidth(10));
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"store_reply_icon"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G1;
        label.text = WMLocalizedString(@"store_reviews_merchant_reply", @"商家回复");
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (YYLabel *)contentLB {
    if (!_contentLB) {
        _contentLB = YYLabel.new;
        _contentLB.numberOfLines = 0;
        _contentLB.preferredMaxLayoutWidth = self.contentLabelPreferredMaxLayoutWidth;
    }
    return _contentLB;
}

- (CGFloat)contentLabelPreferredMaxLayoutWidth {
    return kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding) - 2 * kSideMargin;
}
@end
