//
//  WAAppRoutingContainerPresentationProtocol.h
//  WAAppRouter
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;

@class WAAppRouteEntity;

/**
 *  @brief A protocol used to deal with custom container and presentation
 */
@protocol WAAppRoutingContainerPresentationProtocol <NSObject>

/**
 *  Ask the container to select the controller we are trying to display
 *
 *  @param controller the controller we wants to place in stack
 *  @param animated   select it with animation or not
 *
 *  @return YES if shown, NO otherwise
 */
- (BOOL)waapplink_selectController:(UIViewController *)controller animated:(BOOL)animated;

@optional

/**
 *  Ask for the navigation controller to display an entity
 *  This method is useful when the container allocates the controller on the fly. See 'PPRevealSample' for a more concrete sample
 *
 *  @param entity the entity for which we are looking for a navigation controller
 *
 *  @return a navigation controller
 */
- (UINavigationController *)waapplink_navigationControllerForPresentingEntity:(WAAppRouteEntity *)entity;

@end
