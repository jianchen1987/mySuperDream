//
//  SAView.m
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "SAAppDelegate.h"


@interface SAView ()
/// KVO
@property (nonatomic, strong) FBKVOController *KVOController;
/// 手势识别器
@property (nonatomic, strong) UITapGestureRecognizer *hd_tapRecognizer;
/// 滚动容器
@property (nonatomic, strong) UIScrollView *scrollView;
/// 撑大 UIScrollView 的 UIView
@property (nonatomic, strong) UIView *scrollViewContainer;
@end


@implementation SAView

#pragma mark - life cycle
- (void)commonInit {
    // 监听语言变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hd_languageDidChanged) name:kNotificationNameLanguageChanged object:nil];

    [self hd_setupViews];
    [self hd_bindViewModel];

    [self hd_languageDidChanged];

    [self setNeedsUpdateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - SAViewProtocol
- (void)hd_bindViewModel {
}

- (void)hd_setupViews {
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - getter
- (FBKVOController *)KVOController {
    return _KVOController ?: ({ _KVOController = [FBKVOController controllerWithObserver:self]; });
}

- (UITapGestureRecognizer *)hd_tapRecognizer {
    if (!_hd_tapRecognizer) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [tap addTarget:self action:@selector(hd_clickedViewHandler)];
        tap.cancelsTouchesInView = YES;
        _hd_tapRecognizer = tap;
    }
    return _hd_tapRecognizer;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.alwaysBounceVertical = true;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 13.0, *)) {
            _scrollView.automaticallyAdjustsScrollIndicatorInsets = false;
        }
    }
    return _scrollView;
}

- (UIView *)scrollViewContainer {
    if (!_scrollViewContainer) {
        _scrollViewContainer = UIView.new;
    }
    return _scrollViewContainer;
}
@end
