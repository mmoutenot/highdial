#import <ReactiveCocoa/ReactiveCocoa.h>

#import "HDRootViewController.h"
#import "HDCallFlowViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"

@interface HDRootViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating>

@property (nonatomic) UITableViewController* filteredContactsTableController;
@property (nonatomic) NSMutableArray* filteredContacts;
@property (nonatomic) NSMutableArray* contacts;

@property (nonatomic) UISearchDisplayController* searchController;
@property (nonatomic) UISearchBar* searchBar;

@property (nonatomic) NSString* callingState;
@property (nonatomic) NSDate* callStartTime;

@end

@implementation HDRootViewController

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Contacts";
  self.callingState = @"inactive";
  
  self.filteredContactsTableController = [[UITableViewController alloc] init];
  self.filteredContactsTableController.tableView.delegate = self;
  self.filteredContactsTableController.tableView.dataSource = self;
  
  self.searchController = [[UISearchDisplayController alloc] init];
  self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
  self.searchBar.delegate = self;
  
  self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
  self.searchController.delegate = self;
  self.searchController.searchResultsDataSource = self;
  self.tableView.tableHeaderView = self.searchBar;
  
  self.definesPresentationContext = YES;
  self.contacts = [[NSMutableArray alloc] init];
  self.filteredContacts = [NSMutableArray array];
  
  NSArray* types = @[@"Lead", @"Contact"];
  for (NSString* type in types) {
    NSString* query = [NSString stringWithFormat:@"SELECT Id, Name, MobilePhone FROM %@", type];
    SFRestRequest* request = [[SFRestAPI sharedInstance] requestForQuery:query];
    [[SFRestAPI sharedInstance] send:request delegate:self];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
  [searchBar resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController*)searchController {
  [self filterContentForSearchText:searchController.searchBar.text scope:nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString *)searchString {
  // Tells the table data source to reload when text changes
  [self filterContentForSearchText:searchString scope: [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
  // Return YES to cause the search result table view to be reloaded.
  return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
  // Tells the table data source to reload when scope bar selection changes
  [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
   [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
  // Return YES to cause the search result table view to be reloaded.
  return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
  [self.filteredContacts removeAllObjects];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.Name contains[c] %@", searchText];
  self.filteredContacts = [NSMutableArray arrayWithArray:[self.contacts filteredArrayUsingPredicate:predicate]];
  NSLog(@"%lu", (unsigned long)self.filteredContacts.count);
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest*)request didLoadResponse:(id)jsonResponse {
  NSArray* records = [jsonResponse objectForKey:@"records"];
  NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
  [self.contacts addObjectsFromArray:records];
  self.contacts = [[self.contacts sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* contactA, NSDictionary* contactB) {
    NSString* nameA = contactA[@"Name"];
    NSString* nameB = contactB[@"Name"];
    return [nameA compare:nameB];
  }] mutableCopy];
  [self.filteredContacts addObjectsFromArray:self.contacts];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
  NSLog(@"request:didFailLoadWithError: %@", error);
  //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest*)request {
  NSLog(@"requestDidCancelLoad: %@", request);
  //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest*)request {
  NSLog(@"requestDidTimeout: %@", request);
  //add your failed error handling here
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.searchController.isActive) {
    return [self.filteredContacts count];
  } else {
    return [self.contacts count];
  }
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView*)tableView_ cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  static NSString* CellIdentifier = @"CellIdentifier";
  
  // Dequeue or create a cell of the appropriate type.
  UITableViewCell* cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
  }
  
  NSDictionary* obj;
  if (self.searchController.isActive) {
    obj = [self.filteredContacts objectAtIndex:indexPath.row];
  } else {
    obj = [self.contacts objectAtIndex:indexPath.row];
  }
  
  //if you want to add an image to your cell, here's how
  UIImage* image = [UIImage imageNamed:@"icon.png"];
  cell.imageView.image = image;
  
  cell.textLabel.text =  [obj objectForKey:@"Name"];
  
  //this adds the arrow to the right hand side.
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
  
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
//  NSCharacterSet* illegalCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890*#"] invertedSet];
//  NSString* phoneNumber = [[self.contacts.allObjects[indexPath.item][@"MobilePhone"] componentsSeparatedByCharactersInSet:illegalCharSet] componentsJoinedByString:@""];
  
  NSString* phoneNumber = @"6158296774";
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", phoneNumber]]];
  self.callingState = @"willPromptCall";
}

#pragma mark - Calling state

- (void)setCallingState:(NSString *)callingState {
  _callingState = callingState;
  NSLog(@"%@", callingState);
}

- (void)resetCallingState {
  self.callingState = @"inactive";
}


- (void)viewWillDisappear:(BOOL)animated {
  NSLog(@"BACKGROUND BACKGROUND BACKGROUND");
  if ([self.callingState isEqualToString:@"willPromptCall"]){
    self.callingState = @"didPromptCall";
  } else if ([self.callingState isEqualToString:@"didPromptCall"]) {
  } else if ([self.callingState isEqualToString:@"promptCallComplete"]) {
    self.callingState = @"didCall";
    self.callStartTime = [NSDate date];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  NSLog(@"FOREGROUND FOREGROUND FOREGROUND");
  if ([self.callingState isEqualToString:@"didPromptCall"]) {
    self.callingState = @"promptCallComplete";
  } else if ([self.callingState isEqualToString:@"didCall"]) {
    NSInteger duration = -[self.callStartTime timeIntervalSinceNow];
    NSString* durationString = [NSString stringWithFormat:@"%is", duration];
    
    NSIndexPath* selectedIndexPath = self.tableView.indexPathForSelectedRow;
    NSDictionary* selectedContact = [self.contacts objectAtIndex:selectedIndexPath.item];
    HDCallFlowViewController* callFlowViewController = [[HDCallFlowViewController alloc] initWithCallData:@{ @"duration": @(duration), @"durationString": durationString, @"contact": selectedContact }];
    [self presentViewController:callFlowViewController animated:NO completion:^{
      [self performSelector:@selector(resetCallingState) withObject:nil afterDelay:0];
    }];
  }
}

@end
