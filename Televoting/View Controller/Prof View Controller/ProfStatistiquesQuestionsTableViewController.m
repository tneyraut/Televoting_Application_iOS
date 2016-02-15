//
//  ProfStatistiquesQuestionsTableViewController.m
//  Televoting
//
//  Created by Thomas Mac on 10/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ProfStatistiquesQuestionsTableViewController.h"

#import "SpecificTableViewCell.h"

@interface ProfStatistiquesQuestionsTableViewController ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSArray *statistiquesQuestionsArray;

@property(nonatomic, strong) NSArray *titleCellArray;

@property(nonatomic, strong) StatistiquesModel *_statistiquesModel;

@end

@implementation ProfStatistiquesQuestionsTableViewController

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Statistiques des questions"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Statistiques des questions" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) downloadStatistiquesQuestions:(int)questionnaire_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._statistiquesModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.statistiquesQuestionsArray = [[NSArray alloc] init];
        
        self._statistiquesModel = [[StatistiquesModel alloc] init];
        self._statistiquesModel.delegate = self;
    }
    
    [self._statistiquesModel getStatistiquesQuestionsByQuestionnaire:questionnaire_id];
}

- (void) statistiquesDownloaded:(NSArray *)items
{
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucune question enregistrée pour ce questionnaire." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    
    self.statistiquesQuestionsArray = items;
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    self.titleCellArray = [[NSArray alloc] initWithObjects:@"Nombre de bonnes réponses : ", @"Pourcentage de bonnes réponses : ", @"Nombre de mauvaises réponses : ", @"Nombre de réponses vide : ", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self downloadStatistiquesQuestions:self.questionnaireSelected.questionnaire_id];
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.statistiquesQuestionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.titleCellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = [self.statistiquesQuestionsArray objectAtIndex:section];
    
    return [array objectAtIndex:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSArray *array = [self.statistiquesQuestionsArray objectAtIndex:indexPath.section];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setText:[[self.titleCellArray objectAtIndex:indexPath.row] stringByAppendingString:[array objectAtIndex:indexPath.row + 1]]];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    NSString *imageName = @"";
    
    if (indexPath.row == 0)
    {
        imageName = @"iconBonneReponse.png";
    }
    else if (indexPath.row == 1)
    {
        imageName = @"iconPourcentageBonneReponse.png";
    }
    else if (indexPath.row == 2)
    {
        imageName = @"iconMauvaiseReponse.png";
    }
    else if (indexPath.row == 3)
    {
        imageName = @"iconPourcentage.png";
    }
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    
    return cell;
}

@end
