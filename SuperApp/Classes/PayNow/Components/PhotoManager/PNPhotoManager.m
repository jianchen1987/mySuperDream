//
//  PNPhotoManager.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPhotoManager.h"
#import "HDAppTheme+PayNow.h"
#import "SAMultiLanguageManager.h"


@implementation PNPhotoManager
- (instancetype)initWithType:(HXPhotoManagerSelectedType)type {
    if (self = [super initWithType:type]) {
        self.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
        self.configuration.openCamera = YES;
        self.configuration.popupTableViewCellHeight = 64;
        self.configuration.popupTableViewCellAlbumNameColor = HDAppTheme.PayNowColor.c333333;
        self.configuration.popupTableViewCellAlbumNameFont = HDAppTheme.PayNowFont.standard15;
        self.configuration.popupTableViewCellPhotoCountColor = HDAppTheme.PayNowColor.c333333;
        self.configuration.popupTableViewCellPhotoCountFont = HDAppTheme.PayNowFont.standard15;
        self.configuration.photoMaxNum = 9;
        self.configuration.themeColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.configuration.photoCanEdit = false;
        self.configuration.popupTableViewHeight = kScreenHeight * 0.8;
        self.configuration.supportRotation = false;
        HXPhotoLanguageType type = HXPhotoLanguageTypeEn;
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            type = HXPhotoLanguageTypeSc;
        }
        self.configuration.languageType = type;
    }
    return self;
}
@end
