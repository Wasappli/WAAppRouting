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
        urlMatchesPattern = [self doesPathPattern:pathPattern
                                     matchesRoute:[self pathWithoutScheme:url]];
    }
    
    return urlMatchesPattern;
}

- (NSDictionary *)parametersFromURL:(NSURL *)url withPathPattern:(NSString *)pathPattern {
    WARoutePattern *pattern = [[WARoutePattern alloc] initWithPattern:pathPattern];
    NSDictionary *routeParameters = nil;
    
    routeParameters = [pattern extractParametersFromRoute:[self pathWithoutScheme:url]];
    
    return routeParameters;
}

#pragma mark - Private

- (BOOL)doesPathPattern:(NSString *)pathPattern matchesRoute:(NSString *)route {
    WARoutePattern* pattern = [[WARoutePattern alloc] initWithPattern:pathPattern];
    return [pattern matchesRoute:route];
}

- (NSString *)pathWithoutScheme:(NSURL *)url
{
    NSString *pathWithoutScheme = nil;

    // Is the scheme is http or https, then do not use the host
    // See documentation on Apple side:
    // > The scheme of the webpageURL must be http or https. Any other scheme throws an exception.

    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        pathWithoutScheme = url.path;
        // Remove the first slash
        pathWithoutScheme = pathWithoutScheme.length > 1 ? [pathWithoutScheme substringFromIndex:1] : pathWithoutScheme;
    }
    else {
        pathWithoutScheme = [url.host stringByAppendingPathComponent:url.path];
    }

    return pathWithoutScheme;
}

@end
