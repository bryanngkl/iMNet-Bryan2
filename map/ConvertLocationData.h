//
//  ConvertLocationData.h
//  MBTiles Example
//
//  Created by Kenneth on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ConvertLocationData : NSObject{
    //NSString * locationString;
}


- (NSString *) createStringFromLocation: (CLLocationCoordinate2D) location;
- (CLLocationCoordinate2D) createLoctionFromString: (NSString *) string;
@end
