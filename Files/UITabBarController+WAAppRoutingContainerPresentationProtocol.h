//
//  UITabBarController+WAAppLinkContainerPresentationProtocol.h
//  MoreComplexExample
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import UIKit;
#import "WAAppRoutingContainerPresentationProtocol.h"

/**
 *  @brief This category implements the @see `WAAppRoutingContainerPresentationProtocol`
 *  This category acts as an example of how to use this protocol to get the container working (see the 'MoreComplexExample' project for tab bar and 'PPRevealSample' for a non Apple container)
 */

@interface UITabBarController (WAAppRoutingContainerPresentationProtocol) <WAAppRoutingContainerPresentationProtocol>

@end
