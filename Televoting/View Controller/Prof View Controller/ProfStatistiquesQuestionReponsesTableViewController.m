//
//  ProfStatistiquesQuestionReponsesTableViewController.m
//  Televoting
//
//  Created by Thomas Mac on 10/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ProfStatistiquesQuestionReponsesTableViewController.h"

#import "SpecificTableViewCell.h"

@interface ProfStatistiquesQuestionReponsesTableViewController ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSArray *titleCellArray;

@property(nonatomic, strong) NSMutableArray *statistiquesQuestionReponsesArray;

@property(nonatomic, strong) StatistiquesModel *_statistiquesModel;

@property(nonatomic) BOOL downloadStatistiquesQuestion;

@end

@implementation ProfStatistiquesQuestionReponsesTableViewController

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Statistiques de la question"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Statistiques de la question" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) downloadStatistiquesQuestion:(int)question_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._statistiquesModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.statistiquesQuestionReponsesArray = [[NSMutableArray alloc] init];
        
        self._statistiquesModel = [[StatistiquesModel alloc] init];
        self._statistiquesModel.delegate = self;
    }
    
    self.downloadStatistiquesQuestion = YES;
    
    [self._statistiquesModel getStatistiquesByQuestion:question_id];
}

- (void) downloadStatistiquesReponses:(int)question_id questionnaire_id:(int)questionnaire_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._statistiquesModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.statistiquesQuestionReponsesArray = [[NSMutableArray alloc] init];
        
        self._statistiquesModel = [[StatistiquesModel alloc] init];
        self._statistiquesModel.delegate = self;
    }
    
    self.downloadStatistiquesQuestion = NO;
    
    [self._statistiquesModel getStatistiquesReponsesByQuestion:question_id questionnaire_id:questionnaire_id];
}

- (void) statistiquesDownloaded:(NSArray *)items
{
    if (self.downloadStatistiquesQuestion)
    {
        if (items.count == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Une erreur est survenue durant le chargement des données. Si le problème persiste, veuillez contacter l'administrateur." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
        
        [self.statistiquesQuestionReponsesArray addObject:items];
        
        [self downloadStatistiquesReponses:self.questionSelected.question_id questionnaire_id:self.questionnaireSelected.questionnaire_id];
    }
    else
    {
        if (items.count == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucun participant n'a pour le moment répondu à cette question." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
        
        for (int i=0;i<items.count;i++)
        {
            [self.statistiquesQuestionReponsesArray addObject:[items objectAtIndex:i]];
        }
        
        [self.tableView reloadData];
        
        [self.activityIndicatorView stopAnimating];
    }
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
    
    self.titleCellArray = [[NSArray alloc] initWithObjects:@"Nombre de bonnes réponses : ", @"Pourcentage de bonnes réponses : ", @"Nombre de fautes : ", @"Nombre de réponses vides : ", nil];
    
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
    
    [self downloadStatistiquesQuestion:self.questionSelected.question_id];
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.statistiquesQuestionReponsesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)
    {
        return self.titleCellArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = [self.statistiquesQuestionReponsesArray objectAtIndex:section];
    
    return [array objectAtIndex:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSArray *array = [self.statistiquesQuestionReponsesArray objectAtIndex:indexPath.section];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *imageName = @"";
    
    if (indexPath.section == 0)
    {
        [cell.textLabel setText:[[self.titleCellArray objectAtIndex:indexPath.row] stringByAppendingString:[array objectAtIndex:indexPath.row + 1]]];
        
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
    }
    else
    {
        [cell.textLabel setText:[@"Nombre de choix (en %) : " stringByAppendingString:[array objectAtIndex:indexPath.row + 1]]];
        
        imageName = @"iconPourcentage.png";
    }
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    
    return cell;
}

@end
