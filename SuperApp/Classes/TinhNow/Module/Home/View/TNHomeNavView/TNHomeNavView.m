//
//  TNHomeNavView.m
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNHomeNavView.h"
#import "SAMessageButton.h"
#import "SATalkingData.h"
#import "TNHomeViewModel.h"
#import <HDSearchBar.h>


@interface TNHomeNavView () <HDSearchBarDelegate>
/// 背景图
@property (strong, nonatomic) UIImageView *backgroundImageView;
/// 导航按钮 父视图
@property (strong, nonatomic) UIView *contentView;
/// backButton
@property (nonatomic, strong) HDUIButton *backButton;
/// searchBar
@property (nonatomic, strong) HDSearchBar *searchBar;
/// 消息按钮
@property (nonatomic, strong) SAMessageButton *messageBTN;
/// viewmodel
@property (nonatomic, strong) TNHomeViewModel *viewModel;

@end


@implementation TNHomeNavView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)hd_setupViews {
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.contentView];
    [self.contentView addSubview:self.backButton];
    [self.contentView addSubview:self.searchBar];
    [self.contentView addSubview:self.messageBTN];
    // 监听消息更新的通知
    @HDWeakify(self);
    [NSNotificationCenter.defaultCenter addObserverForName:kNotificationNameReceivedNewMessage object:nil queue:nil usingBlock:^(NSNotification *_Nonnull note) {
        @HDStrongify(self);
        NSNumber *count = note.userInfo[@"count"];
        if (count.integerValue > 0) {
            [self.messageBTN showMessageCount:count.integerValue];
        } else {
            [self.messageBTN clearMessageCount];
        }
    }];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    self.backButton.hidden = self.viewModel.hideBackButton;
    [self.KVOController hd_observe:self.viewModel keyPath:@"hideBackButton" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.backButton.hidden = self.viewModel.hideBackButton;
        [self setNeedsUpdateConstraints];
    }];
}

- (void)updateConstraints {
    [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.backgroundImageView);
        make.top.equalTo(self.backgroundImageView.mas_top).offset(kStatusBarH);
    }];
    if (!self.backButton.isHidden) {
        [self.backButton sizeToFit];
        [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(self.backButton.frame.size);
        }];
    }

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.backButton.isHidden) {
            make.left.equalTo(self.backButton.mas_right).offset(3);
        } else {
            make.left.equalTo(self.contentView.mas_left).offset(15);
        }
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(34);
        make.right.equalTo(self.messageBTN.mas_left).offset(-10);
    }];
    [self.messageBTN sizeToFit];
    [self.messageBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(self.messageBTN.imageView.image.size);
    }];

    [super updateConstraints];
}
#pragma mark - delegate
- (BOOL)searchBarTextShouldBeginEditing:(HDSearchBar *)searchBar {
    if (self.searchBarClickedHandler) {
        self.searchBarClickedHandler();
    }
    return NO;
}
#pragma mark - lazy load
/** @lazy backbutton */
- (HDUIButton *)backButton {
    if (!_backButton) {
        _backButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_backButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.viewController dismissAnimated:true completion:nil];
        }];
    }
    return _backButton;
}

- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        HDSearchBar *searchView = [HDSearchBar new];
        searchView.delegate = self;
        searchView.marginToSide = 0;
        searchView.textFieldHeight = 34;
        searchView.placeHolder = TNLocalizedString(@"tn_page_search_title", @"Search");
        searchView.placeholderColor = HDAppTheme.TinhNowColor.G3;
        searchView.backgroundColor = [UIColor clearColor];
        searchView.borderColor = [UIColor whiteColor];
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cameraBtn setBackgroundImage:[UIImage imageNamed:@"tn_camera_search"] forState:UIControlStateNormal];
        [cameraBtn sizeToFit];
        [cameraBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [[HDMediator sharedInstance] navigaveToTinhNowPictureSearchViewController:@{}];
        }];
        searchView.textField.rightView = cameraBtn;
        searchView.textField.rightViewMode = UITextFieldViewModeAlways;
        _searchBar = searchView;
    }
    return _searchBar;
}
- (SAMessageButton *)messageBTN {
    if (!_messageBTN) {
        SAMessageButton *button = [SAMessageButton buttonWithType:UIButtonTypeCustom clientType:SAClientTypeTinhNow];
        [button setImage:[UIImage imageNamed:@"home_icon_nwes"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.dotPosition = CGPointZero;
        //        button.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 0);
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [SATalkingData trackEvent:@"[电商]点击消息中心"];
            [HDMediator.sharedInstance navigaveToMessagesViewController:@{@"clientType": SAClientTypeTinhNow}];
        }];
        [button setDotColor:[UIColor whiteColor]];
        _messageBTN = button;
    }
    return _messageBTN;
}
/** @lazy backgroundImageView */
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow-navbar-img"]];
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}
/** @lazy contentView */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
@end
