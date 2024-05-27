//
//  SAViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewController.h"
#import "LKDataRecord.h"
#import "SATalkingData.h"
#import <HDUIKit/HDAppTheme.h>
#import <Stinger/Stinger.h>
#import "SAMissionCountDownView.h"
#import "SABrowseMissionInfoRspModel.h"


@interface SAViewController ()
/// 是否暂停获取新数据（最小刷新间隔）
@property (nonatomic, assign) BOOL pauseNewDataGeting;
/// 滚动容器
@property (nonatomic, strong) UIScrollView *scrollView;
/// 撑大 UIScrollView 的 UIView
@property (nonatomic, strong) UIView *scrollViewContainer;

///< countDownView
@property (nonatomic, strong) SAMissionCountDownView *countDownView;

@end


@implementation SAViewController

@synthesize miniumGetNewDataDuration = _miniumGetNewDataDuration;

- (void)viewDidLoad {
    self.hd_enableKeyboardRespond = true;
    //这里设置  会影响到setViewControllers 后手势返回卡死页面的问题 暂时先关掉
    self.hd_fullScreenPopDisabled = true;
    [super viewDidLoad];
    //
    self.view.backgroundColor = UIColor.whiteColor;

    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = false;
    }

    // 监听语言变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hd_languageDidChanged) name:kNotificationNameLanguageChanged object:nil];
}

- (void)dealloc {
    if (self.countDownView) {
        [self.countDownView removeFromSuperview];
        self.countDownView = nil;
    }

    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    BOOL hideBackButton = [self.parameters[@"hideBackButton"] boolValue];
    self.hd_navigationItem.hidesBackButton = hideBackButton;

    [super viewWillAppear:animated];

    NSString *taskNo = [self.parameters valueForKey:@"taskId"];
    NSString *browseType = [self.parameters valueForKey:@"browseType"];
    if (HDIsStringNotEmpty(taskNo) && HDIsStringNotEmpty(browseType)) {
        if (!self.countDownView) {
            [self queryBrowseMissionWithTaskId:taskNo browseType:browseType];
        } else {
            [self.countDownView start];
        }
    }

    [SATalkingData trackPageBegin:NSStringFromClass(self.class)];
    [LKDataRecord.shared tracePageBegin:NSStringFromClass(self.class)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SATalkingData trackPageEnd:NSStringFromClass(self.class)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (self.countDownView) {
        [self.countDownView pause];
    }

    [LKDataRecord.shared tracePageEnd:NSStringFromClass(self.class)];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    SAViewController *viewController = [super allocWithZone:zone];
    // 初始化
    viewController.miniumGetNewDataDuration = -1;

    __weak __typeof(viewController) weakViewController = viewController;
    [viewController st_hookInstanceMethod:@selector(viewDidLoad) option:STOptionAfter usingIdentifier:@"hook_hd_viewDidLoad_after" withBlock:^(id<StingerParams> params) {
        __strong __typeof(weakViewController) viewController = weakViewController;
        [viewController hd_setupViews];
        [viewController hd_bindViewModel];
        [viewController hd_languageDidChanged];
        [viewController.view setNeedsUpdateConstraints];
    }];
    [viewController st_hookInstanceMethod:@selector(viewWillAppear:) option:STOptionAfter usingIdentifier:@"hook_hd_viewWillAppear_after" withBlock:^(id<StingerParams> params, BOOL animated) {
        __strong __typeof(weakViewController) viewController = weakViewController;
        if (!viewController.pauseNewDataGeting) {
            [viewController hd_getNewData];
            viewController.pauseNewDataGeting = true;
            if (viewController.miniumGetNewDataDuration >= 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(viewController.miniumGetNewDataDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 不强引用viewController，否则需要等倒计时结束后viewController才会释放
                    weakViewController.pauseNewDataGeting = false;
                });
            }
        }
        [viewController hd_setupNavigation];
    }];
    return viewController;
}

- (void)queryBrowseMissionWithTaskId:(NSString *_Nonnull)taskId browseType:(NSString *_Nonnull)browseType {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/app/channel/task/getBrowseTask";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"taskNo"] = taskId;
    params[@"browseType"] = browseType;
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        SABrowseMissionInfoRspModel *model = [SABrowseMissionInfoRspModel yy_modelWithJSON:rspModel.data];
        if (model.hasBrowseTask) {
            @HDStrongify(self);
            self.countDownView = [[SAMissionCountDownView alloc] initWithSeconds:model.browseTime browseType:model.browseType taskNo:model.taskNo];
            [self.view addSubview:self.countDownView];
            [self.countDownView start];
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        HDLog(@"接口报错啦");
    }];
}

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super init]) {
        self.parameters = parameters;
    }
    return self;
}

#pragma mark - SAViewControllerProtocol
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    if (self = [super init]) {
    }
    return self;
}

- (SAViewControllerShowType)showType {
    return SAViewControllerShowTypePush;
}

- (BOOL)allowContinuousBePushed {
    return false;
}

- (BOOL)needLogin {
    return true;
}

- (BOOL)needCheckPayPwd {
    return false;
}

/**
 *  添加控件
 */
- (void)hd_setupViews {
}

- (NSTimeInterval)miniumGetNewDataDuration {
    if (_miniumGetNewDataDuration == -1) {
        _miniumGetNewDataDuration = 10;
    }
    return _miniumGetNewDataDuration;
}

/**
 *  绑定
 */
- (void)hd_bindViewModel {
}

/**
 *  设置导航栏
 */
- (void)hd_setupNavigation {
}

/**
 *  初次获取数据
 */
- (void)hd_getNewData {
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - 屏幕旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - setters
- (void)setBoldTitle:(NSString *)boldTitle {
    _boldTitle = boldTitle;

    HDViewControllerNavigationBarStyle style = self.hd_preferredNavigationBarStyle;
    UIColor *color = UIColor.whiteColor;
    if (HDViewControllerNavigationBarStyleWhite == style) {
        color = HDAppTheme.color.sa_C333;
    } else if (HDViewControllerNavigationBarStyleOther == style) {
        color = HDAppTheme.color.sa_C1;
    } else if (HDViewControllerNavigationBarStyleTransparent == style) {
        color = UIColor.whiteColor;
    }
    [self setBoldWithTitle:boldTitle color:color];
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

#pragma mark - public methods
- (void)setBoldWithTitle:(NSString *)title color:(UIColor *)color {
    self.hd_navigationItem.title = title;
    self.hd_navTitleColor = color;
    self.hd_navTitleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
}

#pragma mark - lazy load
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


@implementation SALoginlessViewController
#pragma mark - override
- (BOOL)needLogin {
    return false;
}
@end
