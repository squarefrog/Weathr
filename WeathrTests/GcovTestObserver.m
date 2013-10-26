//
//  GcovTestObserver.m
//  Weathr
//
//  Suggested by Hugo Ferreira
//  15th October 2013
//  http://stackoverflow.com/questions/19136767/generate-gcda-files-with-xcode5-ios7-simulator-and-xctest
//

#import <XCTest/XCTestObserver.h>

@interface GcovTestObserver : XCTestObserver
@end

@implementation GcovTestObserver

- (void) stopObserving
{
    [super stopObserving];
    UIApplication* application = [UIApplication sharedApplication];
    [application.delegate applicationWillTerminate:application];
}

@end