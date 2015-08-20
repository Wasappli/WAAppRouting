//
//  WAAppSOCRouteMatcherTests.m
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <WAAppRouting/WAAppRouting.h>

SPEC_BEGIN(RouteMatcherTests)

describe(@"Classic URL scheme without object ID", ^{
    
    __block WAAppRouteMatcher *router = nil;
    
    NSURL *singlePathURL             = [NSURL URLWithString:@"app-scheme://single"];
    NSURL *multiplePathURL           = [NSURL URLWithString:@"app-scheme://multiple/path"];
    NSURL *singlePathParametersURL   = [NSURL URLWithString:@"app-scheme://single?toto=titi"];
    NSURL *multiplePathParametersURL = [NSURL URLWithString:@"app-scheme://multiple/path?toto=titi"];

    NSString *singlePathPattern          = @"single";
    NSString *fullURLSinglePathPattern   = @"app-scheme://single";
    NSString *singlePathDashPattern      = @"/single";
    NSString *multiplePathPattern        = @"multiple/path";
    NSString *fullURLMultiplePathPattern = @"app-scheme://multiple/path";
    NSString *multiplePathDashPattern    = @"/multiple/path";

    beforeAll(^{
        router = [[WAAppRouteMatcher alloc] init];
    });
    
    context(@"Single path", ^{
        it(@"Should be recognised without dash", ^{
            NSArray *urls = @[singlePathURL, singlePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should be recognised with app scheme", ^{
            NSArray *urls = @[singlePathURL, singlePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:fullURLSinglePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised with dash", ^{
            NSArray *urls = @[singlePathURL, singlePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathDashPattern]) should] beFalse];
            }
        });
    });
    
    context(@"Path with multiple elements", ^{
        it(@"Should be recognised without dash", ^{
            NSArray *urls = @[multiplePathURL, multiplePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should be recognised with app scheme", ^{
            NSArray *urls = @[multiplePathURL, multiplePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:fullURLMultiplePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised with dash", ^{
            NSArray *urls = @[multiplePathURL, multiplePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathDashPattern]) should] beFalse];
            }
        });
    });
    
});

describe(@"Classic URL scheme without object ID", ^{
    
    __block WAAppRouteMatcher *router = nil;
    
    NSURL *singlePathURL             = [NSURL URLWithString:@"app-scheme://single/123"];
    NSURL *multiplePathURL           = [NSURL URLWithString:@"app-scheme://multiple/path/123"];
    NSURL *singlePathParametersURL   = [NSURL URLWithString:@"app-scheme://single/123?toto=titi"];
    NSURL *multiplePathParametersURL = [NSURL URLWithString:@"app-scheme://multiple/path/123?toto=titi"];
    
    NSString *singlePathPattern          = @"single/:objectID";
    NSString *fullURLSinglePathPattern   = @"app-scheme://single/:objectID";
    NSString *singlePathDashPattern      = @"/single/:objectID";
    NSString *multiplePathPattern        = @"multiple/path/:objectID";
    NSString *fullURLMultiplePathPattern = @"app-scheme://multiple/path/:objectID";
    NSString *multiplePathDashPattern    = @"/multiple/path/:objectID";
    
    beforeAll(^{
        router = [[WAAppRouteMatcher alloc] init];
    });
    
    context(@"Single path", ^{
        it(@"Should be recognised without dash", ^{
            NSArray *urls = @[singlePathURL, singlePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should be recognised with app scheme", ^{
            NSArray *urls = @[singlePathURL, singlePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:fullURLSinglePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised with dash", ^{
            NSArray *urls = @[singlePathURL, singlePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathDashPattern]) should] beFalse];
            }
        });
    });
    
    context(@"Path with multiple elements", ^{
        it(@"Should be recognised without dash", ^{
            NSArray *urls = @[multiplePathURL, multiplePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should be recognised with app scheme", ^{
            NSArray *urls = @[multiplePathURL, multiplePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:fullURLMultiplePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised with dash", ^{
            NSArray *urls = @[multiplePathURL, multiplePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathDashPattern]) should] beFalse];
            }
        });
    });
    
});

describe(@"Full url without object ID", ^{
    
    __block WAAppRouteMatcher *router = nil;
    
    NSURL *singlePathURL             = [NSURL URLWithString:@"http://www.domain.com/single/123"];
    NSURL *multiplePathURL           = [NSURL URLWithString:@"http://www.domain.com/multiple/path/123"];
    NSURL *singlePathParametersURL   = [NSURL URLWithString:@"http://www.domain.com/single/123?toto=titi"];
    NSURL *multiplePathParametersURL = [NSURL URLWithString:@"http://www.domain.com/multiple/path/123?toto=titi"];
    
    NSString *singlePathPattern          = @"single/:objectID";
    NSString *fullURLSinglePathPattern   = @"http://www.domain.com/single/:objectID";
    NSString *singlePathDashPattern      = @"/single/:objectID";
    NSString *multiplePathPattern        = @"multiple/path/:objectID";
    NSString *fullURLMultiplePathPattern = @"http://www.domain.com/multiple/path/:objectID";
    NSString *multiplePathDashPattern    = @"/multiple/path/:objectID";
    
    beforeAll(^{
        router = [[WAAppRouteMatcher alloc] init];
    });
    
    context(@"Single path", ^{
        it(@"Should be recognised without dash", ^{
            NSArray *urls = @[singlePathURL, singlePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should be recognised with app scheme", ^{
            NSArray *urls = @[singlePathURL, singlePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:fullURLSinglePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised with dash", ^{
            NSArray *urls = @[singlePathURL, singlePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathDashPattern]) should] beFalse];
            }
        });
    });
    
    context(@"Path with multiple elements", ^{
        it(@"Should be recognised without dash", ^{
            NSArray *urls = @[multiplePathURL, multiplePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should be recognised with app scheme", ^{
            NSArray *urls = @[multiplePathURL, multiplePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:fullURLMultiplePathPattern]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised with dash", ^{
            NSArray *urls = @[multiplePathURL, multiplePathParametersURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathDashPattern]) should] beFalse];
            }
        });
    });
    
});

describe(@"Wildcard URL", ^{
    __block WAAppRouteMatcher *router = nil;

    NSURL *singlePathURL        = [NSURL URLWithString:@"app-scheme://single/test"];
    NSURL *multiplePathURL      = [NSURL URLWithString:@"app-scheme://multiple/path/:objectID/test"];
    NSURL *singlePathExtraURL   = [NSURL URLWithString:@"app-scheme://single/:objectID/extra"];
    NSURL *multiplePathExtraURL = [NSURL URLWithString:@"app-scheme://multiple/path/:objectID/extra"];
    
    NSString *singlePathWildCardPattern          = @"single/*";
    NSString *multiplePathWildCardPattern        = @"multiple/path/*";
    NSString *singlePathWildCardPatternBetween   = @"single/*/extra";
    NSString *multiplePathWildCardPatternBetween = @"multiple/path/*/extra";

    beforeAll(^{
        router = [[WAAppRouteMatcher alloc] init];
    });
    
    context(@"Single path with wildcard at the end", ^{
        it(@"Should be recognised", ^{
            NSArray *urls = @[singlePathURL, singlePathExtraURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathWildCardPattern]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised", ^{
            NSArray *urls = @[multiplePathURL, multiplePathExtraURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathWildCardPattern]) should] beFalse];
            }
        });
    });

    context(@"Single path with wildcard in the middle", ^{
        it(@"Should be recognised", ^{
            NSArray *urls = @[singlePathExtraURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathWildCardPatternBetween]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised", ^{
            NSArray *urls = @[multiplePathExtraURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:singlePathWildCardPatternBetween]) should] beFalse];
            }
        });
    });
    
    context(@"Multiple path with wildcard at the end", ^{
        it(@"Should be recognised", ^{
            NSArray *urls = @[multiplePathURL, multiplePathExtraURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathWildCardPattern]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised", ^{
            NSArray *urls = @[singlePathURL, singlePathExtraURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathWildCardPattern]) should] beFalse];
            }
        });
    });
    
    context(@"Single path with wildcard in the middle", ^{
        it(@"Should be recognised", ^{
            NSArray *urls = @[multiplePathExtraURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathWildCardPatternBetween]) should] beTrue];
            }
        });
        
        it(@"Should not be recognised", ^{
            NSArray *urls = @[singlePathExtraURL];
            for (NSURL *url in urls) {
                [[theValue([router matchesURL:url fromPathPattern:multiplePathWildCardPatternBetween]) should] beFalse];
            }
        });
    });
    
});

SPEC_END