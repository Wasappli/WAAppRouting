//
//  PPRevealSideViewController+WAAppRoutingContainerPresentationProtocol.m
//  PPRevealSample
//
//  Created by Marian Paul on 20/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "PPRevealSideViewController+WAAppRoutingContainerPresentationProtocol.h"
#import <WAAppRouting/WAAppRouting.h>

@implementation PPRevealSideViewController (WAAppRoutingContainerPresentationProtocol)

- (BOOL)waapplink_selectController:(UIViewController *)controller animated:(BOOL)animated {
    
    // Check if the controller we are trying to present is the same class of one preloaded on a side
    for (id side in @[@(PPRevealSideDirectionTop), @(PPRevealSideDirectionLeft), @(PPRevealSideDirectionRight), @(PPRevealSideDirectionBottom)]) {
        UIViewController *controllerInSide = [self controllerForSide:[side integerValue]];
        if ([[controller class] isEqual:[controllerInSide class]]) {
            [self pushViewController:controller
                         onDirection:[side integerValue]
                            animated:animated];
            return YES;
        }
    }
    
    // Check if the controller we wants to place can fit into the current stack
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        // If the navigation controller of the controller we are trying to place is the same then juste close the PPReveal and let the router handles the stack
        if ([controller.navigationController isEqual:self.rootViewController]) {
            [self popViewControllerAnimated:animated];
            return YES;
        }
        else {
            // We do not have a navigation controller yet. We need to allocate one and place it into the reveal center with the controller as the root
            UINavigationController *navigationController = nil;
            if (![controller isKindOfClass:[UINavigationController class]]) {
                navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            }
            else {
                // This is a weirdo situation which should not event happen
                navigationController = (UINavigationController *)controller;
            }
            
            [self popViewControllerWithNewCenterController:navigationController
                                                  animated:animated];
            return YES;
        }
    }
    
    return NO;
}

- (UINavigationController *)waapplink_navigationControllerForPresentingEntity:(WAAppRouteEntity *)entity {
    
    for (id side in @[@(PPRevealSideDirectionTop), @(PPRevealSideDirectionLeft), @(PPRevealSideDirectionRight), @(PPRevealSideDirectionBottom)]) {
        UIViewController *controllerInSide = [self controllerForSide:[side integerValue]];
        if ([entity.targetControllerClass isEqual:[controllerInSide class]]) {
            return nil;
        }
    }
    
    return (UINavigationController *)self.rootViewController;
}

@end
