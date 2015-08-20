//
//  WABaseViewController.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WABaseViewController.h"

@interface WABaseViewController ()
@property (nonatomic, strong) ArticleAppLinkParameters *routingParameters;
@end

@implementation WABaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)reloadFromAppLink {
    
}

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

@end
