//
//  ViewController.m
//  STLocation
//
//  Created by 梁志云 on 16/6/17.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "ViewController.h"
#import "STLocationSendViewController.h"
#import "STLocationModel.h"
#import "STLocationBrowser.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (nonatomic, strong) STLocationModel *locationModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}

- (IBAction)onSendClick:(id)sender {
    
    STLocationSendViewController *locationSendViewController = [[STLocationSendViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    
    [locationSendViewController setSendCompletion:^(STLocationModel *locationModel) {
        NSLog(@"%@", locationModel);
        if (!locationModel) {
            return;
        }
        __strong typeof (weakSelf) strongSelf = weakSelf;
        
        strongSelf.image.image = locationModel.posterImage;
        strongSelf.locationModel = locationModel;
    }];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:locationSendViewController] animated:YES completion:nil];
    
}

- (IBAction)onLocationClick:(id)sender {
    
    STLocationBrowser *locationBrowser = [[STLocationBrowser alloc] initWithLocationModel:self.locationModel];
    [self.navigationController pushViewController:locationBrowser animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
