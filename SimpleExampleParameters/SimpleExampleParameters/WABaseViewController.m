//
//  WABaseViewController.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WABaseViewController.h"
#import "ArticleAppLinkParameters.h"

@interface WABaseViewController ()
@property (nonatomic, strong) ArticleAppLinkParameters *routingParameters;
@end

@implementation WABaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

+ (Class<WAAppRouterParametersProtocol>)appLinkParametersClass {
    return [ArticleAppLinkParameters class];
}

- (void)reloadFromAppLinkRefresh {
    
}

@end
