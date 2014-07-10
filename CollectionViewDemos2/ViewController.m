//
//  ViewController.m
//  CollectionViewDemos2
//
//  Created by Tim Heuer on 7/7/14.
//  Copyright (c) 2014 Tim Heuer. All rights reserved.
//

#import "ViewController.h"
#import "DefaultCell.h"
#import "SectionHeader.h"
#import "DifferentCell.h"

#define RND_FROM_TO(min,max) (min + arc4random_uniform(max - min + 1))
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface ViewController () {
    NSArray *alphaLetters;
    NSMutableArray *twoLetterWords, *threeLetterWords, *fourLetterWords;
}

@end

@implementation ViewController

-(void)scrollTextViewToBottom:(UITextView *)textView {
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadDataSource];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refresh];
    self.collectionView.alwaysBounceVertical = YES;
}
- (void)refresh:(id)sender {
    [self logData:@"Refreshing"];
    [self reloadDataSource];
    [self.collectionView reloadData];
    [(UIRefreshControl *) sender endRefreshing];
}

- (void)reloadDataSource {
    self.logOutput.text = @"";
    
    // Do any additional setup after loading the view, typically from a nib.
    alphaLetters = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    
    twoLetterWords = [[NSMutableArray alloc]init];
    threeLetterWords = [[NSMutableArray alloc]init];
    fourLetterWords = [[NSMutableArray alloc]init];
    
    // two letter words
    for (NSUInteger i = 0; i < RND_FROM_TO(150,1000); i++) {
        [twoLetterWords addObject:[NSString stringWithFormat:@"%@%@", alphaLetters[arc4random_uniform(26)], alphaLetters[arc4random_uniform(26)]]];
    }
    
    // three letter words
    for (NSUInteger i = 0; i < RND_FROM_TO(150,1000); i++) {
        [threeLetterWords addObject:[NSString stringWithFormat:@"%@%@%@", alphaLetters[arc4random_uniform(26)], alphaLetters[arc4random_uniform(26)], alphaLetters[arc4random_uniform(26)]]];
    }
    
    // four letter words
    for (NSUInteger i = 0; i < RND_FROM_TO(150, 1000); i++) {
        [fourLetterWords addObject:[NSString stringWithFormat:@"%@%@%@%@", alphaLetters[arc4random_uniform(26)], alphaLetters[arc4random_uniform(26)], alphaLetters[arc4random_uniform(26)], alphaLetters[arc4random_uniform(26)]]];
    }
    
    NSString *string = [self.logOutput.text stringByAppendingString:[NSString stringWithFormat:@"Total Items: %i \r", threeLetterWords.count + twoLetterWords.count + fourLetterWords.count]];
    [self logData:string];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog([NSString stringWithFormat:@"sizeForItemAtIndexPath called on item %li in section %li", (long)indexPath.item, (long)indexPath.section]);
    
    NSString *string = [self.logOutput.text stringByAppendingString:[NSString stringWithFormat:@"sizeForItem called on item %li in section %li \r", (long)indexPath.item, (long)indexPath.section]];
    
    [self logData:string];
    
    if (indexPath.section == 2) {
        NSString *word = fourLetterWords[indexPath.row];
        
        // check to see if it starts with a "C"
        if ([word hasPrefix:@"c"]) {
            return CGSizeMake(50.f, 75.f);
        }
        return CGSizeMake(150.f, 75.f);
        
    } else {
        if (indexPath.section == 1) {
            NSString *word = threeLetterWords[indexPath.row];
            
            // check to see if it starts with a "C"
            if ([word hasPrefix:@"c"]) {
                return CGSizeMake(200.f, 50.f);
            }
        }
        
        if (indexPath.section == 1) {
            NSString *word = threeLetterWords[indexPath.row];
            
            if ([word hasSuffix:@"b"]) {
                return CGSizeMake(20.f, 100.f);
            }
        }
        return CGSizeMake(100.f, 100.f);
    }
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    long result = 0;
    switch (section) {
        case 0:
            result = twoLetterWords.count;
            break;
        case 1:
            result = threeLetterWords.count;
            break;
        case 2:
            result = fourLetterWords.count;
            break;
        default:
            result = 0;
            break;
    }
    return result;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    SectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
    
    NSString *string = [self.logOutput.text stringByAppendingString:[NSString stringWithFormat:@"dequeHeader Section %ld \r", (long)indexPath.section]];
    
    [self logData:string];
    
    switch (indexPath.section) {
        case 0:
            header.sectionTitle.text = @"Two Letter Words";
            break;
        case 1:
            header.sectionTitle.text = @"Three Letter Words";
            break;
        case 2:
            header.sectionTitle.text = @"Four Letter Words";
        default:
            break;
    }
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Item %li in section %li selected", (long)indexPath.item, (long)indexPath.section);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor purpleColor];
    
    NSString *string = [self.logOutput.text stringByAppendingString:[NSString stringWithFormat:@"didSelectItem called on item %li in section %li \r", (long)indexPath.item, (long)indexPath.section]];
    
    [self logData:string];
}

- (void)logData:(NSString *)logString {
    //self.logOutput.text = logString;
    //[self scrollTextViewToBottom:self.logOutput];
    NSLog(logString);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *string = [self.logOutput.text stringByAppendingString:[NSString stringWithFormat:@"cellForItem called on item %li in section %li \r", (long)indexPath.item, (long)indexPath.section]];
    
    [self logData:string];
    
    if (indexPath.section == 2) {
        
        NSString *word = fourLetterWords[indexPath.row];
        if ([word hasPrefix:@"c"]) {
            DefaultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultCell" forIndexPath:indexPath];
            cell.cellTitle.text = word;
            return cell;
        } else {
            DifferentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"differentCell" forIndexPath:indexPath];
            cell.cellTitle.text = fourLetterWords[indexPath.row];
            return cell;
        }
    } else {
        
        DefaultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultCell" forIndexPath:indexPath];
        cell.cellTitle.textColor = [UIColor blackColor];
    
    
        NSString *word;
        switch (indexPath.section) {
            case 0:
                word = twoLetterWords[indexPath.row];
                cell.backgroundColor = Rgb2UIColor(RND_FROM_TO(0, 255), RND_FROM_TO(0, 255), RND_FROM_TO(0, 255));
                break;
            case 1:
                word = threeLetterWords[indexPath.row];
                cell.backgroundColor = [UIColor blueColor];
                cell.cellTitle.textColor = [UIColor whiteColor];
                break;
//            case 2:
//                word = fourLetterWords[indexPath.row];
//                cell.backgroundColor = [UIColor greenColor];
//                break;
            default:
                word = @"error!";
                break;
        }
    
        cell.cellTitle.text = word;
        return cell;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
