//
//  ArticleAppLinkParameters+Additions.m
//  SimpleExampleParameters
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "ArticleAppLinkParameters+Additions.h"

@implementation ArticleAppLinkParameters (Additions)

- (NSString *)articleDetailQuery {
    return [self queryStringWithWhiteList:@[@"articleID", @"articleTitle", @"displayType"]];
}

- (NSString *)articleDetailExtraQuery {
    return [self queryStringWithWhiteList:@[@"articleID", @"articleTitle"]];
}

@end
