//
//  SAPhotoView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPhotoView.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIView+HD_Extension.h>
#import <HDUIKit/HDAppTheme.h>
#import <HDUIKit/HDImageUploadAddImageView.h>


@implementation SAPhotoView

+ (instancetype)photoManager:(HXPhotoManager *)manager {
    return [SAPhotoView photoManager:manager addViewBackgroundColor:nil];
}

+ (instancetype)photoManager:(HXPhotoManager *)manager addViewBackgroundColor:(UIColor *_Nullable)color {
    SAPhotoView *view = [super photoManager:manager];
    // clang-format off
    BeginIgnoreClangWarning(-Wundeclared-selector);
    if ([view respondsToSelector:@selector(addModel)]) {
        EndIgnoreClangWarning;
        // clang-format on
        HXPhotoModel *addModel = [view valueForKey:@"addModel"];
        if ([addModel isKindOfClass:HXPhotoModel.class]) {
            HDImageUploadAddImageView *addImageView = [[HDImageUploadAddImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            addImageView.cameraImageView.image = [UIImage imageNamed:@"camera"];
            addImageView.descLabel.text = SALocalizedString(@"add_picture", @"添加照片");
            addImageView.descLabel.textColor = HDAppTheme.color.G2;
            if (color) {
                addImageView.backgroundColor = color;
            }
            [addImageView setNeedsLayout];
            [addImageView layoutIfNeeded];
            UIImage *addImage = [addImageView snapshotImage];
            addModel.thumbPhoto = addImage;
        }
    }
    return view;
}

@end
