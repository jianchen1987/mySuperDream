//
//  TNSubmitReviewCell.m
//  SuperApp
//
//  Created by xixi on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSubmitReviewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "HDRatingStarView.h"
#import "SAPhotoView.h"


@interface TNSubmitReviewCell () <HXPhotoViewDelegate, HDTextViewDelegate>
///
@property (nonatomic, strong) UIView *bgView;
/// 商品图片
@property (nonatomic, strong) UIImageView *goodsImgView;
/// 商品名称
@property (nonatomic, strong) UILabel *goodsNameLabel;
/// 发布点评
@property (nonatomic, strong) UILabel *scoreTitleLabel;
///
@property (nonatomic, strong) HDRatingStarView *startView;
/// 非常棒 - 分数对应描述
@property (nonatomic, strong) UILabel *scoreValueLabel;
///
@property (nonatomic, strong) UIView *contentBgView;
/// 输入框
@property (nonatomic, strong) HDTextView *textView;
/// 0/500
@property (nonatomic, strong) UILabel *textLengthLabel;
///
@property (nonatomic, strong) HXPhotoManager *manager;
///
@property (nonatomic, strong) SAPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;

/// 匿名评论
@property (nonatomic, strong) HDUIButton *anonymousBtn;
///
@property (nonatomic, assign) CGFloat cHeight;
@end


@implementation TNSubmitReviewCell

- (void)hd_setupViews {
    self.contentView.backgroundColor = HexColor(0xF5F7FA);

    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.goodsImgView];
    [self.bgView addSubview:self.goodsNameLabel];
    [self.bgView addSubview:self.scoreTitleLabel];
    [self.bgView addSubview:self.scoreValueLabel];
    [self.bgView addSubview:self.startView];
    [self.bgView addSubview:self.anonymousBtn];
    [self.bgView addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.textView];
    [self.contentBgView addSubview:self.textLengthLabel];
    [self.contentBgView addSubview:self.scrollView];
    [self.scrollView addSubview:self.photoView];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];

    [self.goodsImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(15.f);
        make.top.mas_equalTo(self.bgView.mas_top).offset(15.f);
        make.size.mas_equalTo(CGSizeMake(60.f, 60.f));
    }];

    [self.goodsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImgView.mas_right).offset(kRealWidth(10.f));
        make.top.mas_equalTo(self.goodsImgView.mas_top);
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15.f));
    }];

    [self.scoreTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15.f));
        make.top.mas_equalTo(self.goodsImgView.mas_bottom).offset(kRealWidth(25.f));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15.f));
    }];

    [self.scoreValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15.f));
        make.centerY.equalTo(self.startView);
        make.left.mas_equalTo(self.startView.mas_right).offset(kRealWidth(10.f));
    }];

    [self.startView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self.startView sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)]);
        make.left.mas_equalTo(self.scoreTitleLabel.mas_left);
        make.top.mas_equalTo(self.scoreTitleLabel.mas_bottom).offset(kRealWidth(10.f));
    }];

    [self.contentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15.f));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15.f));
        make.top.mas_equalTo(self.startView.mas_bottom).offset(kRealWidth(20.f));
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgView.mas_left).offset(kRealWidth(15.f));
        make.top.mas_equalTo(self.contentBgView.mas_top).offset(kRealWidth(15.f));
        make.right.mas_equalTo(self.contentBgView.mas_right).offset(kRealWidth(-15.f));
        make.height.equalTo(@(80.f));
    }];

    [self.textLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentBgView.mas_right).offset(kRealWidth(-15.f));
        make.top.mas_equalTo(self.textView.mas_bottom).offset(kRealWidth(10.f));
        make.left.mas_equalTo(self.contentBgView.mas_left).offset(kRealWidth(15.f));
    }];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgView.mas_left).offset(kRealWidth(15.f));
        make.right.mas_equalTo(self.contentBgView.mas_right).offset(kRealWidth(-15.f));
        make.top.equalTo(self.textLengthLabel.mas_bottom).offset(kRealWidth(15.f));
        make.bottom.mas_equalTo(self.contentBgView.mas_bottom).offset(kRealWidth(-15.f));
        make.height.equalTo(@(self.cHeight));
    }];

    [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.scrollView.mas_right);
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
        make.height.equalTo(@(self.cHeight));
        make.width.equalTo(@(self.scrollView.hd_width));
    }];

    [self.anonymousBtn sizeToFit];
    [self.anonymousBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.anonymousBtn.size);
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15.f));
        make.top.mas_equalTo(self.contentBgView.mas_bottom).offset(kRealWidth(15.f));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(-15.f));
    }];

    [super updateConstraints];
}

#pragma mark -
- (void)setModel:(TNSubmitReviewItemModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(60.f), kRealWidth(60.f))] imageView:self.goodsImgView];
    self.goodsNameLabel.text = model.name;
    self.startView.score = model.score;
    [self didAfterSelectScore:self.startView.score];
    self.anonymousBtn.selected = model.anonymous == 10 ? YES : NO;
    self.textView.text = model.content;

    [self setNeedsUpdateConstraints];
}

- (void)anonymousAction {
    self.anonymousBtn.selected = !self.anonymousBtn.selected;
    if (self.anonymousBtn.selected) {
        self.model.anonymous = 10;
    } else {
        self.model.anonymous = 11;
    }
}

#pragma mark - photo delegate
- (void)photoView:(HXPhotoView *)photoView
    changeComplete:(NSArray<HXPhotoModel *> *)allList
            photos:(NSArray<HXPhotoModel *> *)photos
            videos:(NSArray<HXPhotoModel *> *)videos
          original:(BOOL)isOriginal {
    NSArray *selectPhtotArray = photos;
    [selectPhtotArray enumerateObjectsUsingBlock:^(HXPhotoModel *_Nonnull model, NSUInteger idx, BOOL *_Nonnull stop) {
        CGSize size;
        if (isOriginal) {
            size = PHImageManagerMaximumSize;
        } else {
            size = CGSizeMake(model.imageSize.width * 0.8, model.imageSize.height * 0.8);
        }
        [model requestPreviewImageWithSize:size startRequestICloud:nil progressHandler:nil success:nil failed:nil];
    }];

    self.model.selectedPhotos = selectPhtotArray;
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame));
    self.cHeight = frame.size.height;

    if (self.reloadHander) {
        self.reloadHander();
    }
}

#pragma mark - HDTextView Delegate
#pragma mark - HDTextViewDelegate
- (void)textView:(HDTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    //    height = fmax(height, self.textViewMinimumHeight);
    //    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    //    if (needsChangeHeight) {
    //        // 实现自适应高度
    //        [self updateTextViewFrame];
    //    }
}

- (void)textView:(HDTextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [HDTips showError:[NSString stringWithFormat:SALocalizedString(@"text_not_longer_than", @"文字不能超过 %@ 个字符"), @(textView.maximumTextLength)] inView:self];
}

- (BOOL)textViewShouldReturn:(HDTextView *)textView {
    [self.textView resignFirstResponder];
    return NO;
}

- (void)textViewDidChange:(HDTextView *)textView {
    self.textLengthLabel.text = [NSString stringWithFormat:@"%zd/%zd", textView.text.length, textView.maximumTextLength];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.model.content = textView.text;
}

#pragma mark -
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.clipsToBounds = YES;
        _goodsImgView.layer.cornerRadius = 4.f;
        _goodsImgView.layer.borderColor = HDAppTheme.TinhNowColor.cADB6C8.CGColor;
        _goodsImgView.layer.borderWidth = PixelOne;
    }
    return _goodsImgView;
}

- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = [[UILabel alloc] init];
        _goodsNameLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _goodsNameLabel.font = [HDAppTheme.TinhNowFont fontRegular:15.f];
        _goodsNameLabel.numberOfLines = 2;
    }
    return _goodsNameLabel;
}

- (UILabel *)scoreTitleLabel {
    if (!_scoreTitleLabel) {
        _scoreTitleLabel = [[UILabel alloc] init];
        _scoreTitleLabel.text = TNLocalizedString(@"tn_post_review", @"发布点评");
        _scoreTitleLabel.textColor = HDAppTheme.TinhNowColor.c343B4D;
        _scoreTitleLabel.font = [HDAppTheme.TinhNowFont fontRegular:15.f];
    }
    return _scoreTitleLabel;
}

- (UILabel *)scoreValueLabel {
    if (!_scoreValueLabel) {
        _scoreValueLabel = [[UILabel alloc] init];
        _scoreValueLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
        _scoreValueLabel.font = [HDAppTheme.TinhNowFont fontRegular:15.f];
        _scoreValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _scoreValueLabel;
}

- (HDRatingStarView *)startView {
    if (!_startView) {
        _startView = [[HDRatingStarView alloc] init];
        _startView.starImage = [UIImage imageNamed:@"star_rating_level_1"];
        _startView.starWidth = 20;
        _startView.itemMargin = 8;
        _startView.renderColors = @[HDAppTheme.TinhNowColor.C1, HexColor(0xFFC95F)];
        _startView.countForOneStar = 1;
        _startView.score = 5;
        _startView.allowSlideToChangeScore = NO;
        @HDWeakify(self);
        _startView.selectScoreHandler = ^(CGFloat score) {
            @HDStrongify(self);
            self.model.score = (NSInteger)score;
            [self didAfterSelectScore:score];
        };
    }
    return _startView;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] init];
        _contentBgView.layer.cornerRadius = 8.f;
        _contentBgView.backgroundColor = HexColor(0xF5F7FA);
    }
    return _contentBgView;
}

- (HDUIButton *)anonymousBtn {
    if (!_anonymousBtn) {
        _anonymousBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_anonymousBtn setImage:[UIImage imageNamed:@"tinhnow-selected"] forState:UIControlStateSelected];
        [_anonymousBtn setImage:[UIImage imageNamed:@"tinhnow-unSelected"] forState:UIControlStateNormal];
        [_anonymousBtn setTitle:TNLocalizedString(@"tn_Anonymousreview", @"匿名评价") forState:UIControlStateNormal];
        _anonymousBtn.imagePosition = HDUIButtonImagePositionLeft;
        _anonymousBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
        [_anonymousBtn setTitleColor:HDAppTheme.TinhNowColor.c343B4D forState:UIControlStateNormal];
        _anonymousBtn.spacingBetweenImageAndTitle = 10.f;
        @HDWeakify(self);
        [_anonymousBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self anonymousAction];
        }];
    }
    return _anonymousBtn;
}

- (HDTextView *)textView {
    if (!_textView) {
        _textView = HDTextView.new;
        _textView.placeholder = TNLocalizedString(@"tn_postreview_say", @" 说点什么吧 ，比如商品的质量如何、性价比等");
        _textView.placeholderColor = HDAppTheme.color.G3;
        _textView.font = HDAppTheme.font.standard3;
        _textView.textColor = HDAppTheme.color.G1;
        _textView.delegate = self;
        _textView.maximumTextLength = 500;
        _textView.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
        _textView.layer.cornerRadius = 4.f;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}

- (UILabel *)textLengthLabel {
    if (!_textLengthLabel) {
        _textLengthLabel = [[UILabel alloc] init];
        _textLengthLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _textLengthLabel.font = [HDAppTheme.TinhNowFont fontRegular:12.f];
        _textLengthLabel.textAlignment = NSTextAlignmentRight;
        _textLengthLabel.text = [NSString stringWithFormat:@"0/%zd", self.textView.maximumTextLength];
    }
    return _textLengthLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15.f, 128.f, kScreenWidth - 30.f, 100.f)];
    }
    return _scrollView;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoMaxNum = 5;
        _manager.configuration.maxNum = 5;
    }
    return _manager;
}

- (SAPhotoView *)photoView {
    if (!_photoView) {
        _photoView = [SAPhotoView photoManager:self.manager addViewBackgroundColor:[UIColor whiteColor]];
        _photoView.delegate = self;
        _photoView.width = self.scrollView.hd_width;
    }
    return _photoView;
}

#pragma mark - tool
- (void)didAfterSelectScore:(CGFloat)score {
    NSInteger scoreInt = score;
    switch (scoreInt) {
        case 1: {
            self.scoreValueLabel.text = TNLocalizedString(@"tn_score_veryBad", @"糟透了");
        } break;
        case 2: {
            self.scoreValueLabel.text = TNLocalizedString(@"tn_score_bad", @"差");
        } break;
        case 3: {
            self.scoreValueLabel.text = TNLocalizedString(@"tn_score_Okay", @" 一般");
        } break;
        case 4: {
            self.scoreValueLabel.text = TNLocalizedString(@"tn_score_veryGood", @"很好");
        } break;
        case 5: {
            self.scoreValueLabel.text = TNLocalizedString(@"tn_score_Excellent", @"非常棒");
        } break;
        default:
            break;
    }
}
@end
