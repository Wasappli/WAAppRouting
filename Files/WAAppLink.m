//
//  WAAppLink.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppLink.h"
#import "WAAppMacros.h"

#import "NSURL+WAAdditions.h"

@implementation WAAppLink

- (instancetype)initWithURL:(NSURL *)url routeParameters:(NSDictionary *)routeParameters {
    WAAppRouterClassAssertion(url, NSURL);
    WAAppRouterClassAssertionIfExisting(routeParameters, NSDictionary);
    
    self = [super init];
    
    if (self) {
        self->_URL             = url;
        self->_queryParameters = [url waapp_queryParameters];
        self->_routeParameters = routeParameters;
    }
    
    return self;
}

#pragma mark - Object retrieval from key

- (id)objectForKeyedSubscript:(NSString *)key {
    id value  = self.routeParameters[key];
    if (!value) {
        value = self.queryParameters[key];
    }
    return value;
}

@end
