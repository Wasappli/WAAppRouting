//
//  WAAppLink.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;

/**
 *  @brief The WAAppLink object acts as the final object you get after opening a URL
 *  It contains the URL itself, the query parameters and the route parameters if existing.
 */
@interface WAAppLink : NSObject

/**
 *  Init with a URL and routes parameters
 *
 *  @param url             the url opened
 *  @param routeParameters the route parameters associated to the url based on the entity path
 *
 *  @return an app link object
 */
- (instancetype)initWithURL:(NSURL *)url routeParameters:(NSDictionary *)routeParameters NS_DESIGNATED_INITIALIZER;

/**
 *  Return the object for the key merged from `queryParameters` and from `routeParameters`. Please not that the `routeParameters` is evaluated first.
 *
 *  @param key the query key of the object you want to retrieve
 *
 *  @return the value for this key
 */
- (id)objectForKeyedSubscript:(NSString *)key;

@property (nonatomic, copy, readonly) NSURL        *URL;
@property (nonatomic, copy, readonly) NSDictionary *queryParameters;
@property (nonatomic, copy, readonly) NSDictionary *routeParameters;

@end
