//
//  WAAppLinkParameters.h
//  WAAppRouter
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;
#import "WAAppRouterParametersProtocol.h"

/**
 *  @brief This class is the one more thing of this library. @see `WAAppRouterParametersProtocol`
 *  It's purpose is to simplify the query values you can retrieve after a routing. The job is yours for dealing with it
 Let's have a look to an example you can find on `SimpleExampleParameters` sample project.
 
 First, create a subclass
 
 ```
 @interface ArticleAppLinkParameters : WAAppLinkParameters
 
 @property (nonatomic, strong) NSNumber *articleID;
 @property (nonatomic, strong) NSString *articleTitle;
 @property (nonatomic, strong) NSNumber *displayType;
 
 @end
 ```
 
 You can see here three objects which should be mapped to the url keys
 You need to override the `mappingKeyProperty` getter
 
 ```
 - (NSDictionary *)mappingKeyProperty {
    return @{
            @"articleID": @"articleID",
            @"article_title": @"articleTitle",
            @"display_type": @"displayType"
    };
 }
 ```
 
 Next step is to go to your base view controller (if you not yet one it is a good idea to start now) and write some code you can customize. For example, you would deal with values exception here like cannot have a reservation date before today.
 
 Here is the default implementation idea you can reproduce in your app
 
 ```
 - (void)configureWithAppLink:(WAAppLink *)appLink defaultParameters:(id<WAAppRouterParametersProtocol>)defaultParameters allowedParameters:(NSArray *)allowedParameters {
 
    // Grab the parameters from the link
    NSMutableDictionary *rawParameters = [NSMutableDictionary dictionaryWithDictionary:appLink.queryParameters];
    if (appLink.routeParameters) {
        [rawParameters setValuesForKeysWithDictionary:appLink.routeParameters];
    }
 
    // Erase all previous params and allocate with allowed parameters provided by the entity
    self.routingParameters = [[ArticleAppLinkParameters alloc] initWithAllowedParameters:allowedParameters];
 
    // Merge with the default parameters provided by the entity
    [self.routingParameters mergeWithAppRouterParameters:defaultParameters];
 
    // No set the values from the query itself
    [self.routingParameters mergeWithRawParameters:rawParameters];
 
    // Call reload which is a random method defined for our purpose. This method should be implemented by your subclasses to reload data accordingly
    [self reloadFromAppLink];
 }
 ```
 
 You can now get the value directly
 
 ```
 self.label.text = [NSString stringWithFormat:@"ArticleID: %@", self.routingParameters.articleID];`
 ```
 
 You can copy the parameters, set values for a future use
 
 ```
 ArticleAppLinkParameters *params = [self.routingParameters copy];
 params.articleTitle = [NSString stringWithFormat:@"My super article %ld", (long)indexPath.row];
 ```
 
 Grab the query with a white list
 
 ```
 NSString *query = [params queryStringWithWhiteList:@[@"articleID", @"articleTitle", @"displayType"];
 ```
 */
@interface WAAppLinkParameters : NSObject <WAAppRouterParametersProtocol, NSCopying>

@end
