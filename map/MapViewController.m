//
//  MapViewController.m
//  GUI_1
//
//  Created by Kenneth on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#define kStartingZoom   1.0f
#import "RMMBTilesTileSource.h"
#import "RMMapContents.h"
#import "RMMarker.h"
#import "RMMarkerManager.h"
#import "ConvertLocationData.h"
#import "DataClass.h"

@implementation MapViewController
@synthesize deletePin;
@synthesize unhideButton;
@synthesize mapView;
@synthesize addInfo;
@synthesize txBufferArray;
@synthesize managedObjectContext;
@synthesize rscMgr;


- (void)testMarkers
{
	RMMarkerManager *markerManager = [mapView markerManager];
	NSArray *markers = [markerManager markers];
	
	NSLog(@"Nb markers %d", [markers count]);
	
	NSEnumerator *markerEnumerator = [markers objectEnumerator];
	RMMarker *aMarker;
	
	while (aMarker = (RMMarker *)[markerEnumerator nextObject])
		
	{
		RMProjectedPoint point = [aMarker projectedLocation];
		NSLog(@"Marker projected location: east:%lf, north:%lf", point.easting, point.northing);
		CGPoint screenPoint = [markerManager screenCoordinatesForMarker: aMarker];
		NSLog(@"Marker screen location: X:%lf, Y:%lf", screenPoint.x, screenPoint.y);
		CLLocationCoordinate2D coordinates =  [markerManager latitudeLongitudeForMarker: aMarker];
		NSLog(@"Marker Lat/Lon location: Lat:%lf, Lon:%lf", coordinates.latitude, coordinates.longitude);
		
		[markerManager removeMarker:aMarker];
	}
	
	// Put the marker back
	RMMarker *marker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-blue.png"]
											anchorPoint:CGPointMake(0.5, 1.0)];
    [marker changeLabelUsingText:@"Hello"];
	
	[markerManager addMarker:marker AtLatLong:[[mapView contents] mapCenter]];
	
	//[marker release];
	markers  = [markerManager markersWithinScreenBounds];
	
	NSLog(@"Nb Markers in Screen: %d", [markers count]);
	
	//	[mapView getScreenCoordinateBounds];
	
	[markerManager hideAllMarkers];
	[markerManager unhideAllMarkers];
	
    
    ;}


- (BOOL)mapView:(RMMapView *)map shouldDragMarker:(RMMarker *)marker withEvent:(UIEvent *)event
{
    /*
    //If you do not implement this function, then all drags on markers will be sent to the didDragMarker function.
    //If you always return YES you will get the same result
    //If you always return NO you will never get a call to the didDragMarker function
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString * key = (NSString *)currentlyTappedMarker.data;
    id objects = [plistDict objectForKey:key];
    NSLog(@"%@", [objects objectAtIndex:2]);
    */
    if ([(NSArray*)marker.data objectAtIndex:1] == @"Person") {
        return NO;
    }
    else
        return YES;
     
}



- (void)mapView:(RMMapView *)map didDragMarker:(RMMarker *)marker withEvent:(UIEvent *)event 
{
    CGPoint position = [[[event allTouches] anyObject] locationInView:mapView];
	RMMarkerManager *markerManager = [mapView markerManager];
	NSLog(@"New location: east:%lf north:%lf", [marker projectedLocation].easting, [marker projectedLocation].northing);
	CGRect rect = [marker bounds];
	[markerManager moveMarker:marker AtXY:CGPointMake(position.x,position.y +rect.size.height/3)];
    
    // set currently Tapped marker
    currentlyTappedMarker = marker;
    currentlyTappedMarker.data = marker.data;
    
    //Save Changes to plist
/*    // get paths from root direcory    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];   
    if (![fileManager fileExistsAtPath: plistPath]) 
    {
        plistPath = [documentsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"pinsInfo.plist"] ];
    }
    
    if ([fileManager fileExistsAtPath: plistPath]) 
    {
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
        NSString * locationstr = [convertManager createStringFromLocation:[markerManager latitudeLongitudeForMarker:marker]];
        
        id objects = [plistDict objectForKey:[(NSArray*)marker.data objectAtIndex:0]];
        //[plistDict removeObjectForKey:marker.data];
        [plistDict setObject:[[NSArray alloc] initWithObjects:[objects objectAtIndex:0],locationstr,[objects objectAtIndex:2], nil] forKey: [(NSArray*)marker.data objectAtIndex:0]];
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
        //        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] init];
        ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
        NSString * locationstr = [convertManager createStringFromLocation:[markerManager latitudeLongitudeForMarker:marker]];
        id objects = [plistDict objectForKey:[(NSArray*)marker.data objectAtIndex:0]];
        //[plistDict removeObjectForKey:marker.data];
        [plistDict setObject:[[NSArray alloc] initWithObjects:[objects objectAtIndex:0],locationstr,@"NO", nil] forKey: [(NSArray*)marker.data objectAtIndex:0]];
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
    }
*/    
    //Update COREDATA
    NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    [fetchLocation setEntity:locationEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationTitle == %@", [(NSArray*)marker.data objectAtIndex:0]];
    [fetchLocation setPredicate:predicate];
    
    NSError *error = nil;
    Location *fetchedResult = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] lastObject];
    
    ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
    NSString * locationstr = [convertManager createStringFromLocation:[markerManager latitudeLongitudeForMarker:marker]];
    
    if (!fetchedResult) {
        //create new Location
        Location *newLocation = (Location *) [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
        newLocation.locationTitle = [(NSArray*)marker.data objectAtIndex:0];
        newLocation.locationDescription = NULL;
        newLocation.locationLatitude = locationstr;
        newLocation.locationLongitude = NULL;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
    else{
        fetchedResult.locationLatitude = locationstr;
        NSLog(@"New location stored in locationtitle = %@ is %@", fetchedResult.locationTitle, locationstr);
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"contactUpdated" object:self];
    
/*    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    
    
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //updating plist
    // NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist"];
    ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
    NSString * locationstr = [convertManager createStringFromLocation:[markerManager latitudeLongitudeForMarker:marker]];
    
    id objects = [plistDict objectForKey:marker.data];
    //[plistDict removeObjectForKey:marker.data];
    [plistDict setObject:[[NSArray alloc] initWithObjects:[objects objectAtIndex:0],locationstr, nil] forKey: marker.data];
    
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
        [plistData writeToFile:plistPath atomically:YES];  
        NSLog(@"The latitude is and the longitude SAVED to the plist is %@", locationstr);
        //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        //[error release];
    }
*/    
    //[plistDict release];
    //[convertManager release];
    
    [marker hideLabel];
}



- (void) tapOnMarker: (RMMarker*) marker onMap: (RMMapView*) map
{
	NSLog(@"MARKER TAPPED!");
    [currentlyTappedMarker hideLabel];
    currentlyTappedMarker = marker;
    currentlyTappedMarker.data = marker.data;
    NSLog(@"the currently tapped market data is %@", [(NSArray*)currentlyTappedMarker.data objectAtIndex:0]);
    DataClass *obj = [DataClass getInstance];
    NSLog(@"This is the string that we currently store key=title=%@, description=%@, location=%@",obj.title,obj.description,obj.location);
    
    //getting the stored values from the plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
    id objects = [plistDict objectForKey:[(NSArray*)marker.data objectAtIndex:0]];
    //update data class
    
    obj.title = (NSString *) [(NSArray*)marker.data objectAtIndex:0];
    obj.description = [objects objectAtIndex:0];
    obj.location= [objects objectAtIndex:1];
    
    //test
    NSLog(@"This is the string that we will store next key=title=%@, description=%@, location=%@",obj.title,obj.description,obj.location);
    
    //[convertManager release];
    //[plistDict release];
    [marker showLabel];
    
    
    //GET marker info from core data
    NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    [fetchLocation setEntity:locationEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationTitle == %@", obj.title];
    [fetchLocation setPredicate:predicate];
    
    NSError *error = nil;
    Location *fetchedResult = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] lastObject];
    NSLog(@"From the COREDATA WE have retrived title= %@, location =%@ and description =%@", fetchedResult.locationTitle,fetchedResult.locationLatitude, fetchedResult.locationDescription);
    
    if (marker != currentLocationMarker) {
        [unhideButton setEnabled:YES];
        [unhideButton setHidden:NO];
        [addInfo setHidden:NO];
        [deletePin setHidden:NO];
    }
}



- (void)viewDidLoad
{
 /*   
    //Delete the data from COREDATA
    NSFetchRequest *fetchContacts = [[NSFetchRequest alloc] init];
    NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
    [fetchContacts setEntity:contactsEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@",@"iMNet"];
    [fetchContacts setPredicate:predicate];  
    
    NSError *error = nil;
    Location *fetchedResult = [[managedObjectContext executeFetchRequest:fetchContacts error:&error] lastObject];
    [managedObjectContext deleteObject:fetchedResult];
    if (![managedObjectContext save:&error]) {
        // Handle the error.
    }
*/    
    
    count =1;
    
    locationController = [[MyCLController alloc] init];
    locationController.delegate = self;
    [locationController.locationManager startUpdatingLocation];
    
    
	NSLog(@"Center: Lat: %lf Lon: %lf", mapView.contents.mapCenter.latitude, mapView.contents.mapCenter.longitude);
    
    CLLocationCoordinate2D startingPoint;
    
    
    startingPoint.latitude  = locationController.locationManager.location.coordinate.latitude;
    startingPoint.longitude = locationController.locationManager.location.coordinate.longitude;
    
    //test
    ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
    NSString *test = [convertManager createStringFromLocation:startingPoint];
    NSLog(@"This is the string that we will see %@",test);
    
    
    
    NSURL *tilesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"control-room-0.2.0" ofType:@"mbtiles"]];
    
    RMMBTilesTileSource *source = [[RMMBTilesTileSource alloc] initWithTileSetURL:tilesURL];
    
    
    [[RMMapContents alloc] initWithView:self.mapView tilesource:source centerLatLon:startingPoint zoomLevel:kStartingZoom maxZoomLevel:5.45 minZoomLevel:[source minZoom] backgroundImage:nil];
     
        //[[RMMapContents alloc] initWithView:self.mapView tilesource:source centerLatLon:startingPoint zoomLevel:kStartingZoom maxZoomLevel:[source maxZoom] minZoomLevel:[source minZoom] backgroundImage:nil];
    
    mapView.enableRotate = NO;
    mapView.deceleration = NO;
    
    mapView.backgroundColor = [UIColor blackColor];
    
    mapView.contents.zoom = kStartingZoom;
    
    //set marker
    RMMarkerManager *markerManager = [mapView markerManager];
	[mapView setDelegate:self];
    currentLocationMarker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-blue.png"]
                                                 anchorPoint:CGPointMake(0.5, 1.0)];
	//[currentLocationMarker setTextForegroundColor:[UIColor blueColor]];
	//[currentLocationMarker changeLabelUsingText:@"Hello"];
    
    UIFont *labelFont = [UIFont fontWithName:@"Courier" size:10];
    NSString *labelText =@"iMNet";
    UIColor *foregroundColor = [UIColor blueColor];
    UIColor *backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    [currentLocationMarker changeLabelUsingText:labelText font:labelFont foregroundColor:foregroundColor backgroundColor:backgroundColor];
	[markerManager addMarker:currentLocationMarker AtLatLong:startingPoint];
    
    //updating data class
    DataClass *obj = [DataClass getInstance];
    obj.title = labelText;
    obj.description = @"add description";
    obj.location = [convertManager createStringFromLocation:startingPoint];
    NSLog(@"The data class currently has title = %@, description = %@, and location = %@", obj.title,obj.description,obj.location);
    NSArray *CLMdata = [[NSArray alloc] initWithObjects:labelText, @"Person", nil];
    
    currentLocationMarker.data = CLMdata;
    currentlyTappedMarker = currentLocationMarker;
    currentlyTappedMarker.data = CLMdata;
/*    
    //Save to plist
    // get paths from root direcory    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
     
    NSFileManager *fileManager = [NSFileManager defaultManager];   
    if (![fileManager fileExistsAtPath: plistPath]) 
    {
        plistPath = [documentsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"pinsInfo.plist"] ];
    }
    
    if ([fileManager fileExistsAtPath: plistPath]) 
    {
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [plistDict setObject:[[NSArray alloc] initWithObjects:obj.description,obj.location, @"YES", nil]  forKey:obj.title] ;
        NSLog(@"Data SAVED");
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
//        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] init];
        [plistDict setObject:[[NSArray alloc] initWithObjects:obj.description,obj.location,@"YES", nil]  forKey:obj.title] ;
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
    }
*/    
    // create dictionary with values in UITextFields
    //NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist"];
    //[plistDict setObject:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@""],[convertManager createStringFromLocation:startingPoint], nil]  forKey:labelText] ;
/*    
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
        [plistData writeToFile:plistPath atomically:YES];
        //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        //[error release];
    }
    
    // [currentLocationMarker release];
    //[convertManager release];
    //[plistDict release];
 
 
*/  
    
    //Plot the previous pins
    NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    [fetchLocation setEntity:locationEntity];
    
    NSError *error = nil;
    NSMutableArray *fetchedResultArray = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] mutableCopy];
    
    for (Location *eachlocation in fetchedResultArray){
        if (eachlocation.locationContact == NULL) { //not a person marker
        NSLog(@"THE LOCATIONS STORED IN COREDATA");
        NSLog(@"title : %@", eachlocation.locationTitle);
            if (eachlocation.locationContact == NULL) {
                RMMarkerManager *markerManager = [mapView markerManager];
                //[mapView setDelegate:self];
                RMMarker * newMarker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-red.png"]
                                                            anchorPoint:CGPointMake(0.5, 1.0)];
                UIFont *labelFont = [UIFont fontWithName:@"Courier" size:10];
                UIColor *foregroundColor = [UIColor blueColor];
                UIColor *backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
                
                [newMarker changeLabelUsingText:eachlocation.locationTitle font:labelFont foregroundColor:foregroundColor backgroundColor:backgroundColor];
                ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
                [markerManager addMarker:newMarker AtLatLong:[convertManager createLoctionFromString:eachlocation.locationLatitude]];
                NSArray *datatostore = [[NSArray alloc] initWithObjects:eachlocation.locationTitle, @"notPerson", nil];
                currentlyTappedMarker = newMarker;
                currentlyTappedMarker.data = datatostore;
                [newMarker hideLabel];
            }
        }
    }
/*    
    //USE COREDATA
    NSFetchRequest *fetchContacts = [[NSFetchRequest alloc] init];
    NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
    [fetchContacts setEntity:contactsEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@",labelText];
    [fetchContacts setPredicate:predicate];    
    
    //NSError *error = nil;
    Contacts *fetchedResult = [[managedObjectContext executeFetchRequest:fetchContacts error:&error] lastObject];
    
    if (!fetchedResult) {
        //This method creates a new contact.
        Contacts *newContact = (Contacts *)[NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
        
        [newContact setAddress16:NULL];
        [newContact setAddress64:NULL];
        [newContact setUsername:labelText];
        [newContact setIsAvailable:[NSNumber numberWithBool:TRUE]];
        
        Location *newLocation = (Location *) [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
        newLocation.locationTitle = labelText;
        newLocation.locationDescription = obj.description;
        newLocation.locationLatitude = obj.location;
        newLocation.locationLongitude = NULL;
        newLocation.locationContact = newContact;
        
        //NSError *error = nil;
        //if (![managedObjectContext save:&error]) {
            // Handle the error.
        //}
    }
    else{
        fetchedResult.isAvailable = [NSNumber numberWithBool:TRUE];
        fetchedResult.contactLocation.locationLatitude = obj.location;
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactUpdated" object:self];
 */   
    //initialise FrameID counter;
    FrameID = 1;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) afterMapMove: (RMMapView*) map{
    [unhideButton setHidden:YES];
    [addInfo setHidden:YES];
    [deletePin setHidden:YES];
}


- (void) singleTapOnMap: (RMMapView*) map At: (CGPoint) point{
    
    [unhideButton setHidden:YES];
    [addInfo setHidden:YES];
    [deletePin setHidden:YES];
    [currentlyTappedMarker hideLabel];
    
    NSLog(@"%@", [(NSArray*)currentlyTappedMarker.data objectAtIndex:0]);
    
    NSFetchRequest *fetchContacts = [[NSFetchRequest alloc] init];
    NSEntityDescription *contactsEntity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:managedObjectContext];
    [fetchContacts setEntity:contactsEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@",@"iMNet"];
    [fetchContacts setPredicate:predicate];   
    
    NSError *error = nil;
    Contacts *fetchedResult = [[managedObjectContext executeFetchRequest:fetchContacts error:&error] lastObject];
    NSLog(@"FROM THE CORE DATA we have username=%@, 64address = %@, with the corresponding location =%@ and with location description = %@", fetchedResult.username,fetchedResult.address64,fetchedResult.contactLocation.locationLatitude,fetchedResult.contactLocation.locationDescription);
    
}
/*
- (void) doubleTapOnMap: (RMMapView*) map At: (CGPoint) point{
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist"];
    
    for(NSString *aKey in plistDict){
        NSLog(@"%@", aKey);
        //NSLog(@"%@", [[plistDict valueForKey:aKey] string]);
    }
    
};
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 - (void)dealloc
 {
 [mapView release];
 [locationController release];
 [unhideButton release];
 [currentLocationMarker release];
 [addInfo release];
 [super dealloc];
 }
 */

- (void)locationUpdate:(CLLocation *)location {
    
    
    float lat = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    startlat = lat;
    startlon = longitude;
    CLLocationCoordinate2D newlocation =CLLocationCoordinate2DMake(lat, longitude);
    
    NSString *display = [NSString stringWithFormat:@"%f,%f",lat, longitude];
    RMMarkerManager *markerManager = [mapView markerManager];
    //ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
    
    [markerManager moveMarker:currentLocationMarker AtLatLon:newlocation];
    
    locationLabel.text = display;
    //locationLabel.text = [location description];
}

- (void)locationError:(NSError *)error {
    locationLabel.text = [error description];
}

- (IBAction)dropPin:(id)sender {
    [currentlyTappedMarker hideLabel];
    
    //adding the marker
    RMMarkerManager *markerManager = [mapView markerManager];
	//[mapView setDelegate:self];
    RMMarker *marker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-red.png"]
											anchorPoint:CGPointMake(0.5, 1.0)];
    NSString *labelText =@"Add info";
    UIFont *labelFont = [UIFont fontWithName:@"Courier" size:10];
    UIColor *foregroundColor = [UIColor blueColor];
    UIColor *backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    //labelling the markers
    NSString * m = @"(M";
    NSString *num = [NSString stringWithFormat:@"%d)", count];
    NSString *mtag = [m stringByAppendingString:num];
    NSString *markertag = [labelText stringByAppendingString:mtag];    
    [marker changeLabelUsingText:markertag font:labelFont foregroundColor:foregroundColor backgroundColor:backgroundColor];
	[markerManager addMarker:marker AtLatLong:[[mapView contents] mapCenter]];
    [currentlyTappedMarker showLabel];
    //updating data class
    DataClass *obj = [DataClass getInstance];
    obj.title = markertag;
    obj.description = @"";
    ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
    NSString *location = [convertManager createStringFromLocation:[[mapView contents] mapCenter]];
    obj.location =location;
    // to check
    NSLog(@"This is the string that we will store key=title=%@, description=%@, location=%@",obj.title,obj.description,obj.location);
    
    //updating tag of currently tapped marker
    NSArray *datatostore = [[NSArray alloc] initWithObjects:markertag, @"notPerson", nil];
    marker.data = datatostore;
    currentlyTappedMarker = marker;
    currentlyTappedMarker.data = marker.data;
    //currentlyTappedMarker.data = markertag;
    count = count +1;
    
    //[convertManager release];
    
/*    //Save to plist
    // get paths from root direcory    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];   
    if (![fileManager fileExistsAtPath: plistPath]) 
    {
        plistPath = [documentsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"pinsInfo.plist"] ];
    }
    
    
    
    
    
    if ([fileManager fileExistsAtPath: plistPath]) 
    {
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [plistDict setObject:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@""],location,@"NO", nil] forKey:markertag];
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
        //        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] init];
        [plistDict setObject:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@""],location,@"NO", nil] forKey:markertag];
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
    }
*/    
    //USING CORE DATA
    NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    [fetchLocation setEntity:locationEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationTitle == %@", obj.title];
    [fetchLocation setPredicate:predicate];
    
    NSError *error = nil;
    Location *fetchedResult = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] lastObject];
    
    if (!fetchedResult) {
        //create new Location
        Location *newLocation = (Location *) [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
        newLocation.locationTitle = obj.title;
        newLocation.locationDescription = obj.description;
        newLocation.locationLatitude = obj.location;
       // newLocation.locationLongitude = NULL;
        NSError *error = nil;
        //[managedObjectContext save:&error ];
        if (![managedObjectContext save:&error]) {
        // Handle the error.
        }
    }
    else{
        fetchedResult.locationLatitude = obj.location;
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }

    
/*    
    // get paths from root direcory    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    // create dictionary with values in UITextFields
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist"];
    [plistDict setObject:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@""],location, nil] forKey:markertag];
    
    // NSData *null  = nil;
    //[null writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
    
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        // [error release];
    }
*/    
	//[marker release];
    // [plistDict release];
}

- (IBAction)locateMe:(id)sender {
    RMMarkerManager *markerManager = [mapView markerManager];
	[mapView setDelegate:self];
    //[markerManager removeMarker:currentLocationMarker]; //remove current location marker
    
    CLLocationCoordinate2D newLocation;
    newLocation.latitude = locationController.locationManager.location.coordinate.latitude;
    newLocation.longitude = locationController.locationManager.location.coordinate.longitude;
    [markerManager moveMarker:currentLocationMarker AtLatLon:newLocation];
    
    [mapView moveToLatLong:newLocation];
    /*
     RMMarker *marker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-blue.png"]
     anchorPoint:CGPointMake(0.5, 1.0)];
     [marker setTextForegroundColor:[UIColor blueColor]];
     [marker changeLabelUsingText:@"Hello"];
     [markerManager addMarker:marker AtLatLong:newLocation];
     [marker release];    
     */
    
}

- (void)viewDidUnload {
    [self setUnhideButton:nil];
    [self setAddInfo:nil];
    [self setDeletePin:nil];
    mapView = nil;
    mapView = nil;
    mapView = nil;
    [self setDeletePin:nil];
    [super viewDidUnload];
}

/*
- (IBAction)getInfoButton:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist"];
    ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
    RMMarkerManager *markerManager = [mapView markerManager];
    locationOfCurrentlyTappedMarker = [markerManager latitudeLongitudeForMarker:currentlyTappedMarker];  
    
    NSArray * objects = [plistDict objectForKey:currentlyTappedMarker.data];
    
    
    DataClass *obj = [DataClass getInstance];
    
    obj.title = (NSString *)currentlyTappedMarker.data;
    obj.description = [objects objectAtIndex:0];
    obj.location = [convertManager createStringFromLocation:[markerManager latitudeLongitudeForMarker:currentlyTappedMarker]];
    NSLog(@"This is the string that we will store key=title=%@, description=%@, location=%@",obj.title,obj.description,obj.location);
    
    AddPinInfoViewController *addPinInfoView = [[AddPinInfoViewController alloc] init];
    addPinInfoView.delegate = self;
    
    [self presentModalViewController:addPinInfoView animated:YES];
    
}
*/

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"GetPinInfoSegue"]) {

/*        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        // get documents path
        NSString *documentsPath = [paths objectAtIndex:0];
        // get the path to our Data/plist file
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        //NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist"];
        ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
        RMMarkerManager *markerManager = [mapView markerManager];
        locationOfCurrentlyTappedMarker = [markerManager latitudeLongitudeForMarker:currentlyTappedMarker];  
        NSArray * objects = [plistDict objectForKey:[(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
        
*/        
        
        ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
        RMMarkerManager *markerManager = [mapView markerManager];
        locationOfCurrentlyTappedMarker = [markerManager latitudeLongitudeForMarker:currentlyTappedMarker];
        //GET marker info from core data
        NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
        NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
        [fetchLocation setEntity:locationEntity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationTitle == %@", [(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
        [fetchLocation setPredicate:predicate];
        
        NSError *error = nil;
        Location *fetchedResult = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] lastObject];
        
        NSLog(@"From the COREDATA WE have retrived title= %@, location =%@ and description =%@", fetchedResult.locationTitle,fetchedResult.locationLatitude, fetchedResult.locationDescription);
    
        
        
        DataClass *obj = [DataClass getInstance];
        obj.title = (NSString *)[(NSArray*)currentlyTappedMarker.data objectAtIndex:0];
        obj.description = fetchedResult.locationDescription;
        obj.location = [convertManager createStringFromLocation:[markerManager latitudeLongitudeForMarker:currentlyTappedMarker]];
        NSLog(@"This is the string that we will store key=title=%@, description=%@, location=%@",obj.title,obj.description,obj.location);
        
/*        
        DataClass *obj = [DataClass getInstance];
        obj.title = (NSString *)[(NSArray*)currentlyTappedMarker.data objectAtIndex:0];
        obj.description = [objects objectAtIndex:0];
        obj.location = [convertManager createStringFromLocation:[markerManager latitudeLongitudeForMarker:currentlyTappedMarker]];
        NSLog(@"This is the string that we will store key=title=%@, description=%@, location=%@",obj.title,obj.description,obj.location);        
*/        
        AddPinInfoViewController *apivc = (AddPinInfoViewController *)[segue destinationViewController];
        apivc.title.text = obj.title;
        apivc.description.text = obj.description;
        apivc.delegate = self;
        
        AddPinInfoViewController *nextViewController = segue.destinationViewController;
        nextViewController.managedObjectContext = managedObjectContext;
        nextViewController.rscMgr = rscMgr;
        
        
    }
}

- (IBAction)deleteCurrentPin:(id)sender {
    //Save Changes to plist
 /*   // get paths from root direcory    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];   
    if (![fileManager fileExistsAtPath: plistPath]) 
    {
        plistPath = [documentsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"pinsInfo.plist"] ];
    }
    
    if ([fileManager fileExistsAtPath: plistPath]) 
    {
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [plistDict removeObjectForKey:[(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
        //        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] init];
        [plistDict removeObjectForKey:[(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
    }
  */  
    //Delete the data from COREDATA
    NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    [fetchLocation setEntity:locationEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationTitle == %@", [(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
    [fetchLocation setPredicate:predicate];
    
    NSError *error = nil;
    Location *fetchedResult = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] lastObject];
    [managedObjectContext deleteObject:fetchedResult];
    if (![managedObjectContext save:&error]) {
        // Handle the error.
    }
    
    
    //Delete the marker
    RMMarkerManager *markerManager = [mapView markerManager];
    [markerManager removeMarker:currentlyTappedMarker];
    
    currentlyTappedMarker = NULL;
    currentlyTappedMarker.data = NULL;
    
    
    
}

- (IBAction)getNearbyInfo:(id)sender {
    /*
     RMMarkerManager *markerManager = [mapView markerManager];
     [mapView setDelegate:self];
     
     UIFont *labelFont = [UIFont fontWithName:@"Courier" size:10];
     UIColor *foregroundColor = [UIColor blueColor];
     UIColor *backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
     
     NSLog(@"%@", currentlyTappedMarker.data);
     */
/*    
    RMMarkerManager *markerManager = [mapView markerManager];
	//[mapView setDelegate:self];
    RMMarker *marker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-red.png"]
											anchorPoint:CGPointMake(0.5, 1.0)];
    NSString *labelText =@"Add info";
    UIFont *labelFont = [UIFont fontWithName:@"Courier" size:10];
    UIColor *foregroundColor = [UIColor blueColor];
    UIColor *backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    //labelling the markers
    NSString * m = @"(M";
    NSString *num = [NSString stringWithFormat:@"%d)", count];
    NSString *mtag = [m stringByAppendingString:num];
    NSString *markertag = [labelText stringByAppendingString:mtag];    
    [marker changeLabelUsingText:markertag font:labelFont foregroundColor:foregroundColor backgroundColor:backgroundColor];
    ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
	[markerManager addMarker:marker AtLatLong:[convertManager createLoctionFromString:@"037.785834,-122.406417"]];
 */    
 /*    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
     // get documents path
     NSString *documentsPath = [paths objectAtIndex:0];
     // get the path to our Data/plist file
     NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
     NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
   */  
  /*  
    NSArray * objects = [plistDict objectForKey:@"Add Info(2)"];
    NSLog(@"description = %@ and location = %@", [objects objectAtIndex:0], [objects objectAtIndex:1]);
    RMMarkerManager *markerManager = [mapView markerManager];
	//[mapView setDelegate:self];
    RMMarker *marker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-red.png"]
											anchorPoint:CGPointMake(0.5, 1.0)];
    NSString *labelText =@"Add info";
    UIFont *labelFont = [UIFont fontWithName:@"Courier" size:10];
    UIColor *foregroundColor = [UIColor blueColor];
    UIColor *backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    [marker changeLabelUsingText:@"Add Info(M2)" font:labelFont foregroundColor:foregroundColor backgroundColor:backgroundColor];
    ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
    [markerManager addMarker:marker AtLatLong:[convertManager createLoctionFromString:@"037.785834,-122.406417"]];
 */
 
    //NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist"];
  /*  
    for(NSString *aKey in plistDict){
        NSLog(@"%@", aKey);
        if ((NSString *)aKey != [(NSArray*)currentLocationMarker.data objectAtIndex:0]) {
            NSArray * objects = [plistDict objectForKey:aKey];
            NSLog(@"description = %@ and location = %@", [objects objectAtIndex:0], [objects objectAtIndex:1]);
            RMMarkerManager *markerManager = [mapView markerManager];
            //[mapView setDelegate:self];
            
        
        
        
            RMMarker * newMarker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-blue-withletter.png"]
                                                        anchorPoint:CGPointMake(0.5, 1.0)];
            
            UIFont *labelFont = [UIFont fontWithName:@"Courier" size:10];
            UIColor *foregroundColor = [UIColor blueColor];
            UIColor *backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
            
            [newMarker changeLabelUsingText:aKey font:labelFont foregroundColor:foregroundColor backgroundColor:backgroundColor];
            ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
            [markerManager addMarker:newMarker AtLatLong:[convertManager createLoctionFromString:[objects objectAtIndex:1]]];
            NSArray *datatostore = [[NSArray alloc] initWithObjects:aKey, @"Person", nil];
            
            currentlyTappedMarker = newMarker;
            currentlyTappedMarker.data = datatostore;
            [newMarker hideLabel];
        }
    
    }
 */   
    
    //Get INFO from COREDATA
    NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    [fetchLocation setEntity:locationEntity];
    
    NSError *error = nil;
    NSMutableArray *fetchedResultArray = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] mutableCopy];
    
    for (Location *eachlocation in fetchedResultArray){
        NSLog(@"THE LOCATIONS STORED IN COREDATA");
        NSLog(@"title : %@", eachlocation.locationTitle);
        if (eachlocation.locationContact == NULL){
        //if ((eachlocation.locationContact != NULL) && (eachlocation.locationTitle == [(NSArray*)currentlyTappedMarker.data objectAtIndex:0])) {
        RMMarkerManager *markerManager = [mapView markerManager];
        //[mapView setDelegate:self];
        RMMarker * newMarker = [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-blue-withletter.png"]
                                                    anchorPoint:CGPointMake(0.5, 1.0)];
        UIFont *labelFont = [UIFont fontWithName:@"Courier" size:10];
        UIColor *foregroundColor = [UIColor blueColor];
        UIColor *backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        
        [newMarker changeLabelUsingText:eachlocation.locationTitle font:labelFont foregroundColor:foregroundColor backgroundColor:backgroundColor];
        ConvertLocationData *convertManager = [[ConvertLocationData alloc] init];
        [markerManager addMarker:newMarker AtLatLong:[convertManager createLoctionFromString:eachlocation.locationLatitude]];
        NSArray *datatostore = [[NSArray alloc] initWithObjects:eachlocation.locationTitle, @"Person", nil];
        currentlyTappedMarker = newMarker;
        currentlyTappedMarker.data = datatostore;
        [newMarker hideLabel];
        }

    }
    
       //  NSArray * objects = [plistDict objectForKey:aKey];
        /*
         ConvertLocationData *convertManager = [[[ConvertLocationData alloc] init] autorelease];
         currentLocationMarker= [[RMMarker alloc]initWithUIImage:[UIImage imageNamed:@"marker-blue.png"]
         anchorPoint:CGPointMake(0.5, 1.0)];
         [currentLocationMarker changeLabelUsingText:aKey font:labelFont foregroundColor:foregroundColor backgroundColor:backgroundColor];
         [markerManager addMarker:currentLocationMarker AtLatLong:[convertManager createLoctionFromString:[objects objectAtIndex:1]]];
         */   
    
    
    // [plistDict release];
    //currentlyTappedMarker.data = @"hi";
}


- (void) infoAddedWithTitle: (NSString *) title andDescription: (NSString*) description{
    
    //NSString *mymessage = [[NSString alloc] initWithString:message];
    NSLog(@"%@, %@", title, description);
    
    DataClass *obj = [DataClass getInstance];
    //updating currently tapped marker
    NSArray *CLMdata = [[NSArray alloc] initWithObjects:title, [(NSArray*)currentlyTappedMarker.data objectAtIndex:1], nil];
    currentlyTappedMarker.data = CLMdata;

/*    
    //Save to plist
    // get paths from root direcory    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];   
    if (![fileManager fileExistsAtPath: plistPath]) 
    {
        plistPath = [documentsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"pinsInfo.plist"] ];
    }
    
    if ([fileManager fileExistsAtPath: plistPath]) 
    {
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        id objects = [plistDict objectForKey:[(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
        NSString * isperson = [objects objectAtIndex:2];
        NSString *checkifperson = [(NSArray*)currentlyTappedMarker.data objectAtIndex:1];
        [plistDict removeObjectForKey:[(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
        [plistDict setObject:[[NSArray alloc] initWithObjects:description,obj.location,isperson, nil] forKey:title];
        //updating currently tapped marker
        NSArray *CLMdata = [[NSArray alloc] initWithObjects:title, checkifperson, nil];
        currentlyTappedMarker.data = CLMdata;
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
        //        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] init];
        [plistDict removeObjectForKey:[(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
        [plistDict setObject:[[NSArray alloc] initWithObjects:description,obj.location,@"NO", nil] forKey:title];

        
        //updating currently tapped marker
        currentlyTappedMarker.data = title;
        NSString *error = nil;
        // create NSData from dictionary
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];    
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
            [plistData writeToFile:plistPath atomically:YES];
            //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
        }
        else
        {
            NSLog(@"Error in saveData: %@", error);
            //[error release];
        }
    }
*/
    //USING CORE DATA
    NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    [fetchLocation setEntity:locationEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationTitle == %@", obj.title];
    [fetchLocation setPredicate:predicate];
    
    NSError *error = nil;
    Location *fetchedResult = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] lastObject];
    
    if (!fetchedResult) {
        //create new Location
        Location *newLocation = (Location *) [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:managedObjectContext];
        newLocation.locationTitle = title;
        newLocation.locationDescription = description;
        newLocation.locationLatitude = obj.location;
        newLocation.locationLongitude = NULL;
        NSLog(@"The location title was changed, we saved in COREDATA title = %@, location =%@ and description = %@", title, obj.location, description);
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
    else{
        fetchedResult.locationTitle = title;
        fetchedResult.locationDescription =description;
        fetchedResult.locationLatitude = obj.location;
        NSLog(@"The location title was NOT changed, we saved in COREDATA title = %@, location =%@ and description = %@", title, obj.location, description);
        if (![managedObjectContext save:&error]) {
            // Handle the error.
        }
    }
    
    //update data class
    obj.title= title;
    obj.description =description;
/*    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //updating plist
    //NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist"];
    
    [plistDict removeObjectForKey:currentlyTappedMarker.data];
    [plistDict setObject:[[NSArray alloc] initWithObjects:description,obj.location, nil] forKey:title];
    
    
    //updating currently tapped marker
    currentlyTappedMarker.data = title;
    
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91/pinsInfo.plist" atomically:YES];
        [plistData writeToFile:plistPath atomically:YES];
        NSLog(@"The latitude is %f and the longitude SAVED to the plist is %f",locationOfCurrentlyTappedMarker.latitude,locationOfCurrentlyTappedMarker.longitude);
        //[plistData writeToFile:@"/Users/Kenneth/Desktop/ipad programming/mapbox-mbtiles-ios-example-9a26f91" atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        //[error release];
    }
*/    
    //Change Label
    //UIFont *labelFont = [UIFont fontWithName:@"Courier" size:10];
    //UIColor *foregroundColor = [UIColor blueColor];
    //UIColor *backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [currentlyTappedMarker changeLabelUsingText:title font:[UIFont fontWithName:@"Courier" size:10] foregroundColor:[UIColor blueColor] backgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
    
    //[plistDict release];
    //  [error release]; 
}

- (void) didReceiveMessage:(NSString *)message{
    NSLog(@"%@", message);
}
- (IBAction)sendLocation:(id)sender {
  /*  
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"pinsInfo.plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray * objects = [plistDict objectForKey:[(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
*/
    
    //GET marker info from core data
    NSFetchRequest *fetchLocation = [[NSFetchRequest alloc] init];
    NSEntityDescription *locationEntity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext];
    [fetchLocation setEntity:locationEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationTitle == %@", [(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
    [fetchLocation setPredicate:predicate];
    
    NSError *error = nil;
    Location *fetchedResult = [[managedObjectContext executeFetchRequest:fetchLocation error:&error] lastObject];

    
    
    NSMutableString * stringtosend = [NSMutableString stringWithString:(NSString *)[(NSArray*)currentlyTappedMarker.data objectAtIndex:0]];
    NSString * description = fetchedResult.locationDescription;
    NSString * location = fetchedResult.locationLatitude; 
    //NSString * description = [objects objectAtIndex:0];
   // NSString * location = [objects objectAtIndex:1];   
    
      
    [stringtosend appendString:[NSString stringWithString:@"*"]];
 
    [stringtosend appendString:description];
    [stringtosend appendString:@"*"];
    [stringtosend appendString:location];
    
    NSLog(@"This is the string to send: %@", stringtosend);
    
    XbeeTx *XbeeObj = [XbeeTx alloc];
    
    [XbeeObj TxMessage:stringtosend ofSize:0 andMessageType:3 withStartID:FrameID withFrameID:FrameID withPacketFrameId:FrameID withDestNode64:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithUnsignedInt:0],[NSNumber numberWithUnsignedInt:19],[NSNumber numberWithUnsignedInt:162],[NSNumber numberWithUnsignedInt:0],[NSNumber numberWithUnsignedInt:64],[NSNumber numberWithUnsignedInt:124],[NSNumber numberWithUnsignedInt:110],[NSNumber numberWithUnsignedInt:199] , nil] withDestNetworkAddr16:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithUnsignedInt:0],[NSNumber numberWithUnsignedInt:0] , nil]];
     
     NSArray *sendPacket = [XbeeObj txPacket];    
     for ( int i = 0; i < (int)[sendPacket count]; i++ ) {
         txBuffer[i] = [[sendPacket objectAtIndex:i] unsignedIntValue];
     }
     int bytesWritten = [rscMgr write:txBuffer Length:[sendPacket count]];
     
     FrameID = FrameID + 1;  //increment FrameID
     if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
         FrameID = 1;
     }    
}

@end