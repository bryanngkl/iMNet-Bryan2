//
//  Location.h
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contacts;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * locationTitle;
@property (nonatomic, retain) NSNumber * locationLongitude;
@property (nonatomic, retain) NSString * locationLatitude;
@property (nonatomic, retain) NSString * locationDescription;
@property (nonatomic, retain) Contacts *locationContact;

@end
