//
//  SAViewModel.m
//  SuperApp
//
//  Created by VanJay on 2020/3/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"


@implementation SAViewModel

@synthesize request = _request;
@synthesize view = _view;
@synthesize isNetworkError = _isNetworkError;
@synthesize isBusinessDataError = _isBusinessDataError;
@synthesize isRequestFailed = _isRequestFailed;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    SAViewModel *viewModel = [super allocWithZone:zone];
    if (viewModel) {
        [viewModel hd_initialize];
    }
    return viewModel;
}

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    if (_request) {
        [self.request cancel];
    }
}

- (CMNetworkRequest *)request {
    if (!_request) {
        _request = [CMNetworkRequest new];
    }
    return _request;
}

- (void)hd_initialize {
}

- (void)hd_bindView:(UIView *)view {
    self.view = view;
}

- (BOOL)isRequestFailed {
    return self.isBusinessDataError || self.isNetworkError;
}
@end
