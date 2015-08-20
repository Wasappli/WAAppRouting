//
//  ArticleAppLinkParameters.m
//  SimpleExampleParameters
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "ArticleAppLinkParameters.h"

@implementation ArticleAppLinkParameters

- (NSDictionary *)mappingKeyProperty {
    return @{
             @"articleID": @"articleID",
             @"article_title": @"articleTitle",
             @"display_type": @"displayType"
             };
}

@end
