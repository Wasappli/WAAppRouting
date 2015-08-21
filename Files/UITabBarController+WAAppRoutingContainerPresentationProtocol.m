//
//  UITabBarController+WAAppLinkContainerPresentationProtocol.m
//  MoreComplexExample
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "UITabBarController+WAAppRoutingContainerPresentationProtocol.h"
#import "WAAppRoutingContainerPresentationProtocol.h"

@implementation UITabBarController (WAAppRoutingContainerPresentationProtocol)

- (BOOL)waapplink_selectController:(UIViewController *)controller animated:(BOOL)animated {
    // If we cannot find the controller within the tabs, return NO
    if (![[self viewControllers] containsObject:controller]) {
        return NO;
    }
    
    // Otherwise, select it
    [self setSelectedViewController:controller];
    
    return YES;
}

@end
