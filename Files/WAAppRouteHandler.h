//
//  WAAppRouteHandler.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppRouteHandlerProtocol.h"

@class WAAppRouteRegistrar;

/**
 @brief. An implementation of the `WAAppRouteHandlerProtocol` protocol which only deals with navigation controllers and handle a stack
 */
@interface WAAppRouteHandler : NSObject <WAAppRouteHandlerProtocol>

/**
 *  Init with a route registrar. The registrar contains all the `WAAppRouteEntity` and is necessary for retrieving the entity stack.
 *
 *  @param registrar the registrar containing all the entities
 * 
 *  @param rootViewController the root view controller for the view controller hierarchy.
 *
 *  @return a route handler to feed the router
 */
- (instancetype)initWithRouteRegistrar:(WAAppRouteRegistrar *)registrar rootViewController:(UIViewController *)rootViewController NS_DESIGNATED_INITIALIZER;

/**
 * @see `initWithRouteRegistrar:`
 */
+ (instancetype)routeHandlerWithRouteRegistrar:(WAAppRouteRegistrar *)registrar rootViewController:(UIViewController *)rootViewController;

@property (nonatomic, strong, readonly) WAAppRouteRegistrar *registrar;

@end

/**
 *  This key helps to force an animation instead of letting the route handler guess it. Use it on last shot ^^
 */
FOUNDATION_EXTERN NSString * const kWAAppRoutingForceAnimationKey;