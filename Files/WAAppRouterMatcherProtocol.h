//
//  WAAppRouterMatcherProtocol.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;

@protocol WAAppRouteMatcherProtocol <NSObject>

/**
 *  This method is used to match a URL against a string pattern
 *
 *  @param url         the url you want to match
 *  @param pathPattern the pattern to match against
 *
 *  @return YES if matches, NO if not
 */
- (BOOL)matchesURL:(NSURL *)url fromPathPattern:(NSString *)pathPattern;

/**
 *  Get the route parameters from the URL (like list/3/toto agains list/:itemID/:name would return 3 as itemID and toto as name)
 *
 *  @param url         the url you want to grab the parameters from
 *  @param pathPattern the pattern to match against
 *
 *  @return the parameters
 */
- (NSDictionary *)parametersFromURL:(NSURL *)url withPathPattern:(NSString *)pathPattern;

@end
