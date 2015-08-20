//
//  WAAppRouteMatcher.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppRouteMatcher.h"
#import "WARoutePattern.h"

@implementation WAAppRouteMatcher

- (BOOL)matchesURL:(NSURL *)url fromPathPattern:(NSString *)pathPattern {
    // Remove the parameters
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    urlComponents.query = nil;
    BOOL urlMatchesPattern = [self doesPathPattern:pathPattern
                                      matchesRoute:urlComponents.string];
    if (!urlMatchesPattern) {
        // Try without the scheme
        NSString *pathWithoutScheme = nil;
        // Is the scheme is http or https, then do not use the host
        // See documentation on Apple side:
        // > The scheme of the webpageURL must be http or https. Any other scheme throws an exception.
        
        if ([urlComponents.scheme isEqualToString:@"http"] || [urlComponents.scheme isEqualToString:@"https"]) {
            pathWithoutScheme = urlComponents.path;
            // Remove the first slash
            pathWithoutScheme = pathWithoutScheme.length > 1 ? [pathWithoutScheme substringFromIndex:1] : pathWithoutScheme;
        }
        else {
            pathWithoutScheme = [urlComponents.host stringByAppendingPathComponent:urlComponents.path];
        }
        
        urlMatchesPattern = [self doesPathPattern:pathPattern
                                     matchesRoute:pathWithoutScheme];
    }
    
    return urlMatchesPattern;
}

- (NSDictionary *)parametersFromURL:(NSURL *)url withPathPattern:(NSString *)pathPattern {
    WARoutePattern *pattern = [[WARoutePattern alloc] initWithPattern:pathPattern];
    NSDictionary *routeParameters = nil;
    
    NSString *urlStringWithoutScheme = [[url absoluteString] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@://", url.scheme]
                                                                                       withString:@""];
    if (url.query) {
        urlStringWithoutScheme = [urlStringWithoutScheme stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"?%@", url.query] withString:@""];
    }
    
    routeParameters = [pattern extractParametersFromRoute:urlStringWithoutScheme];
    
    return routeParameters;
}

#pragma mark - Private

- (BOOL)doesPathPattern:(NSString *)pathPattern matchesRoute:(NSString *)route {
    WARoutePattern* pattern = [[WARoutePattern alloc] initWithPattern:pathPattern];
    return [pattern matchesRoute:route];
}

@end
