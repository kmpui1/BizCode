//
//  QRCodeViewController.m
//  Business Card
//
//  Created by Kar Mun Pui on 11/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Show imageUrl: %@",self.url);
    self.QRImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]]];
}


- (void)setImage:(UIImage *)image
{

    self.QRImageView.image = image;
    
    // when image is changed, we must delete files we've created (if any)
    //[[NSFileManager defaultManager] removeItemAtURL:_imageURL error:NULL];
    //[[NSFileManager defaultManager] removeItemAtURL:_thumbnailURL error:NULL];
    //self.imageURL = nil;
    //self.thumbnailURL = nil;
}

- (UIImage *)image
{
    return self.QRImageView.image;
}
@end
