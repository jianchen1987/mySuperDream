//
//  WMOrderDetailViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailViewController.h"
#import "SALotteryAlertViewPresenter.h"
#import "SAQueryPaymentStateRspModel.h"
#import "WMOrderDetailView.h"
#import "WMOrderDetailViewModel.h"
#import <HDKitCore/HDWeakTimer.h>


@interface WMOrderDetailViewController ()
/// 内容
@property (nonatomic, strong) WMOrderDetailView *contentView;
/// VM
@property (nonatomic, strong) WMOrderDetailViewModel *viewModel;
/// 是否从下单页而来
@property (nonatomic, assign) BOOL isFromOrderSubmit;
/// 是否需要展示抽奖弹窗
@property (nonatomic, assign) BOOL isNeedQueryLottery;

@property (nonatomic, strong) NSTimer *timer; ///< 定时器，查询订单支付状态
@end


@implementation WMOrderDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.isFromOrderSubmit = [[parameters objectForKey:@"isFromOrderSubmit"] boolValue];
    self.isNeedQueryLottery = [[parameters objectForKey:@"isNeedQueryLottery"] boolValue];

    //后台进前台通知 刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self.viewModel selector:@selector(getNewData) name:UIApplicationDidBecomeActiveNotification object:nil];

    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return NO;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
    self.miniumGetNewDataDuration = 5;
    if (self.isFromOrderSubmit) {
        self.hd_interactivePopDisabled = true;
    }

    if (self.isNeedQueryLottery) {
        [SALotteryAlertViewPresenter showLotteryAlertViewWithOrderNo:self.viewModel.orderNo completion:^{
            HDLog(@"抽奖弹窗展示出来啦");
        }];
    }
    self.timer = [HDWeakTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(queryPaymentState) userInfo:nil repeats:YES];
    [self.timer fire];
    
    [self microphoneDetection];
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    [self.viewModel getNewData];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.bottom.centerX.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

- (void)queryPaymentState {
    @HDWeakify(self);
    [self.viewModel getOrderPaymentStateSuccess:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (rspModel.payState != SAPaymentStateInit && rspModel.payState != SAPaymentStatePaying) {
            [self.timer invalidate];
            /// 2022.11.24 优化请求 避免首次进入无效的重复请求订单详情
            ///正在请求
            if (self.viewModel.requestState != 1) {
                if (self.viewModel.requestState == 2) {
                    if (self.viewModel.orderDetailRspModel.orderDetailForUser.paymentMethod == SAOrderPaymentTypeOnline
                        && self.viewModel.orderDetailRspModel.orderDetailForUser.bizState == WMBusinessStatusWaitingInitialized) {
                        [self.viewModel getNewData];
                    }
                } else {
                    [self.viewModel getNewData];
                }
            }
        }
    } failure:nil];
}

- (void)microphoneDetection {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
//    // 已禁止麦克风权限，用户选择是否去开启
//    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
//        // 弹窗提示
//        [NAT showAlertWithTitle:nil
//                        message:SALocalizedString(@"alert_open_microphone", @"大象App需要使用您的麦克风，以便骑手能够及时联系您。")
//             confirmButtonTitle:SALocalizedString(@"O3N3zScm",@"去开启")
//           confirmButtonHandler:^(HDAlertView * _Nonnull alertView, HDAlertViewButton * _Nonnull button) {
//            [alertView dismiss];
//                //跳转到系统设置开启麦克风
//                [HDSystemCapabilityUtil openAppSystemSettingPage];
//        }
//         cancelButtonTitle:SALocalizedStringFromTable(@"confirm",@"稍后设置", @"Buttons")
//         cancelButtonHandler:^(HDAlertView * _Nonnull alertView, HDAlertViewButton * _Nonnull button) {
//            [alertView dismiss];
//        }];
//    } else
        
        if(authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {

        }];
    }
}


#pragma mark - SAViewControllerProtocol
- (BOOL)allowContinuousBePushed {
    return true;
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    // 如果是下单页过来的则返回外卖订单列表页
    if (self.isFromOrderSubmit) {
        UITabBarController *tabbarVC = self.tabBarController;
        if (tabbarVC) {
            [self.navigationController popToRootViewControllerAnimated:true];
        } else {
            [super hd_backItemClick:sender];
        }
    } else {
        [super hd_backItemClick:sender];
    }
}

#pragma mark - lazy load
- (WMOrderDetailView *)contentView {
    return _contentView ?: ({ _contentView = [[WMOrderDetailView alloc] initWithViewModel:self.viewModel]; });
}

- (WMOrderDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMOrderDetailViewModel alloc] init];
        _viewModel.orderNo = [self.parameters objectForKey:@"orderNo"];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

- (NSString *)orderNo {
    return self.viewModel.orderNo;
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeOther;
}

@end
