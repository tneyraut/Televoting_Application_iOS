//
//  ResultatQuestionnaireTableViewController.m
//  Televoting
//
//  Created by Thomas Mac on 30/06/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ResultatQuestionnaireTableViewController.h"

#import "SpecificTableViewCell.h"

@interface ResultatQuestionnaireTableViewController ()

@property(nonatomic, strong) ResultatModel *_resultatModel;
@property(nonatomic, strong) NSArray *resultatsArray;

@property(nonatomic, strong) NSArray *titlesArray;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ResultatQuestionnaireTableViewController

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Résultats"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Résultats" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) recuperationResultats
{
    if (!self._resultatModel)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.resultatsArray = [[NSArray alloc] init];
        
        self._resultatModel = [[ResultatModel alloc] init];
        self._resultatModel.delegate = self;
    }
    [self._resultatModel getResultatsByUser:self.user_id questionnaire_id:self.questionnaire_id];
}

- (void) getResultatsDownloaded:(NSArray*) items
{
    [self.activityIndicatorView stopAnimating];
    
    self.resultatsArray = items;
    
    [self.tableView reloadData];
    
    if (self.resultatsArray.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucune donnée disponible..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) setImageCell:(UITableViewCell*)cell indice:(int)indice
{
    NSString *imageName = @"";
    
    if (indice == 0)
    {
        imageName = @"iconCours";
    }
    else if (indice == 1)
    {
        imageName = @"iconQuestionnaire";
    }
    else if (indice == 2)
    {
        imageName = @"iconNote";
    }
    else if (indice == 3)
    {
        imageName = @"iconBonneReponse";
    }
    else if (indice == 4)
    {
        imageName = @"iconMauvaiseReponse";
    }
    else if (indice == 5)
    {
        imageName = @"iconMoyenne";
    }
    else if (indice == 6)
    {
        imageName = @"iconMeilleureNote";
    }
    else if (indice == 7)
    {
        imageName = @"iconMauvaiseReponse";
    }
    else if (indice == 8)
    {
        imageName = @"iconBonneReponse";
    }
    else if (indice == 9)
    {
        imageName = @"iconMauvaiseReponse";
    }
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
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
    
    self.titlesArray = [[NSArray alloc] initWithObjects:@"", @"", @"Note : ", @"Nombre de bonnes réponses : ", @"Nombre de fautes : ", @"Moyenne au questionnaire : ", @"Note maximale obtenue : ", @"Note minimale obtenue : ", @"Nombre moyen de bonnes réponses : ", @"Nombre moyen de fautes : ", nil];
    
    [self.activityIndicatorView startAnimating];
    
    [self recuperationResultats];
    
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
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.resultatsArray.count - 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setText:[self.titlesArray[indexPath.row] stringByAppendingString:self.resultatsArray[indexPath.row]]];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    [self setImageCell:cell indice:(int)indexPath.row];
    
    return cell;
}

@end
