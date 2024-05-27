//
//  WQCodeScanner.m
//  National Wallet
//
//  Created by 陈剑 on 2018/4/23.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "WQCodeScanner.h"
#import "HDBaseHtmlVC.h"
#import "HDCommonButton.h"
#import "PNCommonUtils.h"
#import "PNRspModel.h"
#import "PNTransAmountViewController.h"
#import "PNTransListDTO.h"
#import "SAAppEnvManager.h"
#import "UINavigationController+HDKitCore.h"
#import "UIView+HD_Extension.h"
#import "UIViewController+HDKitCore.h"
#import "WNQRDecoder+PayNow.h"
#import <AVFoundation/AVFoundation.h>
#import <BakongKHQR/BakongKHQR.h>


@interface WQCodeScanner () <AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    //埋点分析用
    NSDate *_scanBeginTime;
    NSString *errorDetail;
}

@property (atomic, strong) AVCaptureSession *session;
@property (atomic, strong) AVCaptureDevice *device;
//是否扫到二维码标识
@property (atomic, assign) BOOL isReading;
//扫描线
@property (nonatomic, strong) UIImageView *lineImageView;
@property (atomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) HDCommonButton *FAQBtn;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIImageView *scanWindows;
@property (nonatomic, strong) UIButton *lightBtn;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (atomic, assign) NSInteger count;
@property (atomic, strong) NSTimer *tipsTimer;
@property (nonatomic, assign) NSInteger tipsChangeSign;
@property (nonatomic, strong) PNTransListDTO *transDTO;
@end


@implementation WQCodeScanner
- (id)init {
    self = [super init];
    if (self) {
        self.scanType = WQCodeScannerTypeAll;
    }
    return self;
}

- (id)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        NSNumber *scanType = [parameters valueForKey:@"scanType"];
        if (scanType) {
            self.scanType = scanType.integerValue;
        }
    }
    return self;
}

- (void)dealloc {
    HDLog(@"%@", @"扫一扫 controller dealloc");

    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:_device];
    _previewLayer = nil;
    _device = nil;
    _timer = nil;
    _session = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    errorDetail = @"无法识别";
    [self loadCustomView];

    // 判断权限
    [self checkCameraPermission];

    NSString *codeStr = @"";
    switch (_scanType) {
        case WQCodeScannerTypeAll:
            codeStr = @"QRCode/BarCode";
            break;
        case WQCodeScannerTypeQRCode:
            codeStr = @"QRCode";
            break;
        case WQCodeScannerTypeBarcode:
            codeStr = @"BarCode";
            break;
        default:
            break;
    }

    if (self.tipStr && self.tipStr.length > 0) {
        self.tipLabel.text = self.tipStr;
    } else {
        self.tipLabel.text = PNLocalizedString(@"PAGE_TEXT_SCAN_TIPS1", @"放入框内，自动扫描。");
    }

    [self startRunning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.session.isRunning) {
        [self startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self stopRunning];
}

- (BOOL)loadScanView {
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!self.device) {
        return NO;
    }

    [self subjectAreaDidChange:nil];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if (!input) {
        return NO;
    }
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    if (!output) {
        return NO;
    }

    dispatch_queue_t codeQueue = dispatch_queue_create("qrcodeOutputQueue", DISPATCH_QUEUE_SERIAL);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:codeQueue];

    AVCaptureVideoDataOutput *lightOutput = [[AVCaptureVideoDataOutput alloc] init];
    if (!lightOutput) {
        return NO;
    }
    dispatch_queue_t lightQueue = dispatch_queue_create("lightOutputQueue", DISPATCH_QUEUE_SERIAL);
    [lightOutput setSampleBufferDelegate:self queue:lightQueue];

    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    if (!self.session) {
        return NO;
    }
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];

    //监听相机自动对焦
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.device];

    [self.session addInput:input];
    [self.session addOutput:output];
    [self.session addOutput:lightOutput];
    //设置扫码支持的编码格式
    switch (self.scanType) {
        case WQCodeScannerTypeAll:
            output.metadataObjectTypes = @[
                AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeCode93Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypePDF417Code
            ];
            break;

        case WQCodeScannerTypeQRCode:
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            break;

        case WQCodeScannerTypeBarcode:
            output.metadataObjectTypes = @[
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeCode93Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypePDF417Code
            ];
            break;

        default:
            break;
    }

    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];

    return YES;
}

- (void)loadCustomView {
    self.view.backgroundColor = [UIColor blackColor];

    CGRect rc = [[UIScreen mainScreen] bounds];
    // rc.size.height -= 50;
    _width = rc.size.width * 0.1;
    // height = rc.size.height * 0.2;
    _height = 100 + kNavigationBarH; //(rc.size.height - (rc.size.width - _width * 2))/2;

    CGFloat alpha = 0.5;

    //最上部view
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rc.size.width, _height)];
    upView.alpha = alpha;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];

    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, _height, _width, rc.size.width - _width * 2)];
    leftView.alpha = alpha;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];

    //中间扫描区域
    self.scanWindows = [[UIImageView alloc] initWithFrame:CGRectMake(_width, _height, rc.size.width - _width * 2, rc.size.width - _width * 2)];
    self.scanWindows.image = [UIImage imageNamed:@"ic-angle"];
    self.scanWindows.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scanWindows];

    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(rc.size.width - _width, _height, _width, rc.size.width - _width * 2)];
    rightView.alpha = alpha;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];

    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, _height + rc.size.width - _width * 2, rc.size.width, rc.size.height - _height - _width * 2)];
    downView.alpha = alpha;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];

    //用于说明的label
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.frame = CGRectMake(_width, _height + self.scanWindows.frame.size.height + 10, rc.size.width - _width * 2, 40);
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.font = HDAppTheme.PayNowFont.standard16;
    [self.view addSubview:self.tipLabel];

    self.FAQBtn = [[HDCommonButton alloc] initWithFrame:CGRectMake(20, _height + self.scanWindows.frame.size.height + 10, kScreenWidth - 40, 30)];
    self.FAQBtn.titleLabel.font = HDAppTheme.PayNowFont.standard16;
    self.FAQBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.FAQBtn.hidden = YES;

    NSMutableAttributedString *faqtitle = [[NSMutableAttributedString alloc] initWithString:PNLocalizedString(@"PAGE_TEXT_SCAN_TIPS2", @"未扫描到二维码？了解详情")
                                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    NSString *str = PNLocalizedString(@"PAGE_TEXT_SCAN_TIPS2", @"未扫描到二维码？了解详情");
    NSRange range = [str rangeOfString:PNLocalizedString(@"PAGE_TEXT_SCAN_TIPS3", @"了解详情")];
    [faqtitle addAttribute:NSForegroundColorAttributeName value:[UIColor hd_colorWithHexString:@"#ACACAC"] range:range];
    [self.FAQBtn setAttributedTitle:faqtitle forState:UIControlStateNormal];
    [self.FAQBtn addTarget:self action:@selector(clickOnFAQ:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.FAQBtn];

    //画中间的基准线
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_width, _height, rc.size.width - 2 * _width, 5)];
    self.lineImageView.image = [UIImage imageNamed:@"ic-scan-line"];
    self.lineImageView.hidden = YES;
    [self.view addSubview:self.lineImageView];

    self.lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(_width, _height + self.scanWindows.frame.size.height - 40.0, rc.size.width - _width * 2, 20)];
    [self.lightBtn setTitle:PNLocalizedString(@"BUTTO_TITLE_LIGHT_OFF", @"轻点照亮") forState:UIControlStateNormal];
    [self.lightBtn setTitle:PNLocalizedString(@"BUTTO_TITLE_LIGHT_ON", @"轻点关闭") forState:UIControlStateSelected];
    [self.lightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.lightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.lightBtn setImage:[UIImage imageNamed:@"ic-flashlight"] forState:UIControlStateNormal];
    [self.lightBtn setImage:[UIImage imageNamed:@"ic-flashlight"] forState:UIControlStateSelected];
    self.lightBtn.hidden = YES;
    [self.lightBtn addTarget:self action:@selector(clickOnLight:) forControlEvents:UIControlEventTouchUpInside];
    self.lightBtn.titleLabel.font = HDAppTheme.PayNowFont.standard16;
    [self.view addSubview:self.lightBtn];

    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarH, rc.size.width, kNavigationBarH - kStatusBarH)];
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    //选择图片按钮
    UIButton *right_BT = [[UIButton alloc] initWithFrame:CGRectMake(navView.frame.size.width - kRealWidth(8) - 40, (navView.frame.size.height - 40) / 2, 40, 40)];
    [right_BT setImage:[UIImage imageNamed:@"ic-photo"] forState:UIControlStateNormal];
    [navView addSubview:right_BT];
    [right_BT addTarget:self action:@selector(DistinguishImage) forControlEvents:UIControlEventTouchUpInside];

    UIButton *back_BT = [[UIButton alloc] initWithFrame:CGRectMake(kRealWidth(8), (navView.frame.size.height - 40) / 2, 40, 40)];
    [back_BT setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [navView addSubview:back_BT];
    [back_BT addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back:(id)sender {
    [super hd_backItemClick:sender];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)startRunning {
    if (self.session) {
        self.isReading = YES;
        [self.session startRunning];
        self.count = 0;
        self.lineImageView.hidden = NO;
        self.tipsChangeSign = 0;
        self.tipLabel.hidden = NO;
        self.FAQBtn.hidden = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
        _tipsTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(tipsChange:) userInfo:nil repeats:YES];

        _scanBeginTime = [NSDate new];
    }
}

- (void)stopRunning {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }

    if ([_tipsTimer isValid]) {
        [_tipsTimer invalidate];
        _tipsTimer = nil;
    }

    self.lineImageView.hidden = YES;
    [self.session stopRunning];
}

#pragma mark - private methods
- (void)checkCameraPermission {
    __weak __typeof(self) weakSelf = self;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (granted) {
                if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
                    //模拟器
                } else {
                    //真机
                    if ([strongSelf loadScanView]) {
                        [strongSelf startRunning];
                    } else {
                        [NAT showAlertWithMessage:@"init camera fail!" buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE           ", @"确定")
                                          handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                              [alertView dismiss];
                                          }];
                    }
                }

            } else {
                [NAT showAlertWithMessage:SALocalizedString(@"camera_use_auth_tip", @"请在iPhone的”设置-隐私-相机“选项中，允许App访问你的相机")
                              buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
            }
        });
    }];
}

#pragma mark - event response
- (void)pressBackButton {
    UINavigationController *nvc = self.navigationController;
    if (nvc) {
        if (nvc.viewControllers.count == 1) {
            [nvc dismissViewControllerAnimated:YES completion:nil];
        } else {
            [nvc popViewControllerAnimated:NO];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickOnBackBarButtonItem:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

//二维码的横线移动
- (void)moveUpAndDownLine {
    CGFloat Y = self.lineImageView.frame.origin.y;
    if (_height + self.lineImageView.frame.size.width - 5 == Y) {
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1.5];
        CGRect frame = self.lineImageView.frame;
        frame.origin.y = _height;
        self.lineImageView.frame = frame;
        [UIView commitAnimations];
        [[NSNotificationCenter defaultCenter] postNotificationName:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.device];
    } else if (_height == Y) {
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:1.5];
        CGRect frame = self.lineImageView.frame;
        frame.origin.y = _height + self.lineImageView.frame.size.width - 5;
        self.lineImageView.frame = frame;
        [UIView commitAnimations];
        self.count = self.count + 1;
        if (self.count % 3 == 0) {
            [self captureZoom:2];
        } else if (self.count % 5 == 0) {
            self.count = 0;
            [self captureZoom:1];
        }
    }
}

- (void)tipsChange:(NSTimer *)timer {
    if (self.tipsChangeSign % 3 == 0) {
        self.tipLabel.text = PNLocalizedString(@"PAGE_TEXT_SCAN_TIPS4", @"请对准二维码，耐心等待。");
        self.tipsChangeSign++;
    } else if (self.tipsChangeSign % 3 == 1) {
        self.tipLabel.hidden = YES;
        self.FAQBtn.hidden = NO;
        [timer invalidate];
    }
}

#pragma mark - 请求
- (void)request:(NSString *)result {
    [self stopRunning];

    if ([WNQRDecoder.sharedInstance canDecodePayNowQRCode:result]) {
        // coolcash 处理内部二维码
        [WNQRDecoder.sharedInstance decodePayNowQRCode:result];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startRunning];
    });

    //    // 处理直接从扫一扫进入，入金卡不需要远程识别
    //    if ([result hasPrefix:@"vipay://cashCard?"]) {
    //        // 判断是否是从入金卡过来的，是就直接传回值，否则 push 新的
    //        if ([self isPushedFromRechargeableCardView]) {
    //            if (self.resultBlock) {
    //                self.resultBlock(result);
    //            }
    //            [self.navigationController popViewControllerAnimated:YES];
    //            return;
    //        }
    //
    //        return;
    //    }
    //
    //    if ([result hasPrefix:@"http"] || [result hasPrefix:@"https"]) {
    //        // url 里换行替换
    //        result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //        NSString *BundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    //        HDLog(@"BundleName==%@", BundleName);
    //        HDLog(@"result==%@", result);
    //        result = [result hd_URLEncodedString];
    //        HDBaseHtmlVC *vc = HDBaseHtmlVC.new;
    //        vc.url = result;
    //        vc.hidesBottomBarWhenPushed = YES;
    //        [SAWindowManager navigateToViewController:vc parameters:@{}];
    //        [self.navigationController removeSpecificViewControllerClass:self.class onlyOnce:YES];
    //        return;
    //    }
    //
    //    NSString *qrCode = result;
    //
    //    KHQRResponse *response = [BakongKHQR verify:qrCode];
    //    if (response.data != nil) {
    //        CRCValidation *crcValidation = (CRCValidation *)response.data;
    //        HDLog(@"valid: %d", crcValidation.valid);
    //        if (crcValidation.valid == 1) {  // bakong
    //            KHQRResponse *decodeResponse = [BakongKHQR decode:qrCode];
    //            KHQRDecodeData *decodeData = (KHQRDecodeData *)decodeResponse.data;
    //            [decodeData printAll];
    //            [self getBakongInfo:decodeData qrCode:qrCode];
    //            return;
    //        }
    //    }
    //
    //    if ([result hasPrefix:@"coolcash"]) {  //出金二维码
    //        [self getCoolCashInfo:result];
    //        return;
    //    }
    //
    //    [self showloading];
    //
    //    @HDWeakify(self);
    //    [self.transDTO doAnalysisQRCode:result
    //        success:^(HDAnalysisQRCodeRspModel *_Nonnull rspModel) {
    //            @HDStrongify(self);
    //            [self dismissLoading];
    //            if (PNTransTypeConsume == rspModel.tradeType) {
    //
    //            } else if (PNTransTypeTransfer == rspModel.tradeType) {
    //                PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];
    //                vc.cy = rspModel.orderAmt.cy;
    //                vc.pageType = PNTradeSubTradeTypeToCoolCash;
    //                vc.qrData = result;
    //
    //                HDPayeeInfoModel *payeeInfo = [[HDPayeeInfoModel alloc] initWithAnalysisQRCodeModel:rspModel];
    //                payeeInfo.payeeLoginName = rspModel.payeeNo;
    //                vc.payeeInfo = payeeInfo;
    //
    //                [self.navigationController pushViewController:vc animated:YES];
    //            }
    //        }
    //        failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
    //            @HDStrongify(self);
    //            [self dismissLoading];
    //            [NAT showAlertWithMessage:rspModel.data
    //                          buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
    //                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
    //                                  [alertView dismiss];
    //                                  [self startRunning];
    //                              }];
    //        }];
}

- (void)getCoolCashInfo:(NSString *)result {
    [self showloading];
    @HDWeakify(self);

    [self.transDTO getPayeeInfoFromCoolcashQRCodeWithQRData:result success:^(HDPayeeInfoModel *_Nonnull payeeInfo) {
        @HDStrongify(self);
        [self dismissLoading];
        PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];
        vc.cy = payeeInfo.currency ?: @"";
        vc.pageType = PNTradeSubTradeTypeCoolCashCashOut;
        vc.payeeInfo = payeeInfo;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [NAT showAlertWithMessage:rspModel.data buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
            [self startRunning];
        }];
    }];
}

- (void)getBakongInfo:(KHQRDecodeData *)decodeData qrCode:(NSString *)qrCode {
    //    NSString *payeeNo = decodeData.bakongAccountID;
    //    NSString *merchantId = decodeData.accountInformation;

    //    [self showloading];

    //    @HDWeakify(self);
    //    [self.transDTO getPayeeInfoFromBaKongQRCodeWithAccuontNo:payeeNo
    //        merchantId:merchantId
    //        merchantType:decodeData.merchantType
    //        success:^(HDPayeeInfoModel *_Nonnull payeeInfo) {
    //            @HDStrongify(self);
    //            [self dismissLoading];
    //            payeeInfo.payeeLoginName = payeeNo;
    //
    //            NSString *cy = @"";
    //            if ([decodeData.transactionCurrency isEqualToString:@"840"]) {
    //                cy = PNCurrencyTypeUSD;
    //            } else if ([decodeData.transactionCurrency isEqualToString:@"116"]) {
    //                cy = PNCurrencyTypeKHR;
    //            }
    //
    //            PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];
    //            vc.cy = cy;
    //            vc.merchantId = merchantId;
    //            vc.payeeStoreName = decodeData.storeLabel;
    //            vc.payeeStoreLocation = decodeData.merchantCity;
    //            vc.billNumber = decodeData.billNumber;
    //            if (payeeInfo.isCoolCashAccount == true) {
    //                vc.pageType = PNTradeSubTradeTypeToCoolCash;
    //            } else {
    //                vc.pageType = PNTradeSubTradeTypeToBakongCode;
    //            }
    //            vc.payeeBankName = payeeInfo.bankName.length > 0 ? payeeInfo.bankName : @"Bakong";
    //            vc.qrData = qrCode;
    //
    //            if ([decodeData.transactionAmount doubleValue] > 0) {
    //                SAMoneyModel *orderAmt = [SAMoneyModel new];
    //                orderAmt.cent = [PNCommonUtils yuanTofen:decodeData.transactionAmount];
    //                orderAmt.cy = cy;
    //                payeeInfo.orderAmt = orderAmt;
    //            }
    //            payeeInfo.payeeLoginName = payeeInfo.phone.length > 0 ? payeeInfo.phone : (decodeData.mobileNumber.length > 0 ? decodeData.mobileNumber : payeeNo);
    //            payeeInfo.name = decodeData.merchantName;
    //            payeeInfo.terminalLabel = decodeData.terminalLabel;
    //            payeeInfo.accountId = payeeInfo.phone.length > 0 ? payeeInfo.phone : payeeNo;
    //            vc.payeeInfo = payeeInfo;
    //
    //            [self.navigationController pushViewController:vc animated:YES];
    //        }
    //        failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
    //            @HDStrongify(self);
    //            [self dismissLoading];
    //            [NAT showAlertWithMessage:rspModel.msg
    //                          buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
    //                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
    //                                  [alertView dismiss];
    //                                  [self startRunning];
    //                              }];
    //        }];
}

#pragma mark - private methods
- (void)pushDestViewController:(UIViewController *)descVc dismissSelf:(BOOL)shouldDismissSelf {
    [self.navigationController pushViewController:descVc animated:YES];

    if (shouldDismissSelf) {
        [self.navigationController removeSpecificViewControllerClass:self.class onlyOnce:YES];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
// 识别二维码图片
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (!self.isReading) {
        return;
    }
    if (metadataObjects.count > 0) {
        self.isReading = NO;
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *result = metadataObject.stringValue;
        HDLog(@"scan result:%@", result);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self request:result];
        });
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    static BOOL isStop = false;
    if (isStop)
        return;

    isStop = true;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isStop = false;
    });

    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary *)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (brightnessValue < 0) {
            self.lightBtn.hidden = NO;
        } else if (brightnessValue > 0 && !self.lightBtn.selected) {
            self.lightBtn.hidden = YES;
        }
    });
}

- (void)clickOnLight:(UIButton *)button {
    //判断是否有闪光灯
    if ([self.device hasTorch]) {
        self.lightBtn.selected = !self.lightBtn.selected;

        [self.device lockForConfiguration:nil];
        if (self.lightBtn.selected) {
            [self.device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [self.device setTorchMode:AVCaptureTorchModeOff];
        }
        [self.device unlockForConfiguration];
    }
}

- (void)clickOnFAQ:(UIButton *)button {
    SAAppEnvConfig *model = [SAAppEnvManager sharedInstance].appEnvConfig;
    NSString *url = [NSString stringWithFormat:@"%@%@", model.payH5Url, @"user/faq/detail?id=07&isFromNative=true&"];
    [SAWindowManager openUrl:url withParameters:nil];
}

/**
 拉近镜头

 @param factor 倍数
 */
- (void)captureZoom:(NSInteger)factor {
    if (factor <= self.device.activeFormat.videoMaxZoomFactor && factor >= 1.0) {
        NSError *error = nil;
        if ([self.device lockForConfiguration:&error]) {
            [self.device rampToVideoZoomFactor:factor withRate:1.0];
            [self.device unlockForConfiguration];
        } else {
            HDLog(@"%@", error);
        }
    }
}

/**
 重新对焦通知

 @param notification 通知
 */
- (void)subjectAreaDidChange:(NSNotification *)notification {
    if (self.device.isFocusPointOfInterestSupported && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error = nil;
        if ([self.device lockForConfiguration:&error]) {
            CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:self.scanWindows.center];
            [self.device setFocusPointOfInterest:cameraPoint];
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [self.device unlockForConfiguration];
            HDLog(@"%@", @"Focus...");
        } else {
            HDLog(@"lock camera error%@", error);
        }

    } else {
        HDLog(@"%@", @"no support autoFocus!");
    }
}

- (void)DistinguishImage {
    // 判断系统是否支持相机
    [self showloading];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    __weak __typeof(self) weakSelf = self;

    // 修改状态栏样式
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerController animated:YES completion:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        //        strongSelf.hd_preferredStatusBarStyle = UIStatusBarStyleDefault;
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
        [strongSelf dismissLoading];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [self showloading];
    _scanBeginTime = [NSDate new];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    __block NSString *result = @"";
    // self 强引用了 picker
    __weak __typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        //        strongSelf.hd_preferredStatusBarStyle = UIStatusBarStyleLightContent;
        UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
        result = [strongSelf distinguish:image];

        [strongSelf dismissLoading];
        if ([result isEqualToString:@""]) {
            [NAT showAlertWithMessage:PNLocalizedString(@"ALERT_MSG_QRCODE_NO_FOUND", @"找不到二维码") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                              handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                  [alertView dismiss];
                              }];
        } else {
            [strongSelf request:result];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    [picker dismissViewControllerAnimated:true completion:nil];
}

/**
 识别二维码
 */
- (NSString *)distinguish:(UIImage *)image {
    // 1. 初始化扫描仪，设置设别类型和识别质量
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    // 2. 扫描获取的特征组
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    // 3. 获取扫描结果

    if (features.count == 0) {
        return @"";
    }
    CIQRCodeFeature *feature = [features objectAtIndex:0];
    NSString *scannedResult = feature.messageString;
    return scannedResult;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return false;
}

#pragma mark - private methods
- (BOOL)isPushedFromRechargeableCardView {
    BOOL ret = NO;

    return ret;
}

#pragma mark - lazy load
- (PNTransListDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNTransListDTO alloc] init];
    }
    return _transDTO;
}

@end
