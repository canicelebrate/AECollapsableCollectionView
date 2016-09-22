//
//  AEViewController.m
//  AECollapsableCollectionViewDemo
//
//  Created by WangLin on 16/9/22.
//  Copyright © 2016年 AmberEase Co.,ltd. All rights reserved.
//

#import "AEViewController.h"
#import "AECollectionViewCell.h"
#import "AECollectionReusableView.h"
#import "AECollapsableCollectionView.h"

@interface AEViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet AECollapsableCollectionView *collectionView;

@end

@implementation AEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return CGSizeMake((screenBounds.size.width - 4*5.0)/3.0, 50);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.0f;
}



#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return 10;
    }
    else if(section == 1){
        return 15;
    }
    else{
        return 32;
    }
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AECollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AECollectionViewCell" forIndexPath:indexPath];
    [cell.lblContent setText:[NSString stringWithFormat:@"Item at %ld",(long)indexPath.row]];
    
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        AECollectionReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AECollectionReusableView" forIndexPath:indexPath];
        [header.btnPlus setTag:indexPath.section];
        [header.btnPlus addTarget:self action:@selector(onToggleSectionTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if([self.collectionView isExpandedSection:indexPath.section]){
            [header.btnPlus setImage:[UIImage  imageNamed:@"uparrow"] forState:UIControlStateNormal];
        }
        else{
            [header.btnPlus setImage:[UIImage  imageNamed:@"downarrow"] forState:UIControlStateNormal];
        }
    
        
        return header;
    }
    return nil;
}

#pragma mark - Event Handlers
-(void)onToggleSectionTapped:(UIButton*)btn{
    if([self.collectionView isExpandedSection:btn.tag]){
        [btn setImage:[UIImage  imageNamed:@"downarrow"] forState:UIControlStateNormal];
    }
    else{
        [btn setImage:[UIImage  imageNamed:@"uparrow"] forState:UIControlStateNormal];
    }
    
    [self.collectionView toggleCollapsableSection:btn.tag];
}

@end
