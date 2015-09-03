//
//  NSNSMutableDictionaryDictionary+WAAppRoutingParameters.m
//  WAAppRouter
//
//  Created by Marian Paul on 21/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "NSMutableDictionary+WAAppRoutingParameters.h"
#import "NSString+WAAdditions.h"
#import "WAAppMacros.h"

@implementation NSMutableDictionary (WAAppRoutingParameters)

- (instancetype)initWithAllowedParameters:(NSArray *)allowedParameters {
    
    // WARNING NOTICE
    // I chose not to deal with allowed parameters on NSDictionary to avoid having a swizzling method
    // and mess with everything. Swizzle is evil, evil is swizzle. Repeat after me
    return [self init];
}

+ (instancetype)newWithAllowedParameters:(NSArray *)allowedParameters {
    return [[self alloc] initWithAllowedParameters:allowedParameters];
}

- (void)mergeWithAppRouterParameters:(id <WAAppRouterParametersProtocol>)parameters {
    // I do not support yet the merge between objects sharing the same protocol
    [self mergeWithRawParameters:(NSDictionary *)parameters];
}

- (void)mergeWithRawParameters:(NSDictionary *)rawParameters {
    WAAppRouterClassAssertionIfExisting(rawParameters, NSDictionary);
    
    if (!rawParameters) {
        return;
    }
    
    [self setValuesForKeysWithDictionary:rawParameters];
}

- (NSString *)queryStringWithWhiteList:(NSArray *)whiteList {
    
    NSMutableArray* keyValuesPair = [[NSMutableArray alloc] initWithCapacity:[self count]];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = obj;
        if ([value isKindOfClass:[NSString class]]) {
            value = [(NSString *)value waapp_stringByAddingPercentEscapes];
        }
        [keyValuesPair addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }];
    
    // Create the query
    return [keyValuesPair componentsJoinedByString:@"&"];
}

@end
