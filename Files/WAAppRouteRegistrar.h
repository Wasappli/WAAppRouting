//
//  WAAppRouteRegistrar.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import UIKit;
#import "WAAppRouterMatcherProtocol.h"
#import "WAAppRouteEntity.h"

@class WAAppLink;

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
 *  @see `registerAppRoutePath:presentingController:defaultParametersBuilderBlock:allowedParametersBlock:`
 *
 *  @param routePath            the path with special syntax
 *  @param presentingController the navigation controller used to display the controllers stack
 */
- (void)registerAppRoutePath:(NSString *)routePath presentingController:(UIViewController *)presentingController;

/**
 *  Register a route path. This avoids you to write several route entity. You can then define paths along with their controllers.
 *  The syntax is the following:
 *  `url_path_component{ClassName}`
 *  `url_path_component1{ClassName1}/url_path_component2{ClassName2}`
 *
 *  Optionaly, you can trigger the modal presentation using `!` character. For example:
 *  `url_path_component{ClassName}/modal{ModalClass}!` 
 *  would result when calling `appscheme://url_path_component/modal` to `ModalClass` instance presented modally after placing `ClassName` in navigation controller stack.
 *
 *  @param routePath                     the path with special syntax
 *  @param presentingController          the navigation controller used to display the controllers stack
 *  @param defaultParametersBuilderBlock a block called for each path component found, so that you can provide a block for building default parameters. Yes, this is block inside block
 *  @param allowedParametersBlock        a block called for each path component found, so that you can provide an array of allowed parameters @see `WAAppRouteEntity`
 */
- (void)registerAppRoutePath:(NSString *)routePath presentingController:(UIViewController *)presentingController defaultParametersBuilderBlock:(WAAppRouterDefaultParametersBuilderBlock (^)(NSString *path))defaultParametersBuilderBlock allowedParametersBlock:(NSArray* (^)(NSString *path))allowedParametersBlock;

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
 *  @param url         the URL you received in input
 *  @param pathPattern the pattern used to register the entity
 *
 *  @return the block to execute
 */
- (WAAppRouteHandlerBlock)blockHandlerForURL:(NSURL *)url pathPattern:(NSString *__autoreleasing *)pathPattern;

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
