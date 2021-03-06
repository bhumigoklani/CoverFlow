//
//  MIViewController.m
///  CoverFlow
//
//  Created by Mindinventory on 6/12/17.
//  Copyright © 2017 MindInventory. All rights reserved.



#import "MIViewController.h"
#import "PhotoCollectionViewCell.h"


#define CScreenWidth                        [UIScreen mainScreen].bounds.size.width
#define CScreenHeight                       [UIScreen mainScreen].bounds.size.height

@interface MIViewController ()
{
    NSMutableArray *arrImages;
}

@end

@implementation MIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self initialize];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark
#pragma mark - Genral Method

- (void)initialize
{
    self.title = @"Cover Flow";
    
    arrImages = [[NSMutableArray alloc] init];
    [self addItemInArray];
    
    //... Collection view registerNib
    
    [collCoverFlow registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    
    //... Set Custom Layout Flow of Collection view
    
    CustomFlowLayout *cLayout = [[CustomFlowLayout alloc] init];
    cLayout.delegate = self;
    [collCoverFlow setCollectionViewLayout:cLayout animated:NO];
}
// Add iteams
- (void)addItemInArray
{
    [arrImages addObjectsFromArray:@[@{@"image":@"1.jpg"},
                                     @{@"image":@"2.jpg"},
                                     @{@"image":@"3.jpg"},
                                     @{@"image":@"4.jpg"},
                                     @{@"image":@"5.jpg"}]];
}


#pragma mark
#pragma mark - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //... total image + 1 for Last cell is Tap to Reload
    return arrImages.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //... Propotional height and width of collection view cell according Device
    int size = CScreenWidth * 304 / 375;
    return CGSizeMake(size ,size);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PhotoCollectionViewCell";
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //... Configure cell
    
    cell.tag = indexPath.row;
    cell.imgLikeUnLike.hidden = true;
    if (indexPath.row == arrImages.count)
    {
        //... Tap to Reload
        cell.lblReload.hidden = NO;
        cell.imageView.hidden = YES;
    }
    else
    {
        //... Image cell
        cell.lblReload.hidden = YES;
        cell.imageView.hidden = NO;
        NSDictionary *dictData = arrImages[indexPath.row];
        //Use url for images then uncomment following line
        // cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dictData valueForKey:@"image"]]]];
        cell.imageView.image = [UIImage imageNamed:[dictData valueForKey:@"image"]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrImages.count == 0)
    {
        //... Last cell for Tap To Reload
        //... When arrImage count is 0
        [self addItemInArray];
        [collCoverFlow reloadData];
    }
}



#pragma mark
#pragma mark - Custom Flow layout Delegate

- (BOOL)shouldCellMoveUpForIndexPath:(NSIndexPath *)indexpath
{
    //... arrImage count greater than 0 return YES else return NO
    //... return YES that means Cell of indexpath is movable
    
    return arrImages.count != 0;
}

- (void)cellDidMovedUp:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
   
    //...Remove item from Array and Reload Collection view
    [arrImages removeObjectAtIndex:indexPath.row];
    [collCoverFlow reloadData];
}

-(void)cellDidMovedRight:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
     PhotoCollectionViewCell *cellPhoto = (PhotoCollectionViewCell *) [collCoverFlow cellForItemAtIndexPath:indexPath];
     cellPhoto.imgLikeUnLike.hidden = false;
     cellPhoto.imgLikeUnLike.image = [UIImage imageNamed:@"unlike"];
    
}

-(void)cellDidMovedLeft:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cellPhoto = (PhotoCollectionViewCell *) [collCoverFlow cellForItemAtIndexPath:indexPath];
    cellPhoto.imgLikeUnLike.image = [UIImage imageNamed:@"like"];
    cellPhoto.imgLikeUnLike.hidden = false;
}

-(void)cellDidNotMoved:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cellPhoto = (PhotoCollectionViewCell *) [collCoverFlow cellForItemAtIndexPath:indexPath];
    cellPhoto.imgLikeUnLike.hidden = true;
}

@end
