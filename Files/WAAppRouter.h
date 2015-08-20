//
//  WAAppRouter.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;
#import "WAAppRouteHandlerProtocol.h"

@class WAAppRouteRegistrar;

/**
 @brief This class is the input point of the routing. You should ask it to handle a URL
 */
@interface WAAppRouter : NSObject

/**
 *  Init the router
 *
 *  @param registrar    the registrar which contains all the routes association with entities or blocks
 *  @param routeHandler the route handler used to deal with controller stack
 *
 *  @return a fresh router
 */
- (instancetype)initWithRegistrar:(WAAppRouteRegistrar *)registrar routeHandler:(id <WAAppRouteHandlerProtocol>)routeHandler NS_DESIGNATED_INITIALIZER;

/**
 *  Handle the URL you pass it
 *
 *  @param url the url you received from App Delegate
 *
 *  @return YES if the URL is handled, NO otherwise
 */
- (BOOL)handleURL:(NSURL *)url;

/**
 *  Handle user activity (iOS 9 feature)
 *
 *  @param userActivity the user activity received on App Delegate
 *
 *  @return YES if the URL is handled, NO otherwise
 */
- (BOOL)handleUserActivity:(NSUserActivity *)userActivity;

@end
 