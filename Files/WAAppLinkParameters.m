//
//  WAAppLinkParameters.m
//  WAAppRouter
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppLinkParameters.h"
#import "WAAppMacros.h"
#import "NSString+WAAdditions.h"

@import ObjectiveC.runtime;

@interface WAAppLinkParameters ()

@property (nonatomic, strong) NSArray      *allowedParameters;
@property (nonatomic, strong) NSDictionary *mappingPropertyKey;
@property (nonatomic, strong) NSDictionary *mappingKeyProperty;
@property (nonatomic, strong) NSDictionary *mappingPropertyClass;

@end

@implementation WAAppLinkParameters

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ description: %@", NSStringFromClass([self class]),[self queryStringWithWhiteList:[self.mappingPropertyKey allKeys]]];
}

- (void)commonInit {
    WAAssert(self.mappingKeyProperty, @"You should override `- (NSDictionary *)mappingKeyProperty` and provide a mapping");
    
    // Create the reverse
    NSMutableDictionary *inverse = [NSMutableDictionary dictionary];
    for (id key in self.mappingKeyProperty) {
        inverse[self.mappingKeyProperty[key]] = key;
    }
    self.mappingPropertyKey = [NSDictionary dictionaryWithDictionary:inverse];
    
    // Get the class properties
    self.mappingPropertyClass = [[self class] getPropertiesClass];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithAllowedParameters:(NSArray *)allowedParameters {
    WAAppRouterClassAssertionIfExisting(allowedParameters, NSArray);
    
    self = [super init];
    
    if (self) {
        [self commonInit];
        
#ifdef DEBUG
        for (NSString *propertyName in allowedParameters) {
            WAAssert(self.mappingPropertyClass[propertyName], ([NSString stringWithFormat:@"The property '%@' is not a valid property", propertyName]));
        }
#endif
        
        _allowedParameters = allowedParameters;
    }
    
    return self;
}

+ (instancetype)newWithAllowedParameters:(NSArray *)allowedParameters {
    return [[self alloc] initWithAllowedParameters:allowedParameters];
}

#pragma mark - Mapping

- (void)mergeWithAppRouterParameters:(id<WAAppRouterParametersProtocol>)parameters {
    WAAppRouterClassAssertionIfExisting(parameters, WAAppLinkParameters);
    
    if (!parameters) {
        return;
    }
    
    NSArray *allProperties = [self.mappingPropertyClass allKeys];
    
    // Go through all class properties
    for (NSString *propertyName in allProperties) {
        // If there is any value, set it
        // Note: this won't erase any nil value
        id fromValue = [(NSObject *)parameters valueForKey:propertyName];
        if (fromValue) {
            [self setValue:fromValue forKey:propertyName];
        }
    }
}

- (void)mergeWithRawParameters:(NSDictionary *)rawParameters {
    WAAppRouterClassAssertionIfExisting(rawParameters, NSDictionary);
    
    if (!rawParameters) {
        return;
    }
    
    for (id key in [rawParameters allKeys]) {
        NSString *propertyName = self.mappingKeyProperty[key];
        
        // If this subclass does not have any property mapped for the url query key, then continue to the next one
        if (!propertyName) {
            continue;
        }
        
        Class propertyClass = self.mappingPropertyClass[propertyName];
        
        id value = rawParameters[key];
        
        // If the destination is a number and the origin a string, then move to number.
        if (propertyClass == [NSNumber class] && [value isKindOfClass:[NSString class]]) {
            value = @([value longLongValue]);
        }
        
        // Decode if this is a string
        if (propertyClass == [NSString class] && [value isKindOfClass:[NSString class]]) {
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        [self setValue:value forKey:propertyName];
    }
}

#pragma mark - Query

- (NSString *)queryStringWithWhiteList:(NSArray *)whiteList {
    WAAppRouterClassAssertion(whiteList, NSArray);
    WAAppRouterParameterAssert([whiteList count] > 0);
    
    // First, create a dictionary with all the values set to the url property key
    NSMutableDictionary *valuesAsDictionary = [NSMutableDictionary dictionary];
    for (NSString *property in [self.mappingPropertyKey allKeys]) {
        WAAssert(self.mappingPropertyClass[property], ([NSString stringWithFormat:@"Error: the property '%@' is not a valid property for '%@'", property, NSStringFromClass([self class])]));
        id value = [self valueForKey:property];
        if (value) {
            valuesAsDictionary[self.mappingPropertyKey[property]] = value;
        }
    }
    
    NSMutableArray *keyValuesPair = [NSMutableArray array];
    // Go through the white list
    for (NSString *property in whiteList) {
        NSString *urlProperty = self.mappingPropertyKey[property];
        WAAssert(urlProperty, ([NSString stringWithFormat:@"Error: cannot retrieve the url property for white liste property: '%@'", property]));
        if (urlProperty) {
            id value = valuesAsDictionary[urlProperty];
            
            if (value == [NSNull null] || !value) {
                continue;
            }
            
            if ([value isKindOfClass:[NSString class]]) {
                value = [(NSString *)value waapp_stringByAddingPercentEscapes];
            }
            [keyValuesPair addObject:[NSString stringWithFormat:@"%@=%@", urlProperty, value]];
        }
    }
    
    // Create the query
    return [keyValuesPair componentsJoinedByString:@"&"];
}

#pragma mark - helper

- (BOOL)isPropertyAllowed:(NSString *)propertyName {
    // Property is allowed if there is no allowed parameters at all OR if it is in the allowed parameters ;)
    BOOL propertyAllowed = !self.allowedParameters || [self.allowedParameters indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
        return (BOOL)([obj caseInsensitiveCompare:propertyName] == NSOrderedSame);
    }] != NSNotFound;
    
    return propertyAllowed;
}

#pragma mark - Class exception handling

- (void)setValue:(id)value forKey:(NSString *)key {
    BOOL canSetValue = [self isPropertyAllowed:key];

    // Do no set any value if the property is not allowed
    if (canSetValue) {
        [super setValue:value forKey:key];
    }
}

#pragma mark - Runtime methods

+ (NSDictionary *)getPropertiesClass {
    unsigned int count = 0;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString* propName = [NSString stringWithUTF8String:property_getName(property)];
        
        // Do not use description nor private properties
        if ([propName isEqualToString:@"description"]
            ||
            [propName isEqualToString:@"debugDescription"]
            ||
            [propName isEqualToString:@"allowedParameters"]
            ||
            [propName isEqualToString:@"mappingPropertyKey"]
            ||
            [propName isEqualToString:@"mappingKeyProperty"]
            ||
            [propName isEqualToString:@"mappingPropertyClass"]) {
            continue;
        }
        
        const char * type = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:type];
        
        NSArray *attributes = [typeString componentsSeparatedByString:@","];
        NSString *typeAttribute = [attributes objectAtIndex:0];
        
        if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 3)
        {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];
            Class typeClass = NSClassFromString(typeClassName);
            WAAssert([typeClass isSubclassOfClass:[NSString class]] || [typeClass isSubclassOfClass:[NSNumber class]], @"Only NSString and NSNumber are supported for the moment");
            dictionary[propName] = typeClass;
        }
    }
    
    free(properties);
    
    return [dictionary copy];
}

#pragma mark - Copy

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] allocWithZone:zone] initWithAllowedParameters:self.allowedParameters];
    [copy mergeWithAppRouterParameters:self];
    return copy;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *excludedProperties = nil;
    if ([self respondsToSelector:@selector(excludedPropertiesForEncoding)]) {
        excludedProperties = [self excludedPropertiesForEncoding];
    }
    
    for (NSString *propertyName in [self.mappingPropertyClass allKeys]) {
        if ([excludedProperties containsObject:propertyName]) {
            continue;
        }
        
        [aCoder encodeObject:[self valueForKey:propertyName] forKey:propertyName];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        [self commonInit];
        
        for (NSString *propertyName in [self.mappingPropertyClass allKeys]) {

            [self setValue:[aDecoder decodeObjectForKey:propertyName] forKey:propertyName];
        }
    }
    
    return self;
}

@end
