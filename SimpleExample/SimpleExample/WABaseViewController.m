//
//  WABaseViewController.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WABaseViewController.h"

@implementation WABaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)reloadFromAppLink {
    
}

- (void)configureWithAppLink:(WAAppLink *)appLink defaultParameters:(id<WAAppRouterParametersProtocol>)defaultParameters allowedParameters:(NSArray *)allowedParameters {
    self->_appLink = appLink;
    [self reloadFromAppLink];
}

@end
