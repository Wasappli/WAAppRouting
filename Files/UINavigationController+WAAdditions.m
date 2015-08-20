//
//  UINavigationController+WAAdditions.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "UINavigationController+WAAdditions.h"

@implementation UINavigationController (WAAdditions)

- (UIViewController *)waapp_popToFirstControllerOfClass:(Class)cClass animated:(BOOL)animated {    
    UIViewController *foundedController = nil;
    for (NSInteger i = [self.viewControllers count] - 1 ; i >= 0 ; i--) {
        id controller = self.viewControllers[i];
        if ([controller isKindOfClass:cClass]) {
            foundedController = controller;
            break;
        }
    }
    if (foundedController) {
        [self popToViewController:foundedController animated:animated];
    }
    
    return foundedController;
}

@end
