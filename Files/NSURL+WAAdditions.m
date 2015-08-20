//
//  NSURL+WAAdditions.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "NSURL+WAAdditions.h"

@implementation NSURL (WAAdditions)

- (NSDictionary *)waapp_queryParameters {
    NSArray *parameters = [[self query] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
    NSMutableDictionary *keyValueParam = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [parameters count]; i=i+2) {
        keyValueParam[parameters[i]] = parameters[i+1];
    }
    return [keyValueParam copy];
}

@end
