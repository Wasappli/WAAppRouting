//
//  UIViewController+WAAppLinkParameters.m
//  WAAppRouter
//
//  Created by Marian Paul on 21/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "UIViewController+WAAppLinkParameters.h"
#import "WAAppLink.h"
#import "WAAppMacros.h"
#import "WAAppRouterTargetControllerProtocol.h"
#import "WAAppRouterParametersProtocol.h"

@import ObjectiveC.runtime;

@implementation UIViewController (WAAppLinkParameters)
@dynamic appLink;
@dynamic appLinkRoutingParameters;

- (void)configureWithAppLink:(WAAppLink *)appLink defaultParameters:(id<WAAppRouterParametersProtocol>)defaultParameters allowedParameters:(NSArray *)allowedParameters {
    
    // Check one last time
    WAAppRouterProtocolAssertion(self, WAAppRouterTargetControllerProtocol);
    
    self.appLink = appLink;
    
    // Grab the parameters from the link
    NSMutableDictionary *rawParameters = [NSMutableDictionary dictionaryWithDictionary:appLink.queryParameters];
    if (appLink.routeParameters) {
        [rawParameters setValuesForKeysWithDictionary:appLink.routeParameters];
    }
    
    // Erase all previous params and allocate with allowed parameters provided by the entity
    Class parametersClass = Nil;
    if ([[self class] respondsToSelector:@selector(appLinkParametersClass)]) {
        parametersClass = [[(id<WAAppRouterTargetControllerProtocol>)self class] appLinkParametersClass];
    } else {
        parametersClass = [NSMutableDictionary class];
    }
    
    self.appLinkRoutingParameters = [[parametersClass alloc] initWithAllowedParameters:allowedParameters];
    
    // Merge with the default parameters provided by the entity
    [self.appLinkRoutingParameters mergeWithAppRouterParameters:defaultParameters];
    
    // Now set the values from the query itself
    [self.appLinkRoutingParameters mergeWithRawParameters:rawParameters];
    
    [(id<WAAppRouterTargetControllerProtocol>)self reloadFromAppLinkRefresh];
}

#pragma mark - Association references

- (void)setAppLink:(WAAppLink *)appLink {
    objc_setAssociatedObject(self, @selector(appLink), appLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WAAppLink *)appLink {
    return objc_getAssociatedObject(self, @selector(appLink));
}

- (void)setAppLinkRoutingParameters:(id<WAAppRouterParametersProtocol>)appLinkRoutingParameters {
    objc_setAssociatedObject(self, @selector(appLinkRoutingParameters), appLinkRoutingParameters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<WAAppRouterParametersProtocol>)appLinkRoutingParameters {
    return objc_getAssociatedObject(self, @selector(appLinkRoutingParameters));
}

@end
