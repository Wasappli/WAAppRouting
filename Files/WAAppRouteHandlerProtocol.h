//
//  WAAppRouteHandlerProtocol.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import UIKit;

@class WAAppRouteEntity, WAAppLink;

/**
 *  A block to know if an entity should be handled by the block or not
 *
 *  @param routeEntity the entity we wish to show
 *
 *  @return YES if we should continue, NO otherwise
 */
typedef BOOL (^WAAppRouteHandlerShouldHandleAppLinkForRouteEntityBlock)(WAAppRouteEntity *routeEntity);

/**
 *  A block used to preconfigured the controller we are trying to place in the stack. This block is called everytime before reloading the controller with the app link
 *
 *  @param controller  the controller we will configure
 *  @param routeEntity the route entity fitting with the controller
 *  @param appLink     the app link which will be set
 */
typedef void (^WAAppRouterTargetControllerPreConfigurationBlock)(UIViewController *controller, WAAppRouteEntity *routeEntity, WAAppLink *appLink);

@protocol WAAppRouteHandlerProtocol <NSObject>

/**
 *  This method is called by the router to handle the controller stack
 *
 *  @param url         the url we want to handle
 *  @param routeEntity the entity which fits the url
 *  @param appLink     the app link the controllers need to get
 *
 *  @return YES if the route has been handled, NO otherwise
 */
- (BOOL)handleURL:(NSURL *)url withRouteEntity:(WAAppRouteEntity *)routeEntity appLink:(WAAppLink *)appLink;

@optional

@property (nonatomic, copy) WAAppRouteHandlerShouldHandleAppLinkForRouteEntityBlock shouldHandleAppLinkBlock;
@property (nonatomic, copy) WAAppRouterTargetControllerPreConfigurationBlock        controllerPreConfigurationBlock;

@end
