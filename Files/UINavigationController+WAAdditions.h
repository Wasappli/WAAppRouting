//
//  UINavigationController+WAAdditions.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import UIKit;

@interface UINavigationController (WAAdditions)

/**
 *  Pop to the first controller of the class the navigation controller can have in its stack
 *  If several controllers with the same class are in it, the first one starting from the end would be returned
 *
 *  @param cClass   the class to reach
 *  @param animated pop with animation or not
 *
 *  @return return the founded controller
 */
- (UIViewController *)waapp_popToFirstControllerOfClass:(Class)cClass animated:(BOOL)animated;

@end
