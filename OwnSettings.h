//
//  OwnSettings.h
//  iMNet Bryan2
//
//  Created by Bryan on 16/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OwnSettings : NSManagedObject

@property (nonatomic, retain) NSString * atSetting;
@property (nonatomic, retain) NSString * atCommand;

@end
