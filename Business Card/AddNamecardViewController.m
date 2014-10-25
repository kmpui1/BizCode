//
//  AddNamecardViewController.m
//  Business Card
//
//  Created by Kar Mun Pui on 7/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import "AddNamecardViewController.h"

@interface AddNamecardViewController ()

@property (nonatomic) BOOL found;
@property (strong, nonatomic) NSArray *namecards;

@end

@implementation AddNamecardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // dismiss keyboard when user is not editting the UITextField or when user tapped on the background which is not the UITextField
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    [self useDocument];
    
    self.found = NO;
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // make "return key" hide keyboard
    return YES;
}

//Update the content every time appear the view
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performFetch];
    [self.searchNameTextField setText:@""];
    [self.idSearchTextField setText:@""];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self performFetch];
    [super viewDidDisappear:animated];
}

-(void)performFetch{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"NamecardData1"];
    self.namecards = [[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSSet *mySet = [NSSet setWithArray:self.namecards];
    self.namecards = [[mySet allObjects] mutableCopy];
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    [self performFetch];
}

-(void)setNamecards:(NSArray *)namecards{
    _namecards = namecards;
}

-(void)useDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"NamecardDocument"];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = self.document.managedObjectContext;
            }
        }];
    }else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = self.document.managedObjectContext;
            }
        }];
    }else {
        self.managedObjectContext = self.document.managedObjectContext;
    }
    
}

// send query to search for the namecard profile with given ID and name from the database server, return whether it is found or not
-(BOOL)searchDatabase
{
    NSString *nameSearch = self.searchNameTextField.text;
    NSString *idnumSearch = self.idSearchTextField.text;
    
    NSString *rawStr = [NSString stringWithFormat:@"ID=%@&Name=%@", idnumSearch, nameSearch];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://testforfun.noip.me:8080/search.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
    NSLog(@"%@", responseString);
    
    
    if ([responseString intValue] == 1) {
        self.found = YES;
        return YES;
    }
    else{
        return NO;
    }

}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)search:(id)sender {
    
    if (![self.searchNameTextField.text isEqualToString:@""] && ![self.idSearchTextField.text isEqualToString:@""]) {
        BOOL found = [self searchDatabase];
        
        if(found == YES){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Found" message:[NSString stringWithFormat:@"Saving Namecard for %@!", self.searchNameTextField.text] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            NSLog(@"Found");
            
            [self performSegueWithIdentifier:@"SearchSegue" sender:sender];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Found" message:[NSString stringWithFormat:@"Namecard not found for %@! \nSearch Again", self.searchNameTextField.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
            [self.searchNameTextField setText:@""];
            [self.idSearchTextField setText:@""];
            
            NSLog(@"Not Found");
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please make sure to fill in all text field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        NSLog(@"Fill in!");
    }
    
    
    
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SearchSegue"]) {
        NamecardDetailsViewController *controller = segue.destinationViewController;
        
        //for display purpose
        NSString *name = self.searchNameTextField.text;
        NSString *identity = self.idSearchTextField.text;
        controller.namecardName = name;
        controller.namecardId = identity;
        controller.page = 2;

    }
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"SearchSegue"] && self.found == YES)
    {
        return YES;
    }
    return NO;
}
@end
