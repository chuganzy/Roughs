//
//  ProjectListViewController.m
//  Roughs
//
//  Created by Takeru Chuganji on 11/16/14.
//  Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "ProjectListViewController.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import <HCPopBackGestureProxy/HCPopBackGestureProxy.h>
#import "APIClient.h"
#import "ProjectListTableViewCell.h"
#import "ProjectViewController.h"

@interface ProjectListViewController () <UITableViewDataSource, UITableViewDelegate, HCPopBackGestureProxyDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) NSURLSessionDataTask *loadTask;
@property (nonatomic, copy) NSArray *projects;
@end

@implementation ProjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HCPopBackGestureProxy sharedInstance].viewController = self;

    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:navigationBar];

    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(navigationBar.frame), 0, CGRectGetHeight(self.tabBarController.tabBar.bounds), 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    __weak ProjectListViewController *weakSelf = self;
    [refreshControl bk_addEventHandler:^(UIRefreshControl *sender) {
        [weakSelf plvc_refresh:^(NSError *error) {
            [sender endRefreshing];
        }];
    }                 forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    tableViewController.refreshControl = refreshControl;
    [refreshControl beginRefreshing];
    [self plvc_refresh:^(NSError *error) {
        [refreshControl endRefreshing];
    }];

    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Prototype"];
    [navigationBar setItems:@[item]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[HCPopBackGestureProxy sharedInstance] viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.loadTask cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectListTableViewCell"];
    cell.project = self.projects[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *project = self.projects[indexPath.row];
    ProjectViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectViewController"];
    viewController.project = project;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Private

- (void)setProjects:(NSArray *)projects {
    if (_projects == projects) {
        return;
    }
    _projects = [projects copy];
    [self.tableView reloadData];
}

- (void)plvc_refresh:(void (^)(NSError *error))handler {
    [self.loadTask cancel];
    __weak ProjectListViewController *weakSelf = self;
    self.loadTask = [[APIClient sharedClient] GET:@"/projects/all"
                                       parameters:nil
                                          handler:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                                              if (!error) {
                                                  weakSelf.projects = responseObject;
                                              }
                                              handler(error);
                                          }];
}

@end
