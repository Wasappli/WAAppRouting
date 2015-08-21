//
//  WAAppRouter+WADefaultRouter.m
//  WAAppRouter
//
//  Created by Marian Paul on 21/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppRouter+WADefaultRouter.h"
#import "WAAppRouteMatcher.h"
#import "WAAppRouteRegistrar.h"
#import "WAAppRouteHandler.h"

@implementation WAAppRouter (WADefaultRouter)

+ (instancetype) defaultRouterWithRootViewController:(UIViewController *)rootViewController {
    
    // Allocate the default route matcher
    WAAppRouteMatcher *routeMatcher = [WAAppRouteMatcher new];
    
    // Create the Registrar
    WAAppRouteRegistrar *registrar  = [WAAppRouteRegistrar registrarWithRouteMatcher:routeMatcher];
    
    // Create the route handler
    WAAppRouteHandler *routeHandler = [WAAppRouteHandler routeHandlerWithRouteRegistrar:registrar rootViewController:rootViewController];
    
    // Create the router
    return [WAAppRouter routerWithRegistrar:registrar
                               routeHandler:routeHandler];
}

@end
