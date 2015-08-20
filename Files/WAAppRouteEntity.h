//
//  WAAppRouteEntity.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import UIKit;

#import "WAAppRouterParametersProtocol.h"

/**
 *  A block called when the entity gets invoked to refresh and get the default parameters.
 *
 *  @return You should return an object conforms to protocol `WAAppRouterParametersProtocol`
 */
typedef id <WAAppRouterParametersProtocol> (^WAAppRouterDefaultParametersBuilderBlock)(void);

/**
 @brief
 This class is the heart of the router. This is the object you want to create and configure to get the controller stack working automatically or almost.
 Please read the README for special considerations.
 */
@interface WAAppRouteEntity : NSObject

/**
 *  Initialize your entity with values
 *
 *  @param name                     This might help in the future (and for now on debug)
 *  @param path                     The url path for reaching this entity. Could include the scheme+host (http/https) or the app scheme or not. Please note that only one entity per path is valid. Also supports the joker `*`
 *  @param sourceControllerClass    the controller class shown in the stack before the target controller. Might be nil if modal or if the first one in stack. If nil, then the entity is considered as the first one on the stack
 *  @param targetControllerClass    the target controller class means the controller class you will use to display the path
 *  @param presentingController     the presenting controller to use. Might not be nil except for the modal and will frequently be a `UINavigationController`. Also see special considerations in README for custom container use
 *  @param prefersModalPresentation set `YES` if you want this to be triggered as a modal
 *  @param defaultParametersBuilder a block to pass some default parameters (only works with `WAAppLinkParameters` subclass or any class which implements `WAAppRouterParametersProtocol`)
 *  @param allowedParameters        a list of allowed parameters (only works with `WAAppLinkParameters` subclass or any class which implements `WAAppRouterParametersProtocol`). The values are supposed to be the subclass properties name
 *
 *  @return an entity to feed the router
 */
- (instancetype)initWithName:(NSString *)name
                        path:(NSString *)path
       sourceControllerClass:(Class)sourceControllerClass
       targetControllerClass:(Class)targetControllerClass
        presentingController:(UIViewController *)presentingController
    prefersModalPresentation:(BOOL)prefersModalPresentation
    defaultParametersBuilder:(WAAppRouterDefaultParametersBuilderBlock)defaultParametersBuilder
           allowedParameters:(NSArray *)allowedParameters;

@property (nonatomic, strong, readonly) NSString         *name;
@property (nonatomic, strong, readonly) NSString         *path;
@property (nonatomic, strong, readonly) Class            sourceControllerClass;
@property (nonatomic, strong, readonly) Class            targetControllerClass;
@property (nonatomic, strong, readonly) UIViewController *presentingController;
@property (nonatomic, assign, readonly) BOOL             preferModalPresentation;
@property (nonatomic, strong, readonly) NSArray          *allowedParameters;

@property (nonatomic, copy, readonly  ) WAAppRouterDefaultParametersBuilderBlock defaultParametersBuilder; // We are using block to call to refresh parameters if they depend on time or what so ever kind of parameter

@end
