//
//  WAAppRouter.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppRouter.h"

#import "WAAppMacros.h"

#import "WAAppRouteRegistrar.h"
#import "WAAppRouteEntity.h"
#import "WAAppLink.h"

@interface WAAppRouter ()

@property (nonatomic, strong) WAAppRouteRegistrar *registrar;
@property (nonatomic, strong) id<WAAppRouteHandlerProtocol> routeHandler;

@end

@implementation WAAppRouter

- (instancetype)initWithRegistrar:(WAAppRouteRegistrar *)registrar routeHandler:(id<WAAppRouteHandlerProtocol>)routeHandler {
    WAAppRouterClassAssertion(registrar, WAAppRouteRegistrar);
    WAAppRouterProtocolAssertion(routeHandler, WAAppRouteHandlerProtocol);
    
    self = [super init];
    if (self) {
        self->_registrar    = registrar;
        self->_routeHandler = routeHandler;
    }
    
    return self;
}

- (BOOL)handleURL:(NSURL *)url {
    if (!url) {
        return NO;
    }
    
    // Check for a block
    WAAppRouteHandlerBlock block  = [self.registrar blockHandlerForURL:url];
    // Check for an entity
    WAAppRouteEntity *routeEntity = [self.registrar entityForURL:url];
    
    // If there is nothing then this URL is not handled
    if (!routeEntity && !block) {
        return NO;
    }
    
    // Get the route parameters
    NSDictionary *routeParameters = [self.registrar.routeMatcher parametersFromURL:url
                                                                   withPathPattern:routeEntity.path];
    // Init the link
    WAAppLink *link = [[WAAppLink alloc] initWithURL:url
                                     routeParameters:routeParameters];
    
    // Execute the block if existing
    BOOL handled = NO;
    if (block) {
        handled = YES;
        block(link);
    }
    
    // Handle the entity
    handled = [self.routeHandler handleURL:url
                           withRouteEntity:routeEntity
                                   appLink:link];
    return handled;
}

- (BOOL)handleUserActivity:(NSUserActivity *)userActivity {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return [self handleURL:userActivity.webpageURL];
    }
    
    return NO;
}

@end
