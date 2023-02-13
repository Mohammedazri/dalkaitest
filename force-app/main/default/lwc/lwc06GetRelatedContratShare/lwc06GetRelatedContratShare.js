import { LightningElement,api,wire,track } from 'lwc';
import getTotalContratShare from '@salesforce/apex/lwc06GetRelatedContratShare_Controller.getTotalContratShare';
import getRelatedContratShareR from '@salesforce/apex/lwc06GetRelatedContratShare_Controller.getRelatedContratSharerefresh';

import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';


export default class Lwc06GetRelatedContratShare extends NavigationMixin(LightningElement) {
@api recordId;
page = 1;
cancreate;
relatedContratShare = [];
pageSize = 6; 
totalRecountCount = 0;
showCount = 0;
totalPage = 0;
sortedBy ;
sortedDirection;
error;
isFirstPage = true;
isLastPage = false;
res;
@track isLoading = true;


@wire(getTotalContratShare, { recordId: '$recordId'})
checkTotal(result){
    this.res = result;
    if (result.data) {
        if(result.data >0){
            this.totalRecountCount = result.data; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            this.getData(this.page);
            if(this.totalRecountCount>this.pageSize){
                this.showCount = this.pageSize+"+";
            }
            else{
                this.showCount = this.totalRecountCount;

            }
            this.isLoading = false;
        }else{
            this.showTable = false;
        }

    } else if (result.error) {
        this.error = result.error;
        this.relatedContratShare = undefined;
        console.log(this.error);
    }

}
refreshComponent(event){
    this.isLoading = true;
    refreshApex(this.res);
    this.page = 1;
getRelatedContratShareR({recordId: this.recordId,pageSize: this.pageSize,page: 1})
        .then((result)=>{
            this.relatedContratShare = [];
            this.cancreate = result[0].cancreate;
            this.error = undefined;

               //if we don't have another page we disable both buttons
        if(this.totalPage == 1){
            this.isFirstPage = true;
            this.isLastPage = true;
        }else if(this.page == 1){
            this.isFirstPage = true;
            this.isLastPage = false;
        }else if(this.page == this.totalPage){
            this.isFirstPage = false;
            this.isLastPage = true;
        }else{
            this.isFirstPage = false;
            this.isLastPage = false;
        }
        
        }).catch((error) => {
            this.error = error;
            this.relatedContratShare = undefined;
        })
        this.isLoading = false;
}

 getData(page) {
    getRelatedContratShareR({recordId: this.recordId,pageSize: this.pageSize,page: page})
        .then((result)=>{
            this.relatedContratShare = result;
            this.cancreate = result[0].cancreate;
            this.error = undefined;


               //if we don't have another page we disable both buttons
        if(this.totalPage == 1){
            this.isFirstPage = true;
            this.isLastPage = true;
        }else if(this.page == 1){
            this.isFirstPage = true;
            this.isLastPage = false;
        }else if(this.page == this.totalPage){
            this.isFirstPage = false;
            this.isLastPage = true;
        }else{
            this.isFirstPage = false;
            this.isLastPage = false;
        }
        

        }).catch((error) => {
            this.error = error;
            this.relatedContratShare = undefined;
            
        })
    }


    //clicking on previous button this method will be called
    previousHandler() {
        if (this.page > 1) {
            this.isLoading = true;
            this.page = this.page - 1; //decrease page by 1
            this.getData(this.page);
            this.isLoading = false;
        }
    }

    //clicking on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.isLoading = true;
            this.page = this.page + 1; //increase page by 1
            this.getData(this.page);  
            this.isLoading = false;          
        }
    }

}