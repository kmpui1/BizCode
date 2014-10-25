//
//  UserNamecardViewController.m
//  Business Card
//
//
//
//  Created by Kar Mun Pui on 6/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import "UserNamecardViewController.h"

@interface UserNamecardViewController ()

@property (strong,nonatomic) NSString *url;

@end

@implementation UserNamecardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self useDocument];
    
    [self.titleLabel setText:[NSString stringWithFormat:@"%@", [self.user valueForKey:@"title"]]];
    [self.nameLabel setText:[self.user valueForKey:@"name"]];
    [self.positionLabel setText:[self.user valueForKey:@"position"]];
    [self.companyLabel setText:[self.user valueForKey:@"company"]];
    [self.emailLabel setText:[self.user valueForKey:@"email"]];
    [self.phoneLabel setText:[self.user valueForKey:@"phone"]];
    [self.addressLabel setText:[self.user valueForKey:@"address"]];
    [self.idnumLabel setText:[NSString stringWithFormat:@"%@", [self.user valueForKey:@"idnum"]]];
    UIImage *image = [UIImage imageWithData:[self.user valueForKey:@"image"]];
    self.imageView.image = image;
}

//Update the content every time appear the view
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.titleLabel setText:[NSString stringWithFormat:@"%@", [self.user valueForKey:@"title"]]];
    [self.nameLabel setText:[self.user valueForKey:@"name"]];
    [self.positionLabel setText:[self.user valueForKey:@"position"]];
    [self.companyLabel setText:[self.user valueForKey:@"company"]];
    [self.emailLabel setText:[self.user valueForKey:@"email"]];
    [self.phoneLabel setText:[self.user valueForKey:@"phone"]];
    [self.addressLabel setText:[self.user valueForKey:@"address"]];
    [self.idnumLabel setText:[NSString stringWithFormat:@"%@", [self.user valueForKey:@"idnum"]]];
    UIImage *image = [UIImage imageWithData:[self.user valueForKey:@"image"]];
    self.imageView.image = image;
}

-(void)useDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"UserDocument"];
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

//User could get the QR code of his/her profile
-(IBAction)QRCode:(id)sender {
    self.url=[NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=qr&chs=320x320&chl=[{\"ID\":\"%@\",\"Name\":\"%@\"}]",[self.user valueForKey:@"idnum"],[self.user valueForKey:@"name"]];
    
    self.url=[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"UpdateSegue"]) {
        UserDetailsViewController *controller = segue.destinationViewController;
        controller.user = self.user;
        controller.page = 2;
    }
    else if ([[segue identifier] isEqualToString:@"QRCodeSegue"]) {
        QRCodeViewController *controller = segue.destinationViewController;
        controller.url = self.url;
    }
}

@end
