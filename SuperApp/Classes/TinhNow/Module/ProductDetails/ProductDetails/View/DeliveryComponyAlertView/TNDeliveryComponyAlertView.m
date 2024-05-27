//
//  DeliveryComponyAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2023/7/18.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "TNDeliveryComponyAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>
#import "TNView.h"

@interface TNDeliveryContentView : TNView <HDCategoryListContentViewDelegate>
/// 内容
@property (nonatomic, copy) NSString *content;
/// 标题
/// 文本展示
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UILabel *noDataLabel;

- (instancetype)initWithContent:(NSString *)content;
@end

@implementation TNDeliveryContentView
- (instancetype)initWithContent:(NSString *)content {
    self.content = content;
    if (HDIsStringNotEmpty(content)) {
        self.contentTextView.hidden = NO;
        self.noDataLabel.hidden = YES;
    } else {
        self.contentTextView.hidden = YES;
        self.noDataLabel.hidden = NO;
    }
    return [super init];
}
- (void)hd_setupViews {
    [self addSubview:self.contentTextView];
    [self addSubview:self.noDataLabel];
}
- (void)updateConstraints {
    if (!self.contentTextView.isHidden) {
        [self.contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    if (!self.noDataLabel.isHidden) {
        [self.noDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }

    [super updateConstraints];
}

/** @lazy noDataLabel */
- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.numberOfLines = 0;
        _noDataLabel.text = TNLocalizedString(@"tn_no_des", @"暂无说明");
        _noDataLabel.font = HDAppTheme.TinhNowFont.standard12;
        _noDataLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataLabel;
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
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}
@end


@interface TNDeliveryComponyAlertView () <HDCategoryViewDelegate, HDCategoryListContainerViewDelegate, HDCategoryTitleViewDataSource>
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 确认按钮
@property (strong, nonatomic) SAOperationButton *doneBtn;
/// 文本展示
//@property (strong, nonatomic) UITextView *contentTextView;
/// 数据源
@property (nonatomic, strong) NSArray<TNDeliveryComponyModel *> *list;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 标题滚动 View
@property (nonatomic, strong) HDCategoryTitleView *categoryTitleView;
/// 标题滚动关联的列表容器
@property (nonatomic, strong) HDCategoryListContainerView *listContainerView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) BOOL showTitle;
@end


@implementation TNDeliveryComponyAlertView
- (instancetype)initWithTitle:(NSString *)title list:(NSArray<TNDeliveryComponyModel *> *)deliveryList showTitle:(BOOL)showTitle {
    self = [super init];
    if (self) {
        self.title = title;
        self.list = deliveryList;
        self.showTitle = showTitle;
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
    if (self.showTitle) {
        [self.containerView addSubview:self.categoryTitleView];
        [self.containerView addSubview:self.lineView];
    }
    [self.containerView addSubview:self.listContainerView];
    [self.containerView addSubview:self.doneBtn];
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    //    CGFloat height = [self.contentTextView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth - kRealWidth(30), MAXFLOAT)].height;
    //    if (height > kScreenHeight * 0.7) {
    //        height = kScreenHeight * 0.7;
    //        self.contentTextView.scrollEnabled = YES;
    //    }
    if (self.showTitle) {
        [self.categoryTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.mas_equalTo(kRealHeight(36));
        }];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.categoryTitleView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
    }
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
        if (self.showTitle) {
            make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(20));
        } else {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
        }
        make.height.mas_equalTo(kScreenHeight * 0.4);
    }];

    [self.doneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.listContainerView.mas_bottom).offset(kRealWidth(20));

        make.height.mas_equalTo(kRealWidth(45));
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];
}

#pragma mark - delegate
- (id<HDCategoryListContentViewDelegate>)listContainerView:(HDCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    TNDeliveryComponyModel *model = self.list[index];
    TNDeliveryContentView *deliverView = [[TNDeliveryContentView alloc] initWithContent:model.freightRulesDesc];
    return deliverView;
}
- (NSInteger)numberOfListsInListContainerView:(HDCategoryListContainerView *)listContainerView {
    return self.list.count;
}
- (void)categoryView:(HDCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
}
- (CGFloat)categoryTitleView:(HDCategoryTitleView *)titleView widthForTitle:(NSString *)title {
    CGFloat width = ceilf([title boundingRectWithSize:CGSizeMake(MAXFLOAT, titleView.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName: titleView.titleSelectedFont}
                                              context:nil]
                              .size.width);
    return MIN(width, kScreenWidth - kRealWidth(30));
}

///** @ contentTextView */
- (UITextView *)getContentTextView {
    UITextView *textView = [[UITextView alloc] init];
    textView.textColor = HDAppTheme.TinhNowColor.G1;
    textView.font = HDAppTheme.TinhNowFont.standard12;
    textView.editable = NO;
    textView.selectable = NO;
    textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, -4);
    return textView;
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
- (HDCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[HDCategoryTitleView alloc] init];
        _categoryTitleView.listContainer = self.listContainerView;
        _categoryTitleView.titles = [self.list mapObjectsUsingBlock:^id _Nonnull(TNDeliveryComponyModel *_Nonnull obj, NSUInteger idx) {
            return obj.deliveryCorp;
        }];
        _categoryTitleView.delegate = self;
        _categoryTitleView.titleDataSource = self;
        HDCategoryIndicatorLineView *lineView = [[HDCategoryIndicatorLineView alloc] init];
        lineView.lineStyle = HDCategoryIndicatorLineStyle_LengthenOffset;
        lineView.indicatorWidth = 24;
        lineView.indicatorColor = HDAppTheme.TinhNowColor.C1;
        lineView.verticalMargin = 0;
        _categoryTitleView.indicators = @[lineView];
        _categoryTitleView.backgroundColor = [UIColor whiteColor];
        _categoryTitleView.titleFont = [HDAppTheme.TinhNowFont fontMedium:14];
        _categoryTitleView.titleSelectedFont = [HDAppTheme.TinhNowFont fontSemibold:16];
        _categoryTitleView.titleSelectedColor = HDAppTheme.TinhNowColor.C1;
        _categoryTitleView.titleLabelZoomEnabled = NO;
        //        _categoryTitleView.contentEdgeInsetLeft = kRealWidth(15);
        //        _categoryTitleView.contentEdgeInsetRight = kRealWidth(15);
        //        _categoryTitleView.cellSpacing = kRealWidth(20);
        _categoryTitleView.averageCellSpacingEnabled = YES;
    }
    return _categoryTitleView;
}
- (HDCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[HDCategoryListContainerView alloc] initWithType:HDCategoryListContainerTypeScrollView delegate:self];
    }
    return _listContainerView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.lineColor;
    }
    return _lineView;
}

@end
