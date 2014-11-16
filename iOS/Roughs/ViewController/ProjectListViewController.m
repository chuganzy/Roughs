//
//  ProjectListViewController.m
//  Roughs
//
//  Created by Takeru Chuganji on 11/16/14.
//  Copyright (c) 2014 Takeru Chuganji. All rights reserved.
//

#import "ProjectListViewController.h"
#import "UIControl+BlocksKit.h"
#import "APIClient.h"
#import "ProjectListTableViewCell.h"
#import "ProjectViewController.h"

@interface ProjectListViewController ()
@property (nonatomic, weak) NSURLSessionDataTask *loadTask;
@property (nonatomic, copy) NSArray *projects;
@end

@implementation ProjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    __weak ProjectListViewController *weakSelf = self;
    [refreshControl bk_addEventHandler:^(id sender) {
        [weakSelf plvc_refresh:^(NSError *error) {
            [weakSelf.refreshControl endRefreshing];
        }];
    }                 forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [refreshControl beginRefreshing];
    [self plvc_refresh:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
