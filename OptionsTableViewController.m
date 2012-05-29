//
//  OptionsTableViewController.m
//  iMNet Bryan2
//
//  Created by Bryan on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsTableViewController.h"


@implementation OptionsTableViewController
@synthesize managedObjectContext;
@synthesize networkIDLabel,usernameLabel,addr16,addr64;
@synthesize rscMgr;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{   FrameID = 1;
    [super viewDidLoad];

    
    NSFetchRequest *fetchOwnSettings = [[NSFetchRequest alloc] init];
    NSEntityDescription *ownSettingsEntity = [NSEntityDescription entityForName:@"OwnSettings" inManagedObjectContext:managedObjectContext];
    [fetchOwnSettings setEntity:ownSettingsEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"atCommand == %@",@"ID"];
    [fetchOwnSettings setPredicate:predicate];
    
    NSError *error = nil;
    OwnSettings *fetchedID = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    if (fetchedID) {
        self.networkIDLabel.text = [NSString stringWithFormat:@"%@", [fetchedID atSetting]];
    }
    
    NSPredicate *predicateNI = [NSPredicate predicateWithFormat:@"atCommand == %@",@"NI"];
    [fetchOwnSettings setPredicate:predicateNI];
    
    error = nil;
    OwnSettings *fetchedNI = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    
    if (fetchedNI) {
        self.usernameLabel.text = [fetchedNI atSetting];
    }
    
    
    NSPredicate *predicateSH = [NSPredicate predicateWithFormat:@"atCommand == %@",@"SH"];
    [fetchOwnSettings setPredicate:predicateSH];
    
    error = nil;
    OwnSettings *fetchedSH = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    
    
    NSPredicate *predicateSL = [NSPredicate predicateWithFormat:@"atCommand == %@",@"SL"];
    [fetchOwnSettings setPredicate:predicateSL];
    
    error = nil;
    OwnSettings *fetchedSL = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    
    if (fetchedSH && fetchedNI) {
        self.addr64.text = [NSString stringWithFormat:@"%@%@", [fetchedSH atSetting], [fetchedSL atSetting]];
    }
    
    NSPredicate *predicateMY = [NSPredicate predicateWithFormat:@"atCommand == %@",@"MY"];
    [fetchOwnSettings setPredicate:predicateMY];
    error = nil;
    OwnSettings *fetchedMY = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    
    if (fetchedMY) {
        self.addr16.text = [NSString stringWithFormat:@"%@", [fetchedMY atSetting]];
    }

    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    /*
    NSMutableArray *sectHeadings = [[NSMutableArray alloc] initWithCapacity:2];
    [sectHeadings addObject:[NSString stringWithFormat:@"Network Configuration"]];
    [sectHeadings addObject:[NSString stringWithFormat:@"Advanced Options"]];
    
    sectionHeadings = sectionHeadings;
    
    NSMutableArray *netSettings = [[NSMutableArray alloc] initWithCapacity:4];
    [netSettings addObject:[NSString stringWithFormat:@"Pan ID"]];
    [netSettings addObject:[NSString stringWithFormat:@"Node Identifier"]];
    [netSettings addObject:[NSString stringWithFormat:@"64-Bit Address"]];
    [netSettings addObject:[NSString stringWithFormat:@"16-Bit Address"]];
    
    networkSettings = netSettings;
    
    NSMutableArray *advanced = [[NSMutableArray alloc] initWithCapacity:2];
    [advanced addObject:[NSString stringWithFormat:@"More Options"]];
    [advanced addObject:[NSString stringWithFormat:@"Hex Editor"]];
    
    advancedSettings = advanced;
    
    NSMutableArray *sect = [[NSMutableArray alloc] initWithCapacity:2];
    [sect addObject:netSettings];
    [sect addObject:advanced];
    
    sections = sect;
    */
    
}

- (void)viewDidUnload
{
    networkIDLabel = nil;
    usernameLabel = nil;
    addr64 = nil;
    addr16 = nil;
    addr64 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(optionsTableUpdate:) name:@"optionsTableUpdate" object:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"optionsTableUpdate" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    
    // Return the number of sections.
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OptionsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}

 
 */
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertView *alertViewNetID= [[UIAlertView alloc] initWithTitle:@"Change Network" message:@"Please enter a 3-8 character network name to join" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
            alertViewNetID.tag = 1;
            alertViewNetID.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            [alertViewNetID show];
            }
        if (indexPath.row == 1) {
            UIAlertView *alertViewUsername= [[UIAlertView alloc] initWithTitle:@"Set Username" message:@"Please enter a username" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
            alertViewUsername.tag=2;
            alertViewUsername.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertViewUsername show];
    }
    }}

- (void)optionsTableUpdate:(NSNotification *)notification
{
    NSFetchRequest *fetchOwnSettings = [[NSFetchRequest alloc] init];
    NSEntityDescription *ownSettingsEntity = [NSEntityDescription entityForName:@"OwnSettings" inManagedObjectContext:managedObjectContext];
    [fetchOwnSettings setEntity:ownSettingsEntity];
    
    NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"atCommand == %@",@"ID"];
    [fetchOwnSettings setPredicate:predicateID];
    
    NSError *error = nil;
    OwnSettings *fetchedID = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    if (fetchedID) {
        self.networkIDLabel.text = [NSString stringWithFormat:@"%@", [fetchedID atSetting]];
    }

    NSPredicate *predicateNI = [NSPredicate predicateWithFormat:@"atCommand == %@",@"NI"];
    [fetchOwnSettings setPredicate:predicateNI];
    
    error = nil;
    OwnSettings *fetchedNI = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    
    if (fetchedNI) {
        self.usernameLabel.text = [fetchedNI atSetting];
    }
    
      
    NSPredicate *predicateSH = [NSPredicate predicateWithFormat:@"atCommand == %@",@"SH"];
    [fetchOwnSettings setPredicate:predicateSH];
    
    error = nil;
    OwnSettings *fetchedSH = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    
    
    NSPredicate *predicateSL = [NSPredicate predicateWithFormat:@"atCommand == %@",@"SL"];
    [fetchOwnSettings setPredicate:predicateSL];
    
    error = nil;
    OwnSettings *fetchedSL = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    
    if (fetchedSH && fetchedNI) {
        self.addr64.text = [NSString stringWithFormat:@"%@%@", [fetchedSH atSetting], [fetchedSL atSetting]];
    }

    
    NSPredicate *predicateMY = [NSPredicate predicateWithFormat:@"atCommand == %@",@"MY"];
    [fetchOwnSettings setPredicate:predicateMY];
    error = nil;
    OwnSettings *fetchedMY = [[managedObjectContext executeFetchRequest:fetchOwnSettings error:&error] lastObject];
    
    if (fetchedMY) {
        self.addr16.text = [NSString stringWithFormat:@"%@", [fetchedMY atSetting]];
    }

  //  [self.tableView reloadData];
    
    // Retrieve information about the document and update the panel
}

- (IBAction)updateNetworkDetails:(id)sender {
    XbeeTx *XbeeObj = [XbeeTx new];
    //set up ATCommand for PAN ID
    //[XbeeObj ATCommandSetString:@"ID" withParameter:infoEntered withFrameID:FrameID];
    [XbeeObj ATCommand:@"ID" withFrameID:FrameID];
    NSArray *sendPacket = [XbeeObj txPacket];
    for ( int i = 0; i< (int)[sendPacket count]; i++ ) {
        txBuffer[i] = [[sendPacket objectAtIndex:i] unsignedIntValue]; 
    }
    int bytesWritten = [rscMgr write:txBuffer Length:[sendPacket count]];
    FrameID = FrameID + 1;  //increment FrameID
    if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
        FrameID = 1;
    }
    
    XbeeTx *XbeeObjNI = [XbeeTx new];
    //set up ATCommand for Node ID
    //[XbeeObj ATCommandSetString:@"ID" withParameter:infoEntered withFrameID:FrameID];
    [XbeeObjNI ATCommand:@"NI" withFrameID:FrameID];
    NSArray *sendPacketNI = [XbeeObjNI txPacket];
    for ( int i = 0; i< (int)[sendPacketNI count]; i++ ) {
        txBuffer[i] = [[sendPacketNI objectAtIndex:i] unsignedIntValue]; 
    }
    bytesWritten = [rscMgr write:txBuffer Length:[sendPacketNI count]];
    FrameID = FrameID + 1;  //increment FrameID
    if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
        FrameID = 1;
    }
    
    XbeeTx *XbeeObjSH = [XbeeTx new];
    //set up ATCommand for 64bit serial high MAC address
    [XbeeObjSH ATCommand:@"SH" withFrameID:FrameID];
    NSArray *sendPacketSH = [XbeeObjSH txPacket];
    for ( int i = 0; i< (int)[sendPacketSH count]; i++ ) {
        txBuffer[i] = [[sendPacketSH objectAtIndex:i] unsignedIntValue]; 
    }
    bytesWritten = [rscMgr write:txBuffer Length:[sendPacketSH count]];
    FrameID = FrameID + 1;  //increment FrameID
    if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
        FrameID = 1;
    }
    
    XbeeTx *XbeeObjSL = [XbeeTx new];
    //set up ATCommand for 64 bit serial low MAC address
    [XbeeObjSL ATCommand:@"SL" withFrameID:FrameID];
    NSArray *sendPacketSL = [XbeeObjSL txPacket];
    for ( int i = 0; i< (int)[sendPacketSL count]; i++ ) {
        txBuffer[i] = [[sendPacketSL objectAtIndex:i] unsignedIntValue]; 
    }
    bytesWritten = [rscMgr write:txBuffer Length:[sendPacketSL count]];
    FrameID = FrameID + 1;  //increment FrameID
    if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
        FrameID = 1;
    }
     
    
    XbeeTx *XbeeObjMY = [XbeeTx new];
    //set up ATCommand for 16 bit network address
    [XbeeObjMY ATCommand:@"MY" withFrameID:FrameID];
    NSArray *sendPacketMY = [XbeeObjMY txPacket];
    for ( int i = 0; i< (int)[sendPacketMY count]; i++ ) {
        txBuffer[i] = [[sendPacketMY objectAtIndex:i] unsignedIntValue]; 
    }
    bytesWritten = [rscMgr write:txBuffer Length:[sendPacketMY count]];
    FrameID = FrameID + 1;  //increment FrameID
    if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
        FrameID = 1;
    }
    
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView*)alertView{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (alertView.tag==1) {
        if (([textField.text length] >= 3)&&([textField.text length] <=8)) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else if (alertView.tag==2) {
        if (([textField.text length] >= 3)&&([textField.text length] <=20)) {
            return YES;
        }
    
    else {
        return NO;
        }
    }
    else{
        return NO;
    }
}   
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==1) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:{
                NSString *infoEntered = [[alertView textFieldAtIndex:0] text];
                
                XbeeTx *XbeeObj = [XbeeTx new];
                //set up ATCommand for PAN ID
                [XbeeObj ATCommandSetString:@"NI" withParameter:infoEntered withFrameID:FrameID];
                NSArray *sendPacket = [XbeeObj txPacket];
                for ( int i = 0; i< (int)[sendPacket count]; i++ ) {
                    txBuffer[i] = [[sendPacket objectAtIndex:i] unsignedIntValue]; 
                }
                int bytesWritten = [rscMgr write:txBuffer Length:[sendPacket count]];
                FrameID = FrameID + 1;  //increment FrameID
                if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
                    FrameID = 1;
                }

                break; }   
            default:
                break;
        }

    }
    else if (alertView.tag==2) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:{
                NSString *infoEntered = [[alertView textFieldAtIndex:0] text];
                self.usernameLabel.text = infoEntered;                  
                XbeeTx *XbeeObj = [XbeeTx new];
                //set up ATCommand for PAN ID
                [XbeeObj ATCommandSetString:@"NI" withParameter:infoEntered withFrameID:FrameID];
                NSArray *sendPacket = [XbeeObj txPacket];
                for ( int i = 0; i< (int)[sendPacket count]; i++ ) {
                    txBuffer[i] = [[sendPacket objectAtIndex:i] unsignedIntValue]; 
                }
                int bytesWritten = [rscMgr write:txBuffer Length:[sendPacket count]];
                FrameID = FrameID + 1;  //increment FrameID
                if (FrameID == 256) {   //If FrameID > 0xFF, start counting from 1 again
                    FrameID = 1;
                }
                break; }   
            default:
                break;
        }

    
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"OptionsToHexEditor"])
	{
        HexEditorViewController *hexEditorViewController = segue.destinationViewController;
        hexEditorViewController.managedObjectContext = managedObjectContext;
        hexEditorViewController.rscMgr = rscMgr;
	}
    
    
    if ([segue.identifier isEqualToString:@"OptionsToMoreOptionsSegue"])
	{
        MoreOptionsViewController *moreOptionsViewController = segue.destinationViewController;
        moreOptionsViewController.rscMgr = rscMgr;
        moreOptionsViewController.managedObjectContext = managedObjectContext;
	}
}



@end
