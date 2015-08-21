//
//  UIViewController+WAAppLinkParameters.h
//  WAAppRouter
//
//  Created by Marian Paul on 21/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import UIKit;

@class WAAppLink;
@protocol WAAppRouterParametersProtocol;

@interface UIViewController (WAAppLinkParameters)

- (void)configureWithAppLink:(WAAppLink *)appLink defaultParameters:(id <WAAppRouterParametersProtocol>)defaultParameters allowedParameters:(NSArray *)allowedParameters;

@property (nonatomic, strong) WAAppLink *appLink;
@property (nonatomic, strong) id <WAAppRouterParametersProtocol>appLinkRoutingParameters;

@end
