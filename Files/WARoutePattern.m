//
//  WARoutePattern.m
//  WAAppRouter
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WARoutePattern.h"
#import "WAAppMacros.h"

@interface WARoutePattern ()

@property (nonatomic, strong) NSString *pattern;
@property (nonatomic, strong) NSArray *patternPathComponents;
@property (nonatomic, assign) BOOL patternHasWildcard;

@end

static NSString *WARoutePatternWildcard     = @"*";
static NSString *WARoutePatternObjectPrefix = @":";

@implementation WARoutePattern

- (instancetype)initWithPattern:(NSString *)pattern {
    WAAppRouterClassAssertion(pattern, NSString);
    
    self = [super init];
    if (self) {
        self->_pattern = pattern;
        self->_patternPathComponents = pattern.pathComponents;
    
        // Look for wildcard
        for (NSString *path in self->_patternPathComponents) {
            if ([path isEqualToString:WARoutePatternWildcard]) {
                self->_patternHasWildcard = YES;
                break;
            }
        }
    }
    
    return self;
}

- (BOOL)matchesRoute:(NSString *)route {
    NSArray *routePathComponents = route.pathComponents;
    
    // If the count is not the same and there is no wildcard, no way this can match
    // Same if the route has less components than the pattern
    if (
        ([routePathComponents count] != [self.patternPathComponents count] && !self.patternHasWildcard)
        ||
        ([routePathComponents count] < [self.patternPathComponents count])
        ) {
        return NO;
    }
    
    BOOL matches = YES;
    
    for (NSInteger i = 0 ; i < [routePathComponents count] ; i++) {
        NSString *routePath = routePathComponents[i];

        // In case the patterns stops before the route
        if ([self.patternPathComponents count] <= i) {
            if ([[self.patternPathComponents lastObject] isEqualToString:WARoutePatternWildcard]) {
                matches = YES;
                break;
            }
        }
        
        NSString *patternPath = self.patternPathComponents[i];

        // See if the pattern path is a future object
        if ([patternPath hasPrefix:WARoutePatternObjectPrefix]) {
            continue;
        }
        
        // If the strings are not equal and the pattern path is not a wildcard, then we are finished
        if (![routePath isEqualToString:patternPath] && ![patternPath isEqualToString:WARoutePatternWildcard]) {
            matches = NO;
            break;
        }
    }
    
    return matches;
}

- (NSDictionary *)extractParametersFromRoute:(NSString *)route {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *routePathComponents = route.pathComponents;
    for (NSInteger i = 0 ; i < [routePathComponents count] ; i++) {
        if ([self.patternPathComponents count] <= i) {
            break;
        }
        
        NSString *patternPath = self.patternPathComponents[i];
        if ([patternPath hasPrefix:WARoutePatternObjectPrefix]) {
            NSString *routePath = routePathComponents[i];
            dictionary[[patternPath substringFromIndex:1]] = routePath;
        }
    }
    
    return [dictionary copy];
}

@end
