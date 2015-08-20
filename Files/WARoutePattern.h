//
//  WARoutePattern.h
//  WAAppRouter
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;

/**
 @brief A custom implementation of a class which matches the pattern with a string (the url as string)
 */
@interface WARoutePattern : NSObject

/**
 *  Init with a pattern like 'list/:itemID/extra' or 'list/_*_/extra' (whithout the '_')
 *
 *  @param pattern the pattern
 *
 *  @return return a fresh pattern matcher
 */
- (instancetype)initWithPattern:(NSString *)pattern NS_DESIGNATED_INITIALIZER;

/**
 *  Tests if a route matches the pattern
 *
 *  @param route the route (url as string)
 *
 *  @return YES if matches, NO if not
 */
- (BOOL)matchesRoute:(NSString *)route;

/**
 *  Extract parameters from a route giving the original pattern
 *  Please not that this will not retrieve all parameters under the wildcard if existing
 *
 *  @param route the route (url as string)
 *
 *  @return a dictionary whith the route parameters
 */
- (NSDictionary *)extractParametersFromRoute:(NSString *)route;

@end
