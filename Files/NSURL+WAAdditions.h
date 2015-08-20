//
//  NSURL+WAAdditions.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;

@interface NSURL (WAAdditions)

/**
 *  Retrieve the query parameters from an URL. Do not decode the parameters
 *
 *  @return a dictionary containing all the key values pairs from the URL
 */
- (NSDictionary *)waapp_queryParameters;

@end
