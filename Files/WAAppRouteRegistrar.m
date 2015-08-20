//
//  WAAppRouteRegistrar.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppRouteRegistrar.h"

#import "WAAppRouteEntity.h"
#import "WAAppMacros.h"

@interface WAAppRouteRegistrar ()

@property (nonatomic, strong) NSMutableDictionary *entities;
@property (nonatomic, strong) id <WAAppRouteMatcherProtocol>routeMatcher;

@end

@implementation WAAppRouteRegistrar

- (instancetype)initWithRouteMatcher:(id<WAAppRouteMatcherProtocol>)routeMatcher {
    WAAppRouterProtocolAssertion(routeMatcher, WAAppRouteMatcherProtocol);
    
    self = [super init];
    if (self) {
        self->_routeMatcher = routeMatcher;
        self->_entities     = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerAppRouteEntity:(WAAppRouteEntity *)entity {
    WAAppRouterClassAssertion(entity, WAAppRouteEntity);

    WAAssert(!self.entities[entity.path], ([NSString stringWithFormat:@"You cannot add two entities for the same path: '%@'", entity.path]));

    self.entities[entity.path] = entity;
}

- (void)registerBlockRouteHandler:(WAAppRouteHandlerBlock)routeBlockHandler forRoute:(NSString *)route {
    WAAppRouterClassAssertion(routeBlockHandler, NSClassFromString(@"NSBlock"));
    
    WAAssert(!self.entities[route], ([NSString stringWithFormat:@"You cannot add two entities for the same path: '%@'", route]));
    self.entities[route] = [routeBlockHandler copy];
}

- (WAAppRouteEntity *)entityForURL:(NSURL *)url {
    WAAssert(self.routeMatcher, @"You need to provide a route matcher on initialization");
    
    WAAppRouteEntity *foundedEntity = nil;
    
    for (NSString *pathPattern in [self.entities allKeys]) {
        WAAppRouteEntity *entity = self.entities[pathPattern];
        if ([entity isKindOfClass:NSClassFromString(@"NSBlock")]) {
            continue;
        }
        
        BOOL hasAMatch = [self.routeMatcher matchesURL:url
                                       fromPathPattern:pathPattern];
        
        if (hasAMatch) {
            foundedEntity = entity;
            break;
        }
    }
    
    return foundedEntity;
}

- (WAAppRouteHandlerBlock)blockHandlerForURL:(NSURL *)url {
    WAAssert(self.routeMatcher, @"You need to provide a route matcher on initialization");
    
    WAAppRouteHandlerBlock foundedBlock = nil;
    
    for (NSString *pathPattern in [self.entities allKeys]) {
        WAAppRouteHandlerBlock block = self.entities[pathPattern];
        if ([block isKindOfClass:[WAAppRouteEntity class]]) {
            continue;
        }
        
        BOOL hasAMatch = [self.routeMatcher matchesURL:url
                                       fromPathPattern:pathPattern];
        
        if (hasAMatch) {
            foundedBlock = block;
            break;
        }
    }
    
    return foundedBlock;
}

- (WAAppRouteEntity *)entityForTargetClass:(Class)targetClass {
    WAAppRouteEntity *foundedEntity = nil;
    
    for (WAAppRouteEntity *entity in [self.entities allValues]) {
        if ([entity isKindOfClass:NSClassFromString(@"NSBlock")]) {
            continue;
        }
             
        if (entity.targetControllerClass == targetClass) {
            WAAssert(!foundedEntity || foundedEntity && !entity.sourceControllerClass, ([NSString stringWithFormat:@"Error: you cannot have two entities with the same target class (%@) if the source is not nil. Cannot resolve the path.", NSStringFromClass(entity.targetControllerClass)]));
            if (!foundedEntity) {
                foundedEntity = entity;
                // If we are not on debug, continue to report double target violation
#ifndef DEBUG
                break;
#endif
            }
        }
    }
    return foundedEntity;
}

@end
