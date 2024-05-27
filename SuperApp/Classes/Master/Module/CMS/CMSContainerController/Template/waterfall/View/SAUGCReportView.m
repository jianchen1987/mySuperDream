//
//  SAUGCReportView.m
//  SuperApp
//
//  Created by seeu on 2022/11/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUGCReportView.h"

static SAUGCReportView *_UGC_Report_View = NULL;


@interface SAUGCReportView ()

///< 背景蒙层
@property (nonatomic, strong) UIView *bgMaskView;
///< close
@property (nonatomic, strong) HDUIButton *closeBtn;
///< 引人不适
@property (nonatomic, strong) SAOperationButton *uncomfortableBtn;
///< 虚假的
@property (nonatomic, strong) SAOperationButton *fraudbtn;
///< 不感兴趣的
@property (nonatomic, strong) SAOperationButton *uninterestedBtn;
///< 不再推荐
@property (nonatomic, strong) SAOperationButton *unrecommendBtn;

@end


@implementation SAUGCReportView

+ (SAUGCReportView *)reportViewWithFrame:(CGRect)frame {
    if (_UGC_Report_View) {
        [_UGC_Report_View clickedOnClose:nil];
        _UGC_Report_View = nil;
    }
    _UGC_Report_View = [[SAUGCReportView alloc] initWithFrame:frame];
    return _UGC_Report_View;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.shouldRemoveMaskWhenTouchInBackground = NO;
    }
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;

    [self addSubview:self.bgMaskView];
    [self addSubview:self.closeBtn];
    [self addSubview:self.uncomfortableBtn];
    [self addSubview:self.fraudbtn];
    [self addSubview:self.uninterestedBtn];
    [self addSubview:self.unrecommendBtn];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedOnBackground)];
    [self.bgMaskView addGestureRecognizer:tap];
}

- (void)updateConstraints {
    [self.bgMaskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-kRealWidth(5));
        make.top.equalTo(self.mas_top).offset(kRealWidth(5));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(32), kRealWidth(34)));
    }];

    [self.fraudbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(12));
        make.bottom.equalTo(self.mas_centerY).offset(-kRealWidth(6));
    }];

    [self.uninterestedBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.mas_centerY).offset(kRealWidth(6));
    }];

    [self.uncomfortableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(12));
        make.bottom.equalTo(self.fraudbtn.mas_top).offset(-kRealWidth(12));
    }];

    [self.unrecommendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.uninterestedBtn.mas_bottom).offset(kRealWidth(12));
    }];

    [super updateConstraints];
}

#pragma mark - private methods
- (void)clickedOnClose:(HDUIButton *)button {
    [self removeFromSuperview];
    !self.closeClickedHandler ?: self.closeClickedHandler();
}

- (void)clickedOnBackground {
    if (self.shouldRemoveMaskWhenTouchInBackground) {
        !self.closeClickedHandler ?: self.closeClickedHandler();
    }
}

- (void)clickedOnReport:(SAOperationButton *)button {
    if ([button isEqual:self.uncomfortableBtn]) {
        !self.reportClickedHander ?: self.reportClickedHander(@"causing_discomfort");
    } else if ([button isEqual:self.fraudbtn]) {
        !self.reportClickedHander ?: self.reportClickedHander(@"false_information");
    } else if ([button isEqual:self.uninterestedBtn]) {
        !self.reportClickedHander ?: self.reportClickedHander(@"un_interested");
    } else if ([button isEqual:self.unrecommendBtn]) {
        !self.reportClickedHander ?: self.reportClickedHander(@"unrecommend_user");
    } else {
        !self.reportClickedHander ?: self.reportClickedHander(@"un_interested");
    }
}

#pragma mark - lazy load
/** @lazy bgmaskview */
- (UIView *)bgMaskView {
    if (!_bgMaskView) {
        _bgMaskView = [[UIView alloc] init];
        _bgMaskView.backgroundColor = UIColor.blackColor;
        _bgMaskView.alpha = 0.8;
        _bgMaskView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8.0];
        };
    }
    return _bgMaskView;
}

- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_close_gray"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickedOnClose:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        _closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill; //水平方向拉伸
        _closeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;     //垂直方向拉伸
    }
    return _closeBtn;
}

- (SAOperationButton *)uncomfortableBtn {
    if (!_uncomfortableBtn) {
        SAOperationButton *btn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [btn setTitle:SALocalizedString(@"ugc_uncomfortable", @"引人不适") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        btn.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        [btn applyPropertiesWithBackgroundColor:UIColor.clearColor];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn setBorderColor:UIColor.whiteColor];
        [btn addTarget:self action:@selector(clickedOnReport:) forControlEvents:UIControlEventTouchUpInside];
        _uncomfortableBtn = btn;
    }
    return _uncomfortableBtn;
}

- (SAOperationButton *)fraudbtn {
    if (!_fraudbtn) {
        SAOperationButton *btn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [btn setTitle:SALocalizedString(@"ugc_fraud", @"虚假信息") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        btn.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        [btn applyPropertiesWithBackgroundColor:UIColor.clearColor];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn setBorderColor:UIColor.whiteColor];
        [btn addTarget:self action:@selector(clickedOnReport:) forControlEvents:UIControlEventTouchUpInside];
        _fraudbtn = btn;
    }
    return _fraudbtn;
}

- (SAOperationButton *)uninterestedBtn {
    if (!_uninterestedBtn) {
        SAOperationButton *btn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [btn setTitle:SALocalizedString(@"ugc_uninterested", @"不感兴趣") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        btn.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        [btn applyPropertiesWithBackgroundColor:UIColor.clearColor];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn setBorderColor:UIColor.whiteColor];
        [btn addTarget:self action:@selector(clickedOnReport:) forControlEvents:UIControlEventTouchUpInside];
        _uninterestedBtn = btn;
    }
    return _uninterestedBtn;
}

- (SAOperationButton *)unrecommendBtn {
    if (!_unrecommendBtn) {
        SAOperationButton *btn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [btn setTitle:SALocalizedString(@"ugc_unrecommend", @"不看此作者内容") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        btn.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        [btn applyPropertiesWithBackgroundColor:UIColor.clearColor];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn setBorderColor:UIColor.whiteColor];
        [btn addTarget:self action:@selector(clickedOnReport:) forControlEvents:UIControlEventTouchUpInside];
        _unrecommendBtn = btn;
    }
    return _unrecommendBtn;
}

@end
