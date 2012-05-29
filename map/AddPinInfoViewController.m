//
//  AddPinInfoViewController.m
//  GUI_1
//
//  Created by Kenneth on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddPinInfoViewController.h"
#import "MapViewController.h"
#define kOFFSET_FOR_KEYBOARD 60.0

@implementation AddPinInfoViewController
@synthesize title;
@synthesize description;
@synthesize delegate = _delegate;
@synthesize managedObjectContext,rscMgr, stringToSend;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    DataClass *obj = [DataClass getInstance];
    title.text = obj.title;
    description.text = obj.description;
    NSLog(@"This is the data that we see in the modal view at first key=title=%@, description=%@, location=%@",obj.title,obj.description,obj.location);
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (title.editing){
        [title resignFirstResponder];
        [super touchesBegan:touches withEvent:event];
    }
}
-(IBAction)resignKeyboard:(id)sender{
    [sender resignFirstResponder];
}

- (void)viewDidUnload
{   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (segue.identifier == @"done"){
        [delegate infoAddedWithTitle:title.text andDescription:description.text];
        [delegate didReceiveMessage:@"SONG BOOOOO"];
    }
    
    if (segue.identifier ==@"cancel"){
    }
}
*/


- (IBAction)done:(id)sender {
    
    //DataClass *obj = [DataClass getInstance];
    //obj.title = title.text;
    //obj.description = description.text;
    
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
        plistPath = [documentsPath stringByAppendingPathComponent: [NSString stringWithFormat: @"plist.plist"] ];
    }
    
    if ([fileManager fileExistsAtPath: plistPath]) 
    {
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [plistDict removeObjectForKey:obj.title];
        [plistDict setObject:[[NSArray alloc] initWithObjects:obj.description,obj.location, nil] forKey:obj.title];
        obj.title = title.text;
        obj.description = description.text;
        NSLog(@"WE STORE THIS key=title=%@, description=%@, location=%@",obj.title,obj.description,obj.location);
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
        [plistDict removeObjectForKey:obj.title];
        [plistDict setObject:[[NSArray alloc] initWithObjects:obj.description,obj.location, nil] forKey:obj.title];
        obj.title = title.text;
        obj.description = description.text;
        NSLog(@"WE STORE THIS key=title=%@, description=%@, location=%@",obj.title,obj.description,obj.location);
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
    
    [self.delegate infoAddedWithTitle:title.text andDescription:description.text];
    [self.delegate didReceiveMessage:@"SONG BOOOOO"];
    //[self performSegueWithIdentifier:@"done" sender:sender];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing"); 
    
    if (textView.frame.origin.y + textView.frame.size.height > 480 - 216) {
        double offset = 480 - 216 - textView.frame.origin.y - textView.frame.size.height - 20;
        CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        
        self.view.frame = rect;
        
        [UIView commitAnimations];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing");
    
    CGRect rect = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *) textField
{
    NSLog(@"Hide keyboard");
    [textField resignFirstResponder];
    return YES;
};

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneButtonOnKeyboardPressed: (id)sender;
{
    [sender resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"sendLocationContactSegue"])
	{
        DataClass *obj = [DataClass getInstance];
        NSMutableString * strtosend = [NSMutableString stringWithString:title.text];
        NSString * descriptionstr = description.text;
        NSString * locationstr = obj.location; 
        
        [strtosend appendString:[NSString stringWithString:@"*"]];
        
        [strtosend appendString:descriptionstr];
        [strtosend appendString:@"*"];
        [strtosend appendString:locationstr];
        
        NSLog(@"This is the string to send: %@", strtosend);
        
		SendLocationContactsViewController *sendLocationContactsViewController = segue.destinationViewController;
        sendLocationContactsViewController.managedObjectContext = managedObjectContext;
        sendLocationContactsViewController.rscMgr = rscMgr;
        sendLocationContactsViewController.stringToSend = strtosend;
        NSLog(@"String to send is %@",sendLocationContactsViewController.stringToSend);
	}
}


@end
