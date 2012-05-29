//
//  ConvertLocationData.m
//  MBTiles Example
//
//  Created by Kenneth on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConvertLocationData.h"

@implementation ConvertLocationData


- (NSString *) createStringFromLocation: (CLLocationCoordinate2D) location{
    NSMutableString *locationstring = [NSMutableString stringWithFormat:@"%010.6f", location.latitude];
    [locationstring appendString:@","];
    [locationstring appendString:[NSString stringWithFormat:@"%010.6f", location.longitude]];
    
    return locationstring;
    //[locationstring release];
}

- (CLLocationCoordinate2D) createLoctionFromString: (NSString *) string{
    
    NSString *separator = @",";
    NSArray *teststrings = [string componentsSeparatedByString:separator];
    NSString *latitude = [teststrings objectAtIndex:0];
    NSString *longitude = [teststrings objectAtIndex:1];
    
    CLLocationCoordinate2D location;
    location.latitude = [latitude doubleValue];
    location.longitude = [longitude doubleValue];
    
    return location;
    
}
/*
 NSString *latitudeString = [string substringWithRange: NSMakeRange(0,9)];
 NSString *longitudeString = [string substringWithRange: NSMakeRange(11,20)];
 
 NSString *latitudeString = [[NSString alloc] initWithString:[string substringToIndex:10]];
 NSString *longitudeString = [[NSString alloc] initWithString:[string substringFromIndex:10]];
 for (int i=0; i<10; i++) {
 NSString *temp = [[NSString alloc] initWithUTF8String:(const char *)c[i]];
 NSString *temp2 = [[NSString alloc] initWithUTF8String:(const char *)c[i+10]];
 //NSString *temp2 = [[NSString alloc] initWithCharacters:(const unichar*)[string characterAtIndex:i+10] length:1];
 [latitudeString appendString:temp];
 [longitudeString appendString:temp2];
 
 [temp release];
 [temp2 release];
 }
 */
@end