//
//  ListeReponsesView.m
//  Televoting
//
//  Created by Thomas Mac on 17/06/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ListeReponsesView.h"

#import "Reponse.h"

#import "SpecificTableViewCell.h"

@interface ListeReponsesView ()

@property(nonatomic, strong) NSMutableArray *arrayButton;

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic) int nombreBonnesReponses;

@property(nonatomic) int nombreFautes;

@property(nonatomic) int tempsRestant;

@property(nonatomic) BOOL reponseEffectuee;

@property(nonatomic, strong) NSMutableArray *tableauReponsesEffectuees;

@property(nonatomic, strong) NSMutableArray *tableauBonnesReponses;

@property(nonatomic, strong) UILabel *labelTempsRestant;

@property(nonatomic, strong) NSMutableArray *arrayElement;

@property(nonatomic, strong) NSMutableArray *arrayVerificationImage;

@property(nonatomic, strong) NSMutableArray *arrayChargementEffectue;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ListeReponsesView

- (int) getNombreReponses {
    return (int)self.reponses.count;
}

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Question"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des questions" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.hidesBackButton = YES;
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
    self.arrayElement = [[NSMutableArray alloc] init];
    self.arrayVerificationImage = [[NSMutableArray alloc] init];
    
    for (int i=0;i<self.reponses.count;i++)
    {
        Reponse *uneReponse = [self.reponses objectAtIndex:i];
        [self.arrayElement addObject:uneReponse.reponse];
        if (![uneReponse.image isEqualToString:@""])
        {
            [self.arrayElement addObject:uneReponse.image];
            [self.arrayVerificationImage addObject:[NSString stringWithFormat:@"%d",1]];
        }
        else
        {
            [self.arrayVerificationImage addObject:[NSString stringWithFormat:@"%d",0]];
        }
    }
}

- (void) actionListenerButton:(UIButton *)sender {
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    NSString* valeur = [sender currentTitle];
    if ([valeur isEqual: @""]) {
        [sender setTitle:@"X" forState:UIControlStateNormal];
    }
    else {
        [sender setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)boutonValiderActionListener {
    [self.timer invalidate];
    
    [self.activityIndicatorView startAnimating];
    
    [self bilan];
    
    self.listeQuestionsView.reponseEffectuee = YES;
    self.listeQuestionsView.bonnesReponses = self.tableauBonnesReponses;
    self.listeQuestionsView.reponsesEffectuees = self.tableauReponsesEffectuees;
    
    [self.activityIndicatorView stopAnimating];
    
    [self.labelTempsRestant setHidden:YES];
    
    [self.navigationController popToViewController:self.listeQuestionsView animated:YES];
}

- (void) bilan {
    int compteur = 0;
    for (int i=0; i<[self getNombreReponses]; i++) {
        Reponse* uneReponse = self.reponses[i];
        if ([[[self.arrayButton objectAtIndex:i] currentTitle] isEqual:@"X"]) {
            compteur++;
            if (uneReponse.reponse_correcte) {
                self.nombreBonnesReponses++;
            }
            else {
                self.nombreFautes++;
            }
        }
        else {
            if (uneReponse.reponse_correcte) {
                self.nombreFautes++;
            }
        }
    }
    [self definitionTableauReponsesEffectuees:compteur];
    [self definitionTableauBonnesReponses];
}

- (void) definitionTableauReponsesEffectuees:(int)nombreReponsesEffectuees {
    self.tableauReponsesEffectuees = [NSMutableArray array];
    [self.tableauReponsesEffectuees addObject:[NSNumber numberWithInt:self.questionChoisie.question_id]];
    [self.tableauReponsesEffectuees addObject:[NSNumber numberWithInt:self.nombreFautes]];
    [self.tableauReponsesEffectuees addObject:[NSNumber numberWithInt:self.nombreBonnesReponses]];
    [self.tableauReponsesEffectuees addObject:[NSNumber numberWithInt:nombreReponsesEffectuees]];
    for (int i=0; i<[self getNombreReponses]; i++) {
        Reponse* uneReponse = self.reponses[i];
        if ([[[self.arrayButton objectAtIndex:i] currentTitle] isEqual:@"X"]) {
            [self.tableauReponsesEffectuees addObject:[NSNumber numberWithInt:uneReponse.reponse_id]];
        }
    }
}

- (void) definitionTableauBonnesReponses {
    if (!self.questionnaireChoisi.mode_examen) {
        self.tableauBonnesReponses = [NSMutableArray array];
        for (int i=0; i<[self getNombreReponses]; i++) {
            Reponse* uneReponse = self.reponses[i];
            if (uneReponse.reponse_correcte) {
                [self.tableauBonnesReponses addObject:uneReponse.reponse];
            }
        }
    }
}

- (void) ecoulementTemps {
    self.tempsRestant--;
    [self.labelTempsRestant setText:[NSString stringWithFormat:@"Temps restants : %d secondes",self.tempsRestant]];
    if (self.tempsRestant == 0) {
        [self.timer invalidate];
        
        [self.activityIndicatorView startAnimating];
        
        [self bilan];
        
        self.listeQuestionsView.reponseEffectuee = YES;
        self.listeQuestionsView.bonnesReponses = self.tableauBonnesReponses;
        self.listeQuestionsView.reponsesEffectuees = self.tableauReponsesEffectuees;
        
        [self.activityIndicatorView stopAnimating];
        
        [self.labelTempsRestant setHidden:YES];
        
        [self.navigationController popToViewController:self.listeQuestionsView animated:YES];
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
    
    self.nombreBonnesReponses = 0;
    self.nombreFautes = 0;
    
    self.arrayButton = [[NSMutableArray alloc] init];
    
    self.arrayChargementEffectue = [[NSMutableArray alloc] init];
    
    self.arrayChargementEffectue[0] = [NSString stringWithFormat:@"%d", 0];
    
    for (int i=0;i<self.arrayElement.count;i++)
    {
        self.arrayChargementEffectue[i + 1] = [NSString stringWithFormat:@"%d", 0];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonTitle = [[UIBarButtonItem alloc] initWithTitle:@"Valider"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(boutonValiderActionListener)];
    
    [buttonTitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonTitle, flexibleSpace ]];
    
    if (self.questionChoisie.temps_imparti != 0)
    {
        self.tempsRestant = self.questionChoisie.temps_imparti;
        
        self.labelTempsRestant = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, self.view.frame.size.width / 4, self.navigationController.toolbar.frame.size.height)];
    
        [self.labelTempsRestant setTextColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        
        [self.labelTempsRestant setBackgroundColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
        
        [self.labelTempsRestant setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0]];
        
        [self.labelTempsRestant setTextAlignment:NSTextAlignmentCenter];
    
        [self.labelTempsRestant setText:[NSString stringWithFormat:@"Temps restant : %d secondes", self.tempsRestant]];
    
        [self.navigationController.toolbar addSubview:self.labelTempsRestant];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ecoulementTemps) userInfo:nil repeats:YES];
    }
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrayElement.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecificTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0)
    {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3, cell.frame.size.height - 10.0f)];
        
        [textView setText:self.questionChoisie.question];
        [textView setTextColor:[UIColor blackColor]];
        [textView setFont:[UIFont fontWithName:textView.font.fontName size:20.0]];
        [textView setEditable:NO];
        
        [cell addSubview:textView];
        
        [cell.imageView setImage:[UIImage imageNamed:@"iconQuestion.png"]];
        
        self.arrayChargementEffectue[indexPath.row] = [NSString stringWithFormat:@"%d", 1];
        
        return cell;
    }
    
    if ([self.arrayChargementEffectue[indexPath.row] intValue] == 0)
    {
        
        if (indexPath.row < self.arrayVerificationImage.count && [[self.arrayVerificationImage objectAtIndex:indexPath.row] intValue] == 1)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100.0f) / 2, 5.0f, 100.0f, 100.0f)];
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[@"http://isic.mines-douai.fr/televoting/" stringByAppendingString:[self.arrayElement objectAtIndex:indexPath.row - 1]]]];
            
            [imageView setImage:[UIImage imageWithData:imageData]];
            
            [cell addSubview:imageView];
        }
        
        else
        {
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3 - 50, cell.frame.size.height - 10.0f)];
            
            [textView setText:[self.arrayElement objectAtIndex:indexPath.row - 1]];
            [textView setTextColor:[UIColor blackColor]];
            [textView setFont:[UIFont fontWithName:textView.font.fontName size:20.0]];
            [textView setEditable:NO];
            
            [cell addSubview:textView];
            
            [cell.imageView setImage:[UIImage imageNamed:@"iconReponse.png"]];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            [button addTarget:self action:@selector(actionListenerButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [[button titleLabel] setFont:[UIFont fontWithName:@"Arial-Gras" size:35]];
            [[button titleLabel] setFont:[UIFont systemFontOfSize:35]];
            
            [button setTitle:@"" forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [button setBackgroundImage:[UIImage imageNamed:@"fondBouton.png"] forState:UIControlStateNormal];
            
            button.frame = CGRectMake(self.view.frame.size.width - 50, 5.0f, self.navigationController.navigationBar.frame.size.height - 10.0f, self.navigationController.navigationBar.frame.size.height - 10.0f);
            
            [cell addSubview:button];
            [self.arrayButton addObject:button];
        }
        
        self.arrayChargementEffectue[indexPath.row] = [NSString stringWithFormat:@"%d", 1];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 100.0f;
    }
    
    if (indexPath.row < self.arrayVerificationImage.count && [[self.arrayVerificationImage objectAtIndex:indexPath.row] intValue] == 1)
    {
        return 110.0f;
    }
    
    return self.navigationController.navigationBar.frame.size.height;
}

@end
