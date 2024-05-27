//
//  TNGoodReviewListCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNGoodReviewCell.h"
#import <YYText/YYText.h>
#import "HDAppTheme+TinhNow.h"
#import "TNReviewImageView.h"
#import "TNReviewGoodItemView.h"
#import "NSString+SA_Extension.h"
#define contentLabelMaxLaoutWidth kScreenWidth - kRealWidth(80)
#define contentShowMaxRow 3 //三行后 显示展开


@interface TNGoodReviewCell ()
/// 头像
@property (strong, nonatomic) UIImageView *headerImageView;
/// 名字
@property (strong, nonatomic) HDLabel *nameLabel;
/// 时间
@property (strong, nonatomic) HDLabel *timeLabel;
/// 星星评分
@property (nonatomic, strong) HDRatingStarView *starRatingView;
/// 评论内容
@property (strong, nonatomic) YYLabel *contentLabel;
/// 评论图片视图
@property (strong, nonatomic) TNReviewImageView *reviewImageView;
/// 商家回复视图
@property (strong, nonatomic) HDLabel *merchantReplyLabel;
/// 商品视图  只有我的评价页面展示
@property (strong, nonatomic) TNReviewGoodItemView *goodView;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
@end


@implementation TNGoodReviewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.starRatingView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.reviewImageView];
    [self.contentView addSubview:self.merchantReplyLabel];
    [self.contentView addSubview:self.goodView];
    [self.contentView addSubview:self.lineView];
}
- (void)updateConstraints {
    [self.headerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(kRealWidth(10));
        make.top.equalTo(self.headerImageView.mas_top);
        make.right.equalTo(self.starRatingView.mas_left).offset(kRealWidth(10));
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(kRealWidth(10));
        make.bottom.equalTo(self.headerImageView.mas_bottom);
    }];
    [self.starRatingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo([self.starRatingView sizeThatFits:CGSizeMake(CGFLOAT_MAX, 0)]);
    }];
    self.contentLabel.preferredMaxLayoutWidth = contentLabelMaxLaoutWidth;
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(kRealWidth(10));
        make.left.equalTo(self.headerImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    if (!self.reviewImageView.isHidden) {
        [self.reviewImageView sizeToFit];
        [self.reviewImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(kRealWidth(8));
            make.left.equalTo(self.headerImageView.mas_right).offset(kRealWidth(10));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }
    if (!self.merchantReplyLabel.isHidden) {
        [self.merchantReplyLabel sizeToFit];
        [self.merchantReplyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            if (!self.reviewImageView.isHidden) {
                make.top.equalTo(self.reviewImageView.mas_bottom).offset(kRealWidth(8));
            } else {
                make.top.equalTo(self.contentLabel.mas_bottom).offset(kRealWidth(8));
            }
        }];
    }
    //我的评价页面  没有展示商家回复  所以merchantReplyLabel  和 goodView只会出现其一
    if (!self.goodView.isHidden) {
        [self.goodView sizeToFit];
        [self.goodView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImageView.mas_right).offset(kRealWidth(10));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            if (!self.reviewImageView.isHidden) {
                make.top.equalTo(self.reviewImageView.mas_bottom).offset(kRealWidth(8));
            } else {
                make.top.equalTo(self.contentLabel.mas_bottom).offset(kRealWidth(8));
            }
        }];
    }
    UIView *topView;
    if (self.model.isFromMyReview) {
        topView = self.goodView;
    } else {
        topView = self.merchantReplyLabel.isHidden ? self.reviewImageView : self.merchantReplyLabel;
        if (topView == self.reviewImageView && self.reviewImageView.isHidden) {
            topView = self.contentLabel;
        }
    }
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(0.5);
        make.top.equalTo(topView.mas_bottom).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView);
    }];

    [super updateConstraints];
}
- (void)setModel:(TNProductReviewModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.head placeholderImage:[UIImage imageNamed:@"neutral"] imageView:self.headerImageView];
    if (model.anonymous && HDIsStringNotEmpty(model.username)) {
        self.nameLabel.text = [model.username SA_desensitize];
    } else {
        self.nameLabel.text = model.username;
    }

    self.timeLabel.text = [SAGeneralUtil getDateStrWithTimeInterval:model.createdDate / 1000.0 format:@"dd/MM/yyyy"];
    self.starRatingView.score = [model.itemScore floatValue];
    //设置评论文本内容
    [self updateReviewContentLBText];
    if (!HDIsArrayEmpty(model.images)) {
        self.reviewImageView.hidden = NO;
        self.reviewImageView.images = model.images;
    } else {
        self.reviewImageView.hidden = YES;
        self.reviewImageView.images = @[];
    }

    if (model.isFromMyReview) {
        self.merchantReplyLabel.hidden = YES;
        self.goodView.hidden = NO;
        self.goodView.model = model;
    } else {
        self.goodView.hidden = YES;
        if (!HDIsArrayEmpty(model.replys)) {
            self.merchantReplyLabel.hidden = NO;
            TNReviewMerchantReplyModel *replyModel = model.replys.firstObject;
            self.merchantReplyLabel.text = [NSString stringWithFormat:@"%@：%@", TNLocalizedString(@"tn_seller_reply_k", @"商家回复"), replyModel.content];
        } else {
            self.merchantReplyLabel.hidden = YES;
        }
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateReviewContentLBText {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSAttributedString *appendingStr =
        [[NSMutableAttributedString alloc] initWithString:HDIsStringNotEmpty(self.model.content) ? self.model.content : @""
                                               attributes:@{NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G2, NSFontAttributeName: HDAppTheme.TinhNowFont.standard15}];

    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(contentLabelMaxLaoutWidth, CGFLOAT_MAX) text:appendingStr];
    NSUInteger maxRowCount = contentShowMaxRow;
    BOOL isUserReviewContentExpanded = self.model.isExtend;
    if (maxRowCount > 0 && textLayout.rowCount > maxRowCount) {
        if (isUserReviewContentExpanded) {
            [text appendAttributedString:appendingStr];
            // 查看更少
            NSAttributedString *readLessStr =
                [[NSMutableAttributedString alloc] initWithString:TNLocalizedString(@"tn_store_less", @"收起")
                                                       attributes:@{NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.C1, NSFontAttributeName: HDAppTheme.TinhNowFont.standard15}];
            [text appendAttributedString:readLessStr];

            @HDWeakify(self);
            [text yy_setTextHighlightRange:NSMakeRange(appendingStr.length, text.length - appendingStr.length) color:HDAppTheme.color.C1 backgroundColor:UIColor.clearColor
                                 tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                     @HDStrongify(self);
                                     !self.clickedUserReviewContentReadMoreOrReadLessBlock ?: self.clickedUserReviewContentReadMoreOrReadLessBlock();
                                 }];
        } else {
            // 查看更多
            NSAttributedString *readMoreStr =
                [[NSMutableAttributedString alloc] initWithString:TNLocalizedString(@"tn_store_more", @"更多")
                                                       attributes:@{NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.C1, NSFontAttributeName: HDAppTheme.TinhNowFont.standard15}];
            // 省略号
            NSAttributedString *rellipsisStr =
                [[NSMutableAttributedString alloc] initWithString:@" ... "
                                                       attributes:@{NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G2, NSFontAttributeName: HDAppTheme.TinhNowFont.standard15}];

            // 获取前 maxRowCount 行内容
            YYTextLine *thirdLine = textLayout.lines[maxRowCount - 1];
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

                YYTextLayout *newTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(contentLabelMaxLaoutWidth, CGFLOAT_MAX) text:newText];
                isNewRowCountLessThanMaxRowCount = newTextLayout.rowCount <= maxRowCount;
                text = newText;
            }

            @HDWeakify(self);
            [text yy_setTextHighlightRange:NSMakeRange(strBeforeReadMore.length, text.length - strBeforeReadMore.length) color:HDAppTheme.color.C1 backgroundColor:UIColor.clearColor
                                 tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                     @HDStrongify(self);
                                     !self.clickedUserReviewContentReadMoreOrReadLessBlock ?: self.clickedUserReviewContentReadMoreOrReadLessBlock();
                                 }];
        }
    } else {
        self.contentLabel.numberOfLines = 0;
        if (appendingStr) {
            [text appendAttributedString:appendingStr];
        }
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    NSRange range = NSMakeRange(0, [text length]);
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];

    self.contentLabel.attributedText = text;
}
/** @lazy headerImageView */
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        _headerImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.width / 2];
        };
    }
    return _headerImageView;
}
/** @lazy nameLabel */
- (HDLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[HDLabel alloc] init];
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15;
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G2;
    }
    return _nameLabel;
}
/** @lazy timeLabel */
- (HDLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[HDLabel alloc] init];
        _timeLabel.font = HDAppTheme.TinhNowFont.standard12;
        _timeLabel.textColor = HDAppTheme.TinhNowColor.G3;
    }
    return _timeLabel;
}
- (HDRatingStarView *)starRatingView {
    if (!_starRatingView) {
        _starRatingView = [[HDRatingStarView alloc] init];
        _starRatingView.allowTouchToSelectScore = false;
        _starRatingView.renderColors = @[HDAppTheme.TinhNowColor.C1, HexColor(0xFFC95F)];
        _starRatingView.shouldFixScore = true;
        _starRatingView.starWidth = kRealWidth(15);
        _starRatingView.starImage = [UIImage imageNamed:@"starUnselected"];
    }
    return _starRatingView;
}
- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
/** @lazy reviewImageView */
- (TNReviewImageView *)reviewImageView {
    if (!_reviewImageView) {
        _reviewImageView = [[TNReviewImageView alloc] init];
    }
    return _reviewImageView;
}
/** @lazy merchantReplyLabel */
- (HDLabel *)merchantReplyLabel {
    if (!_merchantReplyLabel) {
        _merchantReplyLabel = [[HDLabel alloc] init];
        _merchantReplyLabel.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _merchantReplyLabel.font = HDAppTheme.TinhNowFont.standard15;
        _merchantReplyLabel.textColor = HDAppTheme.TinhNowColor.G2;
        _merchantReplyLabel.hd_edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        _merchantReplyLabel.numberOfLines = 0;
        _merchantReplyLabel.hd_lineSpace = 3;
        _merchantReplyLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:11];
        };
    }
    return _merchantReplyLabel;
}
/** @lazy goodView */
- (TNReviewGoodItemView *)goodView {
    if (!_goodView) {
        _goodView = [[TNReviewGoodItemView alloc] init];
        _goodView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _goodView.hidden = YES;
        _goodView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5];
        };
    }
    return _goodView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexColor(0xE1E1E1);
    }
    return _lineView;
}
@end
