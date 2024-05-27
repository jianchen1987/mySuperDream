//
//  bankListHeaderView.m
//  ViPay
//
//  Created by Quin on 2021/8/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNBankListHeaderView.h"
#import "HDAppTheme+PayNow.h"
#import "HDAppTheme.h"
#import "Masonry.h"
#import "PNMultiLanguageManager.h" //语言
#import <HDKitCore/HDKitCore.h>


@interface PNBankListHeaderView () <HDSearchBarDelegate>
@end


@implementation PNBankListHeaderView

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    // 新建标识
    static NSString *ID = @"bankListHeaderView";
    // 创建cell
    PNBankListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.searchBar];
    [self.contentView setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kRealWidth(50)));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.right.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

- (void)callBack {
    !self.inputHandler ?: self.inputHandler([self.searchBar getText]);
}

#pragma mark
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self callBack];
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    return YES;
}

#pragma mark - lazy load
- (UIView *)backview {
    if (!_backview) {
        _backview = UIView.new;
        _backview.backgroundColor = [UIColor whiteColor];
        _backview.layer.cornerRadius = kRealWidth(23);
        _backview.layer.borderColor = [HDAppTheme.PayNowColor.cFFFFFF colorWithAlphaComponent:0.05].CGColor;
        _backview.layer.borderWidth = 1.0f;
    }
    return _backview;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.image = [UIImage imageNamed:@"pay_search"];
    }
    return _imageView;
}

- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[HDSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeHolder = PNLocalizedString(@"SEARCH", @"搜索");
    }
    return _searchBar;
}

@end
