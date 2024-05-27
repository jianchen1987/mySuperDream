//
//  SAAppEnvConfig.h
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

typedef NSString *SAAppEnvType NS_STRING_ENUM;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT SAAppEnvType const SAAppEnvTypeProduct;
FOUNDATION_EXPORT SAAppEnvType const SAAppEnvTypeBakcup;
FOUNDATION_EXPORT SAAppEnvType const SAAppEnvTypeUAT;
FOUNDATION_EXPORT SAAppEnvType const SAAppEnvTypeSIT;
FOUNDATION_EXPORT SAAppEnvType const SAAppEnvTypeMOCK;
FOUNDATION_EXPORT SAAppEnvType const SAAppEnvTypeFAT;
FOUNDATION_EXPORT SAAppEnvType const SAAppEnvTypePreRelease;


@interface SAAppEnvConfig : SAModel
///< 类型
@property (nonatomic, copy) SAAppEnvType type;
///< 名称
@property (nonatomic, copy) NSString *name;
/// base URL
@property (nonatomic, copy) NSString *serviceURL;
/// 文件服务
@property (nonatomic, copy) NSString *fileServer;
/// ocr服务
@property (nonatomic, copy) NSString *ocrServer;
/// H5 base url
@property (nonatomic, copy) NSString *h5URL;
/// 文件下载地址
@property (nonatomic, copy) NSString *downloadURL;
#pragma mark - PayNow
/// base 支付平台URL
@property (nonatomic, copy) NSString *payServiceURL;
/// 支付H5URL
@property (nonatomic, copy) NSString *payH5Url;
/// 支付 文件服务器
@property (nonatomic, copy) NSString *payFileServer;
/// 支付CAM 网关
@property (nonatomic, copy) NSString *coolcashcam;

#pragma mark - 电商
/// 电商H5地址
@property (nonatomic, copy) NSString *tinhNowHost;
/// 电商埋点日志服务器URL
@property (nonatomic, copy) NSString *tinhNowLog;

@end

NS_ASSUME_NONNULL_END
