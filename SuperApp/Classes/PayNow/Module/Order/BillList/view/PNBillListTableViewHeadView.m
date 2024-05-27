//
//  HDBillListTableViewHeadView.m
//  ViPay
//
//  Created by seeu on 2019/7/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNBillListTableViewHeadView.h"
#import "HDAppTheme.h"
#import "HDCommonButton.h"
#import "HDKitCore/HDFrameLayout.h"
#import "PNUtilMacro.h"
#import <Masonry/Masonry.h>


@interface PNBillListTableViewHeadView ()

@property (nonatomic, strong) HDCommonButton *titleButton; ///< 按钮

@end


@implementation PNBillListTableViewHeadView

+ (instancetype)viewWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"HDBillListTableViewHeadView";
    PNBillListTableViewHeadView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!view) {
        view = [[PNBillListTableViewHeadView alloc] initWithReuseIdentifier:identifier];
    }

    return view;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.titleButton];
    self.contentView.backgroundColor = [HDAppTheme.color G5];
}

#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    _title = title;

    if (WJIsStringNotEmpty(self.title)) {
        self.titleButton.hidden = NO;
        [self.titleButton setTitle:_title forState:UIControlStateNormal];
    } else {
        self.titleButton.hidden = YES;
    }

    [self setNeedsLayout];
}

#pragma mark - actions
- (void)clickOnButton:(HDCommonButton *)button {
    if (self.clickHandle) {
        self.clickHandle(button);
    }
}

#pragma mark - lazy load
/** @lazy titleButton */
- (HDCommonButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [HDCommonButton buttonWithType:UIButtonTypeCustom];
        _titleButton.type = HDCommonButtonImageRLabelL;

        _titleButton.labelEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        //        _titleButton.imageViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        //        [_titleButton setImage:[UIImage imageNamed:@"ic-fenlei_up"] forState:UIControlStateNormal];
        //        [_titleButton setImage:[UIImage imageNamed:@"ic-fenlei_down"] forState:UIControlStateSelected];
        [_titleButton setTitleColor:[HDAppTheme.color G2] forState:UIControlStateNormal];
        [_titleButton setTitleColor:[HDAppTheme.color G2] forState:UIControlStateSelected];
        _titleButton.titleLabel.font = [HDAppTheme.font standard3];
        _titleButton.titleLabel.numberOfLines = 0;
        _titleButton.backgroundColor = [UIColor whiteColor];

        _titleButton.layer.masksToBounds = YES;
        _titleButton.layer.borderWidth = 1;
        _titleButton.layer.borderColor = [HDAppTheme.color G4].CGColor;
        [_titleButton addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.titleButton hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.center.hd_equalTo(self.contentView.center);
        make.size.hd_equalTo(CGSizeMake(self.titleButton.appropriateSize.width + 10, self.titleButton.appropriateSize.height + 10));
    }];

    _titleButton.layer.cornerRadius = _titleButton.bounds.size.height * 0.5;
}
@end
