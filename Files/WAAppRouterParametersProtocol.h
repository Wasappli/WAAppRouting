//
//  WAAppRouterParametersProtocol.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;

@protocol WAAppRouterParametersProtocol <NSObject>

/**
 *  Initialize the object with allowed parameters. Pass nil if you want all parameters allowed
 *
 *  @param allowedParameters the allowed parameters which is supposed to be a list of object properties name (and not the url properties name)
 *
 *  @return a fresh object
 */
- (instancetype)initWithAllowedParameters:(NSArray *)allowedParameters;

/**
 *  Merge with an other object conform to `WAAppRouterParametersProtocol` protocol
 *  This will not erase nil values
 *
 *  @param parameters the parameters to merge with
 */
- (void)mergeWithAppRouterParameters:(id <WAAppRouterParametersProtocol>)parameters;

/**
 *  Merge with raw values by using a mapping
 *
 *  @param parameters the parameters from the url itself
 */
- (void)mergeWithRawParameters:(NSDictionary *)parameters;

/**
 *  Get a query string from set parameters on the object
 *
 *  @param whiteList the parameters to include which is supposed to be a list of object properties name (and not the url properties name)
 *
 *  @return a string like 'toto=value&titi=value2'
 */
- (NSString *)queryStringWithWhiteList:(NSArray *)whiteList;

/**
 *  Override this method to return the mapping between the keys (url keys) and values (object properties)
 *
 *  @return a dictionary
 */
- (NSDictionary *)mappingPropertyKey;

@end
