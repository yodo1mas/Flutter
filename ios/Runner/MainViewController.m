//
//  MainViewController.m
//  Runner
//
//  Created by 周玉震 on 2021/9/17.
//

#import "MainViewController.h"
#import "FlutterYodo1Mas.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[FlutterYodo1Mas sharedInstance] buildWithController:self];
}

@end
