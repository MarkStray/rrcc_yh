//
//  ProductCell.m
//  rrcc_yh
//
//  Created by user on 15/9/20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "ProductCell.h"

@interface ProductCell () 

@end

@implementation ProductCell


- (void)awakeFromNib {
    // 鲜店字体没有改
    
    self.brandLbl.font = Font(14);
    self.titleLbl.font = Font(14);
    self.weightLbl.font = Font(12);
    self.saleLbl.font = Font(12);
    self.salePriceLbl.font = Font(14);
    self.oldPriceLbl.font = Font(12);
    
    self.CalcView.delegate = self;
    self.oldPriceLbl.isWithStrikeThrough = YES;//划线
    [self.brandLbl SetBorderWithcornerRadius:5.f BorderWith:1.f AndBorderColor:GLOBAL_COLOR];
    
    
}

- (void)updateUIUsingModel:(ProductsModel *)model {
    
    self.model = model;
    self.CalcView.count = model.count;// need
    
    self.onsaleImg.hidden = model.onsale.integerValue==1?NO:YES;
    
    sd_image_url(self.logoImgView, model.imgurl);
    
    self.titleLbl.text = model.skuname;
    
    self.weightLbl.text = model.spec;

    self.saleLbl.text = [NSString stringWithFormat:@"已售%@份",model.avgnum];

    //隐藏 已售份数
    self.saleLbl.hidden = YES;
    
    if (model.onsale.integerValue == 0) {
        self.salePriceLbl.text = [NSString stringWithFormat:@"￥%@",model.price];

        self.oldPriceLbl.hidden = YES;
        
    } else {
        self.salePriceLbl.text = [NSString stringWithFormat:@"￥%@",model.saleprice];
        
        self.oldPriceLbl.hidden = NO;
        self.oldPriceLbl.text = [NSString stringWithFormat:@"￥%@",model.price];
    }

}

- (void)CalculatorViewDidClickAddButton:(CalculatorView *)aView {
    if (self.model.onsale.intValue == 1) {
        if (self.CalcView.count == self.model.saleamount.intValue) {
            NSString *msg = [NSString stringWithFormat:@"亲,本促销品每单限购%d份!",self.model.saleamount.intValue];
            show_alertView(msg);
            return ;
        } else {
            self.model.count ++;
        }
    } else {
        if (self.CalcView.count == 99) {
            NSString *msg = [NSString stringWithFormat:@"亲!本商品每单最多只能购买99份!"];
            show_alertView(msg);
            return ;
            
        } else {
            self.model.count ++;
        }
    }
    if (self.purchaseBlockCB) {
        if (self.purchaseBlockCB(self.model)) {
            self.CalcView.count = self.model.count;
        } else {
            self.model.count --;
            self.CalcView.count = self.model.count;
        }
    }
}

- (void)CalculatorViewDidClickReduceButton:(CalculatorView *)aView {
    self.model.count --;
    if (self.purchaseBlockCB) {
        if (self.purchaseBlockCB(self.model)) {
            self.CalcView.count = self.model.count;
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
