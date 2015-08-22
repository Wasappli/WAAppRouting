//
//  WAAppRouteEntity.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppRouteEntity.h"
#import "WAAppMacros.h"

#import "WAAppRouterTargetControllerProtocol.h"

@import ObjectiveC.runtime;

@implementation WAAppRouteEntity

- (instancetype)initWithName:(NSString *)name path:(NSString *)path sourceControllerClass:(Class)sourceControllerClass targetControllerClass:(Class)targetControllerClass presentingController:(UIViewController *)presentingController prefersModalPresentation:(BOOL)prefersModalPresentation defaultParametersBuilder:(WAAppRouterDefaultParametersBuilderBlock)defaultParametersBuilder allowedParameters:(NSArray *)allowedParameters {
    // Bunch of assertions and check!
    WAAppRouterClassAssertion(name, NSString);
    WAAppRouterClassAssertion(path, NSString);
    WAAppRouterParameterAssert(!sourceControllerClass || (class_isMetaClass(object_getClass(sourceControllerClass)) && [sourceControllerClass conformsToProtocol:@protocol(WAAppRouterTargetControllerProtocol)] && [sourceControllerClass isSubclassOfClass:[UIViewController class]]));
    WAAppRouterParameterAssert(class_isMetaClass(object_getClass(targetControllerClass)) && [targetControllerClass conformsToProtocol:@protocol(WAAppRouterTargetControllerProtocol)] && [targetControllerClass isSubclassOfClass:[UIViewController class]]);
    WAAppRouterClassAssertionIfExisting(presentingController, UIViewController);
    WAAppRouterParameterAssert(!presentingController && prefersModalPresentation || presentingController && !prefersModalPresentation);
    WAAppRouterClassAssertionIfExisting(allowedParameters, NSArray);
    
    self = [super init];
    if (self) {
        _name                     = name;
        _path                     = path;
        _sourceControllerClass    = sourceControllerClass;
        _targetControllerClass    = targetControllerClass;
        _presentingController     = presentingController;
        _preferModalPresentation  = prefersModalPresentation;
        _defaultParametersBuilder = [defaultParametersBuilder copy];
        _allowedParameters        = allowedParameters;
    }
    
    return self;
    
}

+ (instancetype)routeEntityWithName:(NSString *)name path:(NSString *)path sourceControllerClass:(Class)sourceControllerClass targetControllerClass:(Class)targetControllerClass presentingController:(UIViewController *)presentingController prefersModalPresentation:(BOOL)prefersModalPresentation defaultParametersBuilder:(WAAppRouterDefaultParametersBuilderBlock)defaultParametersBuilder allowedParameters:(NSArray *)allowedParameters {
    return [[self alloc] initWithName:name
                                 path:path
                sourceControllerClass:sourceControllerClass
                targetControllerClass:targetControllerClass
                 presentingController:presentingController
             prefersModalPresentation:prefersModalPresentation
             defaultParametersBuilder:defaultParametersBuilder
                    allowedParameters:allowedParameters];
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"WAAppRouteEntity description:%@\n"
            "name: %@\n"
            "path: %@\n"
            "sourceControllerClass: %@\n"
            "targetControllerClass: %@\n"
            "presentingController: %@\n"
            "preferModalPresentation: %d\n"
            "allowedParameters: %@\n",
            [super description],
            self.name,
            self.path,
            NSStringFromClass(self.sourceControllerClass),
            NSStringFromClass(self.targetControllerClass),
            self.presentingController,
            self.preferModalPresentation,
            self.allowedParameters];
}

#pragma mark - Equality

- (BOOL)isEqualToRouteEntity:(WAAppRouteEntity *)routeEntity {
    if (!routeEntity) {
        return NO;
    }
    
    BOOL haveEqualPaths                = (!self.path && !routeEntity.path) || [self.path isEqualToString:routeEntity.path];
    BOOL haveEqualSourceClass          = (!self.sourceControllerClass && !routeEntity.sourceControllerClass) || [self.sourceControllerClass isEqual:routeEntity.sourceControllerClass];
    BOOL haveEqualTargetClass          = (!self.targetControllerClass && !routeEntity.targetControllerClass) || [self.targetControllerClass isEqual:routeEntity.targetControllerClass];
    BOOL haveSamePresentation          = (self.preferModalPresentation == routeEntity.preferModalPresentation);
    BOOL haveEqualPresentingController = (!self.presentingController && !routeEntity.presentingController) || [self.presentingController isEqual:routeEntity.presentingController];

    return haveEqualPaths && haveEqualSourceClass && haveEqualTargetClass && haveSamePresentation && haveEqualPresentingController;
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[WAAppRouteEntity class]]) {
        return NO;
    }
    
    return [self isEqualToRouteEntity:(WAAppRouteEntity *)object];
}

- (NSUInteger)hash {
    return [self.path hash] ^ [self.sourceControllerClass hash] ^ [self.targetControllerClass hash] ^ [self.sourceControllerClass hash] + self.preferModalPresentation;
}

@end
