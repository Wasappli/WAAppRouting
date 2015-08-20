//
//  WAAppRouterTargetControllerProtocol.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import Foundation;
#import "WAAppRouterParametersProtocol.h"

@class WAAppLink;

/**
 *  @brief All controllers used with the route handler should conforms to this protocol in order to get configured with the app link
 */
@protocol WAAppRouterTargetControllerProtocol <NSObject>

- (void)configureWithAppLink:(WAAppLink *)appLink defaultParameters:(id <WAAppRouterParametersProtocol>)defaultParameters allowedParameters:(NSArray *)allowedParameters;

@end
