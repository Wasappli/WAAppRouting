//
//  WAAppRouteHandler.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppRouteHandler.h"
#import "WAAppMacros.h"

#import "WAAppRoutingContainerPresentationProtocol.h"
#import "WAAppRouterTargetControllerProtocol.h"

#import "WAAppRouteEntity.h"
#import "WAAppRouteRegistrar.h"
#import "WAAppLink.h"

#import "UINavigationController+WAAdditions.h"
#import "UIViewController+WAAppLinkParameters.h"

@interface WAAppRouteHandler ()

@property (nonatomic, strong) WAAppRouteRegistrar *registrar;

@end

@implementation WAAppRouteHandler
@synthesize shouldHandleAppLinkBlock        = _shouldHandleAppLinkBlock;
@synthesize controllerPreConfigurationBlock = _controllerPreConfigurationBlock;

- (instancetype)initWithRouteRegistrar:(WAAppRouteRegistrar *)registrar {
    WAAppRouterClassAssertion(registrar, WAAppRouteRegistrar);
    self = [super init];
    
    if (self) {
        self->_registrar = registrar;
    }
    
    return self;
}

+ (instancetype)routeHandlerWithRouteRegistrar:(WAAppRouteRegistrar *)registrar {
    return [[self alloc] initWithRouteRegistrar:registrar];
}

- (BOOL)handleURL:(NSURL *)url withRouteEntity:(WAAppRouteEntity *)routeEntity appLink:(WAAppLink *)appLink {
    WAAppRouterClassAssertion(url, NSURL);
    WAAppRouterClassAssertion(routeEntity, WAAppRouteEntity);
    
    // Check if the entity should be discarded or not
    if ([self respondsToSelector:@selector(shouldHandleAppLinkBlock)] && self.shouldHandleAppLinkBlock) {
        BOOL shouldHandle = self.shouldHandleAppLinkBlock(routeEntity);
        if (!shouldHandle) {
            return NO;
        }
    }
    
    // Get all the entities we need to create the stack
    NSArray *allEntitiesWeNeedInStack = [self retrieveStackEntitiesFromEntity:routeEntity];
    
    // Remove all the entities which are not in the stack yet. We do not want to recreate controllers already in the stack
    NSArray *entitiesNotInStackYet    = [self retrieveEntitiesNotInStackYetFromEntities:allEntitiesWeNeedInStack];
    
    // If the count is superior, we might clean the navigation controller before continuing (meaning poping to the last we already have in the stack)
    if ([allEntitiesWeNeedInStack count] > [entitiesNotInStackYet count]) {
        WAAppRouteEntity *lastEntityNeededInStack = allEntitiesWeNeedInStack[[allEntitiesWeNeedInStack count] - [entitiesNotInStackYet count] - 1];
        // Animate only if we have nothing to put in stack
        [self popToEntity:lastEntityNeededInStack animated:[entitiesNotInStackYet count] == 0];
    }
    
    WAAppRouteEntity *firstEntity = [allEntitiesWeNeedInStack firstObject];
    
    BOOL success = YES;
    
    UIViewController *previousController = nil;
    // Now well... Reload and rebuild the path baby
    for (WAAppRouteEntity *entity in allEntitiesWeNeedInStack) {
        // If the entity is not in the stack yet, it is time to push it
        if ([entitiesNotInStackYet containsObject:entity]) {
            
            // Deal with animation (last one is always animated)
            BOOL animated = [entity isEqual:routeEntity] ? YES : NO;
            
            // But if the stack has only one object, then do not animate it except if this is a modal.
            // If you are here because you are poping to the first controller, you might consider `kWAAppRoutingForceAnimationKey`
            if ([allEntitiesWeNeedInStack count] == 1) {
                if (!entity.preferModalPresentation) {
                    animated = NO;
                }
            }
            
            // Finally, see if we are trying to force the behavior
            if (appLink[kWAAppRoutingForceAnimationKey]) {
                animated = [appLink[kWAAppRoutingForceAnimationKey] boolValue];
            }
            
            // Present the entity
            previousController = [self presentEntity:entity
                                      fromController:previousController
                                         withAppLink:appLink
                                            animated:animated];
        }
        else {
            // The entity is in the stack, reload it
            previousController = [self reloadEntity:entity
                                        withAppLink:appLink];
        }
        
        // In case the entity is the first one in the path
        // We want to handle any containers in the controller stack
        // For example ask the tab bar controller to set the correct index displayed
        if ([entity isEqual:firstEntity]) {
            success = [self handleContainerForPresentingController:firstEntity.presentingController
                                                   childController:previousController
                                                          animated:YES];
        }
    }
    
    return success;
}

#pragma mark - Stack Management

// Retrieve the navigation controller for an entity
- (UINavigationController *)navigationControllerControllerForEntity:(WAAppRouteEntity *)entity {
    UINavigationController *navigationController = nil;
    // Easiest one: get the `presentingController` property
    if ([entity.presentingController isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)entity.presentingController;
    }
    
    // Then if the presenting controller conforms to WAAppRoutingContainerPresentationProtocol, ask it the navigation controller to use
    if ([entity.presentingController conformsToProtocol:@protocol(WAAppRoutingContainerPresentationProtocol)]) {
        if ([entity.presentingController respondsToSelector:@selector(waapplink_navigationControllerForPresentingEntity:)]) {
            navigationController = [(id <WAAppRoutingContainerPresentationProtocol>)entity.presentingController waapplink_navigationControllerForPresentingEntity:entity];
        }
    }
    
    WAAssert(navigationController && [navigationController isKindOfClass:[UINavigationController class]] || !navigationController, ([NSString stringWithFormat:@"Error: cannot retrieve a navigation controller for presenting entity %@", entity]));
    return navigationController;
}

// Build the stack of entities for presenting the last we need
- (NSArray *)retrieveStackEntitiesFromEntity:(WAAppRouteEntity *)fromEntity {
    NSMutableArray *allEntities = [NSMutableArray array];
    if (fromEntity.sourceControllerClass) {
        WAAppRouteEntity *currentEntity = fromEntity;
        do {
            currentEntity = [self.registrar entityForTargetClass:currentEntity.sourceControllerClass];
            if (currentEntity) {
                [allEntities insertObject:currentEntity atIndex:0];
            }
        } while (currentEntity);
    }

    [allEntities addObject:fromEntity];
    
    return [allEntities copy];
}

// Remove entities already in stack and return only the new ones
// We start by the first one in the stack
- (NSArray *)retrieveEntitiesNotInStackYetFromEntities:(NSArray *)entities {
    NSMutableArray *cleanedArray = [NSMutableArray arrayWithArray:entities];
    
    NSInteger currentIndex = 0;
    BOOL shouldStop = NO;
    
    while (!shouldStop) {
        // We are too far and should stop
        if (currentIndex >= [entities count]) {
            shouldStop = YES;
            break;
        }
        
        WAAppRouteEntity *entity = entities[currentIndex];
        
        // If we have a modal, then we restart from scratch (to be tested)
        if (entity.preferModalPresentation) {
            shouldStop = YES;
            break;
        }
        
        UINavigationController *presentingViewController = [self navigationControllerControllerForEntity:entity];
        
        if ([presentingViewController isKindOfClass:[UINavigationController class]]) {
            
            // The index is too far for the current controller count
            if (currentIndex >= [presentingViewController.viewControllers count]) {
                shouldStop = YES;
                break;
            }
            
            // Take one by one the controllers in the stack and check if the path is respected
            UIViewController *currentIndexControllerInStack = presentingViewController.viewControllers[currentIndex];
            if ([currentIndexControllerInStack isKindOfClass:entity.targetControllerClass]) {
                [cleanedArray removeObject:entity];
            }
            else {
                shouldStop = YES;
                break;
            }
            
            currentIndex ++;
        }
        else {
            // This is not a navigation controller sooooo stop?
            // Should not even happen
            shouldStop = YES;
            break;
        }
    }
    
    return cleanedArray;
}

#pragma mark - Present or reload

// Configure the controller with the app link
- (void) configureController:(UIViewController *)controller fromEntity:(WAAppRouteEntity *)entity appLink:(WAAppLink *)appLink {
    // Get the default parameters
    id <WAAppRouterParametersProtocol> defaultParameters = entity.defaultParametersBuilder ? entity.defaultParametersBuilder() : nil;
    WAAppRouterParameterAssert(defaultParameters && [defaultParameters conformsToProtocol:@protocol(WAAppRouterParametersProtocol)] || !defaultParameters);
    
    WAAssert(controller, @"You should have a controller at this point");
    
    // Call the preconfiguration block if existing
    if ([self respondsToSelector:@selector(controllerPreConfigurationBlock)] && self.controllerPreConfigurationBlock) {
        self.controllerPreConfigurationBlock((UIViewController *)controller, entity, appLink);
    }
    
    [controller configureWithAppLink:appLink
                   defaultParameters:defaultParameters
                   allowedParameters:entity.allowedParameters];
}

- (UIViewController *) presentEntity:(WAAppRouteEntity *)entity fromController:(UIViewController *)fromController withAppLink:(WAAppLink *)appLink animated:(BOOL)animated {
    
    // First, present the controller
    UIViewController *targetViewController =
    [self presentTargetViewControllerClass:entity.targetControllerClass
      inNavigationControllerViewController:[self navigationControllerControllerForEntity:entity]
                   preferModalPresentation:entity.preferModalPresentation
                                  animated:animated];
    
    // Configure it
    [self configureController:targetViewController
                   fromEntity:entity
                      appLink:appLink];
    
    // Tell it that it displayed a new controller
    if ([(id<WAAppRouterTargetControllerProtocol>)fromController respondsToSelector:@selector(waappRoutingDidDisplayController:withAppLink:)]) {
        [(id<WAAppRouterTargetControllerProtocol>)fromController waappRoutingDidDisplayController:targetViewController
                                                                                      withAppLink:appLink];
    }
    
    return targetViewController;
}

- (UIViewController *) reloadEntity:(WAAppRouteEntity *)entity withAppLink:(WAAppLink *)appLink {
    
    // Retrieve the target controller in the navigation controller
    UIViewController *targetViewController =
    [self viewControllerForClass:entity.targetControllerClass
          inNavigationController:[self navigationControllerControllerForEntity:entity]];
    
    // Configure it
    [self configureController:targetViewController
                   fromEntity:entity
                      appLink:appLink];
    
    return targetViewController;
}

// Pop to a specific entity
- (void) popToEntity:(WAAppRouteEntity *)entity animated:(BOOL)animated {
    [[self navigationControllerControllerForEntity:entity] waapp_popToFirstControllerOfClass:entity.targetControllerClass animated:animated];
}

#pragma mark - View controller management

- (UIViewController *)rootViewController {
#ifndef WA_APP_EXTENSION
  return [[[UIApplication sharedApplication] keyWindow] rootViewController];
#endif
  
  return nil;
}

// Present the controller and deal with where it should be
- (UIViewController *)presentTargetViewControllerClass:(Class)targetViewControllerClass
                  inNavigationControllerViewController:(UINavigationController *)navigationController
                               preferModalPresentation:(BOOL)preferModalPresentation
                                              animated:(BOOL)animated {
    
    UIViewController *controllerToReturn = nil;
    
    // First: is it shown as modal?
    if (preferModalPresentation) {
        // Allocate the controller
        controllerToReturn = [[targetViewControllerClass alloc] init];
        // Allocate a navigation controller
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:(UIViewController *)controllerToReturn];
        
        // Get the controller which will act as the presentation controller
        UIViewController *presentingViewController = navigationController;
        if (!presentingViewController) {
          presentingViewController = [self rootViewController];
        }
        // Present
        [presentingViewController presentViewController:navController animated:animated completion:NULL];
    }
    else if ([navigationController isKindOfClass:[UINavigationController class]]) {
        // Second: is the controller a navigation controller?
        // If yes, then place it
        controllerToReturn = [self placeTargetViewControllerClass:targetViewControllerClass
                                           inNavigationController:navigationController
                                                         animated:animated];
    }
    else {
        // Based on the assumption we made on the call stack, we do not have a navigation controller. So let's allocate it and see if there is any container gentle enough to embrass it
        controllerToReturn = [[targetViewControllerClass alloc] init];
    }
    
    return controllerToReturn;
}

- (UIViewController *)placeTargetViewControllerClass:(Class)targetViewControllerClass
                              inNavigationController:(UINavigationController *)navigationController
                                            animated:(BOOL)animated {
    
    // Try to find it in the current stack
    UIViewController *controllerToReturn = (UIViewController *)[navigationController waapp_popToFirstControllerOfClass:targetViewControllerClass animated:animated];
    // Not found? Then allocate it
    if (!controllerToReturn) {
        controllerToReturn = [[targetViewControllerClass alloc] init];
        [navigationController pushViewController:controllerToReturn animated:animated];
    }
    
    return controllerToReturn;
}

- (UIViewController *)viewControllerForClass:(Class)controllerClass inNavigationController:(UINavigationController *)navigationController {
    UIViewController *controllerFound = nil;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        for (UIViewController *controller in ((UINavigationController *)navigationController).viewControllers) {
            if ([controller isKindOfClass:controllerClass]) {
                controllerFound = controller;
                break;
            }
        }
    }
    
    return controllerFound;
}

- (BOOL) handleContainerForPresentingController:(UIViewController *)presentingController childController:(UIViewController *)childController animated:(BOOL)animated {
    
    // Go through every parent controller we have and see if we can use them with `WAAppRoutingContainerPresentationProtocol`
    UIViewController *parentController = presentingController;
    UIViewController *toSelect         = childController;
    
    BOOL success = YES;
    
    while (parentController) {
        
        if (![parentController conformsToProtocol:@protocol(WAAppRoutingContainerPresentationProtocol)]) {
            if (!parentController.parentViewController && ![parentController isKindOfClass:[UINavigationController class]]) {
                WAAssert([parentController conformsToProtocol:@protocol(WAAppRoutingContainerPresentationProtocol)], ([NSString stringWithFormat:@"Error: the container class (%@) should conforms to `WAAppRoutingContainerPresentationProtocol` protocol", NSStringFromClass([parentController class])]));
                success = NO;
                break;
            }
        }
        else {
            success = [(id <WAAppRoutingContainerPresentationProtocol>)parentController waapplink_selectController:toSelect animated:YES];
        }
        
        if (!success) {
            break;
        }
        
        toSelect         = parentController;
        parentController = parentController.parentViewController;
    }
    
    return success;
}

@end

NSString * const kWAAppRoutingForceAnimationKey = @"wapprouting_animated";