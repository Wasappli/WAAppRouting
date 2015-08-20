//
//  ArticleAppLinkParameters.h
//  SimpleExampleParameters
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import <WAAppRouting/WAAppLinkParameters.h>

@interface ArticleAppLinkParameters : WAAppLinkParameters

@property (nonatomic, strong) NSNumber *articleID;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSNumber *displayType;

@end
