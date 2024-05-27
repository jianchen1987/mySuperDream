//
//  PNBillOrderDetialsSectionHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillOrderDetialsSectionHeaderView.h"
#import "HDAppTheme+PayNow.h"
#import "HDCommonDefines.h"
#import "Masonry.h"
#import "SALabel.h"


@interface PNBillOrderDetialsSectionHeaderView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *sectionTitleLabel;
@end


@implementation PNBillOrderDetialsSectionHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    // 新建标识
    static NSString *ID = @"PNBillOrderDetialsSectionHeaderView";
    // 创建cell
    PNBillOrderDetialsSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];

    if (!header) {
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 初始化子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.contentView.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.sectionTitleLabel];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.right.equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];

    [self.sectionTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(10));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(-10));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-15));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setSectionTitleStr:(NSString *)sectionTitleStr {
    _sectionTitleStr = sectionTitleStr;

    self.sectionTitleLabel.text = self.sectionTitleStr;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _bgView = view;
    }
    return _bgView;
}

- (SALabel *)sectionTitleLabel {
    if (!_sectionTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15B;
        _sectionTitleLabel = label;
    }
    return _sectionTitleLabel;
}
@end
