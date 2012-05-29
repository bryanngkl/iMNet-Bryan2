//
//  DataClass.m
//  MBTiles Example
//
//  Created by Kenneth on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass
@synthesize location, title,description;

static DataClass *instance =nil;    
+(DataClass *)getInstance    
{    
    @synchronized(self)    
    {    
        if(instance==nil)    
        {    
            
            instance= [DataClass new];    
        }    
    }    
    return instance;    
}

@end
