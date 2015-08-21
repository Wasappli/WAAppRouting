//
//  WAAppRouter+WADefaultRouter.h
//  WAAppRouter
//
//  Created by Marian Paul on 21/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "WAAppRouter.h"

@interface WAAppRouter (WADefaultRouter)

/**
 *  Allocate and return a default configured router. You can define your own router with custom route matcher AND/OR route handler
 *
 *  @return a fresh router which life is dedicated to help you
 */
+ (instancetype) defaultRouter;

@end
