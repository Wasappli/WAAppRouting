//
//  WAAppRouteMatcher.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppRouterMatcherProtocol.h"

/**
 *  A class to match URLs against patterns.
 *  By adopting the protocol, you can use any of the route matcher you want if your URLs have some rules not handled here etc.
 */
@interface WAAppRouteMatcher : NSObject <WAAppRouteMatcherProtocol>

@end
