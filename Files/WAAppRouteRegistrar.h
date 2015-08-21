//
//  WAAppRouteRegistrar.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;
#import "WAAppRouterMatcherProtocol.h"

@class WAAppRouteEntity, WAAppLink;

typedef void (^WAAppRouteHandlerBlock)(WAAppLink *appLink);

/**
 @brief This class intention is to register both `WAAppRouteEntity` objects or blocks matching a path
 */
@interface WAAppRouteRegistrar : NSObject

/**
 *  Initialize the registrar with a route matcher
 *
 *  @param routeMatcher the route matcher you wish to use to match urls against patterns
 *
 *  @return a fresh registrar
 */
- (instancetype)initWithRouteMatcher:(id <WAAppRouteMatcherProtocol>)routeMatcher NS_DESIGNATED_INITIALIZER;

/**
 *  @see `initWithRouteMatcher:`
 */
+ (instancetype)registrarWithRouteMatcher:(id <WAAppRouteMatcherProtocol>)routeMatcher;

/**
 *  Register a new route entity
 *
 *  @param entity the entity to register
 */
- (void)registerAppRouteEntity:(WAAppRouteEntity *)entity;

/**
 *  Register a block handler
 *
 *  @param routeBlockHandler the block handler
 *  @param route             the route you want the block to triggers on call
 */
- (void)registerBlockRouteHandler:(WAAppRouteHandlerBlock)routeBlockHandler forRoute:(NSString *)route;

/**
 *  Retrieve an entity from a route URL
 *
 *  @param url the URL you received in input
 *
 *  @return the corresponding entity
 */
- (WAAppRouteEntity *)entityForURL:(NSURL *)url;

/**
 *  Get the block handler for a URL
 *
 *  @param url the URL you received in input
 *
 *  @return the block to execute
 */
- (WAAppRouteHandlerBlock)blockHandlerForURL:(NSURL *)url;

/**
 *  Retrieve an entity from a class you want to display
 *
 *  @param targetClass the class you want to display
 *
 *  @return the corresponding entity
 */
- (WAAppRouteEntity *)entityForTargetClass:(Class)targetClass;

@property (nonatomic, strong, readonly) id <WAAppRouteMatcherProtocol>routeMatcher;

@end
