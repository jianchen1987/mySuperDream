//
//  WMStoreProductReviewView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductReviewView.h"
#import "SAGeneralUtil.h"
#import "SAInternationalizationModel.h"
#import "WMStoreProductCellStoreInfoView.h"
#import "WMStoreProductMerchantReplyView.h"
#import "WMStoreProductReviewTagView.h"
#import "WMStoreReviewGoodsModel.h"
#import <YYText/YYText.h>

#define kHeadImageWidth kRealWidth(40)
#define kMarginIconToNameLabel kRealWidth(10)


@interface WMStoreProductReviewView ()
/// 头像
@property (nonatomic, strong) UIImageView *iconImageView;
/// 名称
@property (nonatomic, strong) SALabel *nameLabel;
/// 日期
@property (nonatomic, strong) SALabel *dateLabel;
/// 评论内容
@property (nonatomic, strong) YYLabel *contentLabel;
/// 查看全部图片
@property (nonatomic, strong) HDUIGhostButton *imageCountButton;
/// 星星评分标题
@property (nonatomic, strong) SALabel *ratingScoreTitleLB;
/// 星星评分
@property (nonatomic, strong) HDRatingStarView *starRatingView;
/// 点赞、踩按钮
@property (nonatomic, strong) HDUIButton *likeBTN;
/// 配送评价
@property (nonatomic, strong) SALabel *deliveryStatusLabel;
/// 图片容器
@property (nonatomic, strong) UIView *imageContainer;
/// 标签信息
@property (nonatomic, strong) WMStoreProductReviewTagView *tagView;
/// 商家回复
@property (nonatomic, strong) WMStoreProductMerchantReplyView *merchantReplyView;
/// 门店信息
@property (nonatomic, strong) WMStoreProductCellStoreInfoView *storeInfoView;
/// 底部线
@property (nonatomic, strong) UIView *bottomLine;
/// 文字最宽宽度
@property (nonatomic, assign, readonly) CGFloat contentLabelPreferredMaxLayoutWidth;
@end


@implementation WMStoreProductReviewView

#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;

    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.dateLabel];
    [self addSubview:self.ratingScoreTitleLB];
    [self addSubview:self.starRatingView];
    [self addSubview:self.likeBTN];
    [self addSubview:self.deliveryStatusLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.imageContainer];
    [self addSubview:self.imageCountButton];
    [self addSubview:self.tagView];
    [self addSubview:self.merchantReplyView];
    [self addSubview:self.storeInfoView];
    [self addSubview:self.bottomLine];

    self.iconImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:5.f borderWidth:PixelOne borderColor:HDAppTheme.color.G4];
    };

    @HDWeakify(self);
    self.clickedUserReviewContentReadMoreOrReadLessBlock = ^{
        @HDStrongify(self);
        !self.clickedUserReviewContentReadMoreOrReadLessBlock ?: self.clickedUserReviewContentReadMoreOrReadLessBlock();
    };
    self.merchantReplyView.clickedReadMoreOrReadLessBlock = ^{
        @HDStrongify(self);
        !self.clickedMerchantReplyReadMoreOrReadLessBlock ?: self.clickedMerchantReplyReadMoreOrReadLessBlock();
    };
}

- (void)hd_bindViewModel {
}

#pragma mark - setter
- (void)setModel:(WMStoreProductReviewModel *)model {
    _model = model;

    switch (model.cellType) {
        case WMStoreProductReviewCellTypeProductDetail: {
            model.merchantReplyMaxRowCount = 3;
            model.numberOfLinesOfMerchantReplyLabel = 3;
            model.contentMaxRowCount = 3;
            model.numberOfLinesOfReviewContentLabel = 0;
            self.likeBTN.hidden = NO;
            self.starRatingView.hidden = self.ratingScoreTitleLB.hidden = YES;
            self.deliveryStatusLabel.hidden = YES;
        } break;
        case WMStoreProductReviewCellTypeAllReviews: {
            model.merchantReplyMaxRowCount = 3;
            model.numberOfLinesOfMerchantReplyLabel = 3;
            model.contentMaxRowCount = 3;
            model.numberOfLinesOfReviewContentLabel = 0;
            self.likeBTN.hidden = NO;
            self.starRatingView.hidden = self.ratingScoreTitleLB.hidden = YES;
            self.deliveryStatusLabel.hidden = YES;
        } break;
        case WMStoreProductReviewCellTypeStoreReview: {
            model.merchantReplyMaxRowCount = 3;
            model.contentMaxRowCount = 3;
            model.numberOfLinesOfMerchantReplyLabel = 3;
            model.numberOfLinesOfReviewContentLabel = 0;
            self.starRatingView.hidden = self.ratingScoreTitleLB.hidden = NO;
            self.likeBTN.hidden = YES;
            self.deliveryStatusLabel.hidden = YES;
        } break;
        case WMStoreProductReviewCellTypeMyReview: {
            model.merchantReplyMaxRowCount = 3;
            model.contentMaxRowCount = 3;
            self.likeBTN.hidden = YES;
            self.starRatingView.hidden = self.ratingScoreTitleLB.hidden = NO;
            self.deliveryStatusLabel.hidden = NO;
        } break;
        default:
            break;
    }

    WMReviewPraiseHateState likeState = model.dislike;
    self.likeBTN.hidden = likeState != WMReviewPraiseHateStateLike && likeState != WMReviewPraiseHateStateUnlike;
    if (!self.likeBTN.isHidden) {
        if (likeState == WMReviewPraiseHateStateUnlike) {
            [self.likeBTN setTitle:WMLocalizedString(@"store_unlike_it", @"Unlike it") forState:UIControlStateNormal];
            [self.likeBTN setImage:[UIImage imageNamed:@"product_reviews_unlike"] forState:UIControlStateNormal];
        } else {
            [self.likeBTN setTitle:WMLocalizedString(@"store_like_it", @"Like it") forState:UIControlStateNormal];
            [self.likeBTN setImage:[UIImage imageNamed:@"product_reviews_like"] forState:UIControlStateNormal];
        }
    }

    [HDWebImageManager setImageWithURL:model.head placeholderImage:[UIImage imageNamed:@"neutral"] imageView:self.iconImageView];

    self.nameLabel.text = model.nickName ?: @" ";
    self.nameLabel.textColor = HDAppTheme.color.G2;
    self.nameLabel.numberOfLines = model.numberOfLinesOfNameLabel;

    self.dateLabel.text = [SAGeneralUtil getDateStrWithTimeInterval:model.createTime / 1000.0 format:@"dd/MM/yyyy"];

    self.starRatingView.score = model.score;
    self.deliveryStatusLabel.text = [NSString stringWithFormat:@"%@%@", WMLocalizedString(@"store_delivery_service", @"Delivery:"), model.deliveryScoreStr];

    [self updateReviewContentLBText];
    self.imageContainer.hidden = HDIsArrayEmpty(model.imageUrls);
    if (!self.imageContainer.isHidden) {
        [self.imageContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIImage *placeholderImage = [HDHelper placeholderImageWithSize:CGSizeMake(95, 95)];
        for (NSUInteger i = 0; i < model.imageUrls.count; i++) {
            if (model.maxShowImageCount != 0 && i >= model.maxShowImageCount)
                break;
            NSString *url = model.imageUrls[i];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = true;
            imageView.userInteractionEnabled = true;
            imageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
                [view setRoundedCorners:UIRectCornerAllCorners radius:3.0];
            };
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageHandler:)];
            [imageView addGestureRecognizer:recognizer];
            [HDWebImageManager setImageWithURL:url placeholderImage:placeholderImage imageView:imageView];
            imageView.hd_associatedObject = [NSNumber numberWithInteger:i];
            [self.imageContainer addSubview:imageView];
        }
    }
    [self.imageContainer.subviews sa_distributeSudokuViewsWithFixedItemWidth:kRealWidth(95) fixedItemHeight:kRealWidth(95) fixedLineSpacing:8 fixedInteritemSpacing:8 columnCount:3 heightToWidthScale:1
                                                                  topSpacing:0
                                                               bottomSpacing:0
                                                                 leadSpacing:0
                                                                 tailSpacing:0];

    self.imageCountButton.hidden = model.imageUrls.count <= model.maxShowImageCount;
    if (!self.imageCountButton.isHidden) {
        [self.imageCountButton setTitle:[NSString stringWithFormat:@"3/%zd", self.model.imageUrls.count] forState:UIControlStateNormal];
    }

    self.storeInfoView.hidden = model.cellType != WMStoreProductReviewCellTypeMyReview || HDIsObjectNil(self.model.storeInfo);
    if (!self.storeInfoView.isHidden) {
        [self.storeInfoView updateStoreImageWithImageURL:model.storeInfo.logo storeName:model.storeInfo.storeName storeDesc:[model.storeInfo.businessScopes componentsJoinedByString:@","]];
    }
    NSArray<WMStoreProductReviewTagModel *> *tags = [self.model.itemBasicInfoRespDTOS mapObjectsUsingBlock:^id _Nonnull(WMStoreReviewGoodsModel *_Nonnull obj, NSUInteger idx) {
        if (obj.disLike == WMStoreReviewGoodsStatusLike) {
            WMStoreProductReviewTagModel *model = WMStoreProductReviewTagModel.new;
            model.title = obj.goodName.desc;
            model.tagId = obj.itemId;
            return model;
        }
        return nil;
    }];
    self.tagView.hidden = model.cellType == WMStoreProductReviewCellTypeProductDetail || model.cellType == WMStoreProductReviewCellTypeAllReviews || HDIsArrayEmpty(tags);

    if (!self.tagView.isHidden) {
        [self.tagView setTags:tags];
    }

    self.merchantReplyView.hidden = HDIsArrayEmpty(model.replys) || HDIsStringEmpty(model.replys.firstObject.content);
    if (!self.merchantReplyView.isHidden) {
        WMReviewMerchantReplyModel *replyModel = model.replys.firstObject;
        [self.merchantReplyView updateMerchantReply:replyModel.content isMerchantReplyExpanded:model.isMerchantReplyExpanded showReadMoreMaxRowCount:model.merchantReplyMaxRowCount
                                      numberOfLines:model.numberOfLinesOfMerchantReplyLabel];
    }
    self.bottomLine.hidden = self.model.needHideBottomLine;

    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickedImageHandler:(UITapGestureRecognizer *)recognizer {
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (imageView && [imageView isKindOfClass:UIImageView.class]) {
        NSInteger index = ((NSNumber *)(imageView.hd_associatedObject)).integerValue;
        [self showImageBrowserWithInitialProjectiveView:imageView index:index];
    }
}

- (void)clickedImageCountButtonHandler {
    UIImageView *imageView = (UIImageView *)self.imageContainer.subviews.lastObject;
    if (imageView && [imageView isKindOfClass:UIImageView.class]) {
        NSInteger index = ((NSNumber *)(imageView.hd_associatedObject)).integerValue;
        [self showImageBrowserWithInitialProjectiveView:imageView index:index];
    }
}

- (void)clickedStoreInfoHandler {
    if(self.clickedStoreInfoBlock) {
        self.clickedStoreInfoBlock(self.model.storeNo);
    }
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
//    params[@"storeNo"] = self.model.storeNo;
//    [HDMediator.sharedInstance navigaveToStoreDetailViewController:params];
}

#pragma mark - public methods

#pragma mark - private methods
/// 展示图片浏览器
/// @param projectiveView 默认投影 View
/// @param index 默认起始索引
- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView index:(NSUInteger)index {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];

    for (NSString *url in self.model.imageUrls) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:url];
        // 这里固定只是从此处开始投影，滑动时会更新投影控件
        data.projectiveView = projectiveView;
        [datas addObject:data];
    }

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = index;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);
    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    toolViewHandler.sourceView = self.imageContainer;
    toolViewHandler.saveImageResultBlock = ^(UIImage *_Nonnull image, NSError *_Nullable error) {
        if (error != NULL) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_failed", @"图片保存失败") type:HDTopToastTypeError];
        } else {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_success", @"图片保存成功") type:HDTopToastTypeSuccess];
        }
    };
    toolViewHandler.updateProjectiveViewBlock = ^UIView *_Nonnull(NSUInteger index) {
        return index < self.imageContainer.subviews.count ? self.imageContainer.subviews[index] : self.imageContainer.subviews.lastObject;
    };
    browser.toolViewHandlers = @[toolViewHandler];
    [browser show];
}

- (void)updateReviewContentLBText {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSAttributedString *appendingStr = [[NSMutableAttributedString alloc] initWithString:HDIsStringNotEmpty(self.model.content) ? self.model.content : @""
                                                                              attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard3}];

    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.contentLabelPreferredMaxLayoutWidth, CGFLOAT_MAX) text:appendingStr];
    NSUInteger maxRowCount = self.model.contentMaxRowCount;
    BOOL isUserReviewContentExpanded = self.model.isUserReviewContentExpanded;
    if (maxRowCount > 0 && textLayout.rowCount > maxRowCount) {
        if (isUserReviewContentExpanded) {
            [text appendAttributedString:appendingStr];
            // 查看更少
            NSAttributedString *readLessStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"read_less", @"收起")
                                                                                     attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed, NSFontAttributeName: HDAppTheme.font.standard3}];
            [text appendAttributedString:readLessStr];

            @HDWeakify(self);
            [text yy_setTextHighlightRange:NSMakeRange(appendingStr.length, text.length - appendingStr.length) color:HDAppTheme.color.C1 backgroundColor:UIColor.clearColor
                                 tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                     @HDStrongify(self);
                                     !self.clickedUserReviewContentReadMoreOrReadLessBlock ?: self.clickedUserReviewContentReadMoreOrReadLessBlock();
                                 }];
        } else {
            // 查看更多
            NSAttributedString *readMoreStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"read_more", @"展开")
                                                                                     attributes:@{NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed, NSFontAttributeName: HDAppTheme.font.standard3}];
            // 省略号
            NSAttributedString *rellipsisStr =
                [[NSMutableAttributedString alloc] initWithString:@" ... " attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard3}];

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

                YYTextLayout *newTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.contentLabelPreferredMaxLayoutWidth, CGFLOAT_MAX) text:newText];
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
        self.contentLabel.numberOfLines = self.model.numberOfLinesOfReviewContentLabel;
        if (appendingStr) {
            [text appendAttributedString:appendingStr];
        }
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = [SAMultiLanguageManager isCurrentLanguageCN] ? 9 : 7.2;
    NSRange range = NSMakeRange(0, [text length]);
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];

    self.contentLabel.attributedText = text;
}

#pragma mark - layout
- (void)updateConstraints {
    const CGFloat iconViewTop = kRealWidth(15);
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kHeadImageWidth, kHeadImageWidth));
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.top.equalTo(self).offset(iconViewTop);
    }];

    [self.dateLabel sizeToFit];
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        if (self.nameLabel.text.length > 0) {
            NSString *firstStr = [self.nameLabel.text substringWithRange:NSMakeRange(0, 1)];
            CGSize firstStrSize = [firstStr boundingAllRectWithSize:CGSizeMake(MAXFLOAT, 4) font:self.nameLabel.font];
            make.top.equalTo(self.nameLabel).offset((firstStrSize.height - CGRectGetHeight(self.dateLabel.bounds)) * 0.5);
        } else {
            make.top.equalTo(self.nameLabel);
        }
        make.size.mas_equalTo(self.dateLabel.size);
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(15));
        make.left.equalTo(self.iconImageView.mas_right).offset(kMarginIconToNameLabel);
        make.right.lessThanOrEqualTo(self.dateLabel.mas_left).offset(-5);
    }];

    [self.ratingScoreTitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.ratingScoreTitleLB.isHidden) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(6));
        }
    }];

    [self.starRatingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.starRatingView.isHidden) {
            make.left.equalTo(self.ratingScoreTitleLB.mas_right).offset(kRealWidth(2));
            make.centerY.equalTo(self.ratingScoreTitleLB.mas_centerY);
            make.size.mas_equalTo([self.starRatingView sizeThatFits:CGSizeMake(CGFLOAT_MAX, 0)]);
        }
    }];

    [self.likeBTN sizeToFit];
    [self.likeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.likeBTN.isHidden) {
            make.size.mas_equalTo(self.likeBTN.bounds.size);
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(6));
        }
    }];

    [self.deliveryStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deliveryStatusLabel.isHidden) {
            make.left.equalTo(self.starRatingView.mas_right).offset(kRealWidth(10));
            make.centerY.equalTo(self.starRatingView.mas_centerY);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        }
    }];

    self.contentLabel.preferredMaxLayoutWidth = self.contentLabelPreferredMaxLayoutWidth;
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        UIView *view = self.starRatingView.isHidden ? self.nameLabel : self.starRatingView;
        if (self.starRatingView.isHidden) {
            if (self.likeBTN.isHidden) {
                view = self.nameLabel;
            } else {
                view = self.likeBTN;
            }
        } else {
            view = self.starRatingView;
        }
        make.top.equalTo(view.mas_bottom).offset(kRealWidth(15));
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        if (self.storeInfoView.isHidden && self.merchantReplyView.isHidden && self.tagView.isHidden && self.imageContainer.isHidden) {
            make.bottom.equalTo(self).offset(-kRealWidth(15));
        }
    }];

    [self.imageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.imageContainer.isHidden) {
            UIView *view = self.contentLabel.isHidden ? self.starRatingView : self.contentLabel;
            view = view.isHidden ? self.nameLabel : view;
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(10));
            make.left.equalTo(self.contentLabel);
            make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
            if (self.storeInfoView.isHidden && self.merchantReplyView.isHidden && self.tagView.isHidden) {
                make.bottom.equalTo(self).offset(-kRealWidth(20));
            }
        }
    }];

    [self.imageCountButton sizeToFit];
    [self.imageCountButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.imageCountButton.isHidden) {
            make.right.equalTo(self.imageContainer).offset(-kRealWidth(10));
            make.bottom.equalTo(self.imageContainer).offset(-kRealWidth(8));
        }
    }];

    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.tagView.isHidden) {
            UIView *view = self.imageContainer.isHidden ? self.contentLabel : self.imageContainer;
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(15));
            make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
            if (self.storeInfoView.isHidden && self.merchantReplyView.isHidden) {
                make.bottom.equalTo(self).offset(-kRealWidth(20));
            }
        }
    }];

    [self.merchantReplyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.merchantReplyView.isHidden) {
            UIView *view = self.tagView.isHidden ? self.imageContainer : self.tagView;
            view = view.isHidden ? self.contentLabel : view;
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(15));
            make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
            if (self.storeInfoView.isHidden) {
                make.bottom.equalTo(self).offset(-kRealWidth(20));
            }
        }
    }];

    [self.storeInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeInfoView.isHidden) {
            UIView *view = self.merchantReplyView.isHidden ? self.tagView : self.merchantReplyView;
            view = view.isHidden ? self.imageContainer : view;
            view = view.isHidden ? self.contentLabel : view;
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(10));
            make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
            make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
            make.bottom.equalTo(self).offset(-kRealWidth(20));
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(PixelOne);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = UIImageView.new;
        _iconImageView.image = [UIImage imageNamed:@"neutral"];
        //        _iconImageView.layer.borderWidth = PixelOne;
        //        _iconImageView.layer.borderColor = HDAppTheme.color.G4.CGColor;
    }
    return _iconImageView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            SALabel *label = SALabel.new;
            label.font = HDAppTheme.font.standard3;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label;
        });
    }
    return _nameLabel;
}

- (SALabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = ({
            SALabel *label = SALabel.new;
            label.textColor = HDAppTheme.color.G3;
            label.font = HDAppTheme.font.standard4;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label;
        });
    }
    return _dateLabel;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = ({
            YYLabel *label = YYLabel.new;
            label.numberOfLines = 0;
            label;
        });
    }
    return _contentLabel;
}

- (SALabel *)ratingScoreTitleLB {
    if (!_ratingScoreTitleLB) {
        _ratingScoreTitleLB = [[SALabel alloc] init];
        _ratingScoreTitleLB.textColor = HDAppTheme.color.G3;
        _ratingScoreTitleLB.font = HDAppTheme.font.standard4;
        _ratingScoreTitleLB.text = WMLocalizedString(@"store_rating", @"Rating:");
    }
    return _ratingScoreTitleLB;
}

- (HDRatingStarView *)starRatingView {
    if (!_starRatingView) {
        _starRatingView = [[HDRatingStarView alloc] init];
        _starRatingView.allowTouchToSelectScore = false;
        _starRatingView.renderColors = @[HDAppTheme.WMColor.mainRed];
        _starRatingView.shouldFixScore = true;
        _starRatingView.starWidth = kRealWidth(10);
        _starRatingView.starImage = [UIImage imageNamed:@"starUnselected"];
    }
    return _starRatingView;
}

- (HDUIButton *)likeBTN {
    if (!_likeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = HDAppTheme.font.standard4;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _likeBTN = button;
    }
    return _likeBTN;
}

- (SALabel *)deliveryStatusLabel {
    if (!_deliveryStatusLabel) {
        _deliveryStatusLabel = [[SALabel alloc] init];
        _deliveryStatusLabel.textColor = HDAppTheme.color.G2;
        _deliveryStatusLabel.font = HDAppTheme.font.standard4;
    }
    return _deliveryStatusLabel;
}

- (UIView *)imageContainer {
    if (!_imageContainer) {
        _imageContainer = [[UIView alloc] init];
    }
    return _imageContainer;
}

- (HDUIGhostButton *)imageCountButton {
    if (!_imageCountButton) {
        _imageCountButton = [HDUIGhostButton buttonWithType:UIButtonTypeCustom];
        _imageCountButton.titleEdgeInsets = UIEdgeInsetsMake(3, 8, 3, 8);
        _imageCountButton.spacingBetweenImageAndTitle = 5;
        _imageCountButton.backgroundColor = [HexColor(0x000000) colorWithAlphaComponent:0.5];
        [_imageCountButton setImage:[UIImage imageNamed:@"image_count"] forState:UIControlStateNormal];
        [_imageCountButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _imageCountButton.titleLabel.font = HDAppTheme.font.standard4;
        [_imageCountButton addTarget:self action:@selector(clickedImageCountButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        _imageCountButton.alpha = 0.8;
    }
    return _imageCountButton;
}

- (WMStoreProductCellStoreInfoView *)storeInfoView {
    if (!_storeInfoView) {
        _storeInfoView = WMStoreProductCellStoreInfoView.new;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreInfoHandler)];
        [_storeInfoView addGestureRecognizer:recognizer];
    }
    return _storeInfoView;
}

- (WMStoreProductMerchantReplyView *)merchantReplyView {
    if (!_merchantReplyView) {
        _merchantReplyView = WMStoreProductMerchantReplyView.new;
    }
    return _merchantReplyView;
}

- (WMStoreProductReviewTagView *)tagView {
    if (!_tagView) {
        _tagView = [[WMStoreProductReviewTagView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding), 0)];
        _tagView.iconName = @"food_like_normal";
        _tagView.font = HDAppTheme.font.standard4;
        @HDWeakify(self);
        _tagView.clickedTagButtonBlock = ^(HDUIGhostButton *_Nonnull buton, WMStoreProductReviewTagModel *_Nonnull tag) {
            if (tag) {
                @HDStrongify(self);
                if (self.clickedProductItemBlock) {
                    self.clickedProductItemBlock(tag.tagId, self.model.storeNo);
                }
            }
        };
    }
    return _tagView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor hd_colorWithHexString:@"#EBEDF0"];
    }
    return _bottomLine;
}

- (CGFloat)contentLabelPreferredMaxLayoutWidth {
    CGFloat width = kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
    if (self.model.cellType == WMStoreProductReviewCellTypeProductDetail) {
        width -= (kMarginIconToNameLabel + kHeadImageWidth);
    }
    return width;
}
@end
