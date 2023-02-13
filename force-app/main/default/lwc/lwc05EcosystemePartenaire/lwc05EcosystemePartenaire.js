import { LightningElement,api,wire } from 'lwc';
import getRelatedEcosysteme from '@salesforce/apex/lwc05EcosystemePartenaire_Controller.getRelatedEcosysteme';
import getTotalEcosysteme from '@salesforce/apex/lwc05EcosystemePartenaire_Controller.getTotalEcosysteme';

// Import custom labels
import lwc05_Header from '@salesforce/label/c.lwc05_Header';
import lwc05_MessageNoRecords from '@salesforce/label/c.lwc05_MessageNoRecords';

const columns = [
    //{ label: 'Partenaire lié', fieldName: 'PartenaireURL',type: 'url', initialWidth: 130,sortable: true, typeAttributes: { label:{fieldName:'PartenaireLieName'},target:'_blank' } },
    { label: 'Type de relation', fieldName: 'TypeRelation', type: 'text',sortable: true },
    { label: 'Contrat  ', fieldName: 'ContratURL',type: 'url', sortable: true, typeAttributes: { label:{fieldName:'ContratName'},tooltip: { fieldName: 'ContratName' },target: '_blank' } },
    { label: 'CA en cours du contrat', fieldName: 'ContratCAEnCours', type: 'currency',initialWidth: 120,sortable: true, typeAttributes: { currencyCode: "EUR" }},
    { label: 'Opportunité ', fieldName: 'OpportunityURL',type: 'url', sortable: true, typeAttributes: { label:{fieldName:'OppName'},tooltip: { fieldName: 'OppName' },target:'_blank' } },
    { label: 'CA Offre ', fieldName: 'OpportuniteCAOffre', type: 'currency',initialWidth: 100,sortable: true, typeAttributes: { currencyCode: "EUR" }},
    { label: 'Statut', fieldName: 'Statut', type: 'text',sortable: true }
];

export default class Lwc05EcosystemePartenaire extends LightningElement {
@api recordId;
isLoading = true;
page = 1;
relatedEcosysteme = [];
pageSize = 5; 
totalRecountCount = 0;
totalPage = 0;
sortedBy ='TypeRelation';
sortedDirection = 'asc';
error;
columns;
isFirstPage = true;
isLastPage = false;
showTable = false;

 // Expose the labels to use in the template.
 label = {
    lwc05_Header,
    lwc05_MessageNoRecords,
};

//Get the total number of related Ecosysteme on load
@wire(getTotalEcosysteme, { recordId: '$recordId'})
checkTotal({error,data}){
    
    if (data || data === 0) {
        //If the total is > 0 get the records and get the max page number
        if(data >0){
            this.showTable = true;
            this.totalRecountCount = data; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            this.columns = columns;
            this.getData(this.page);
        }else{
            this.showTable = false;
            this.isLoading = false;
        }

    } else if (error) {
        console.log('@@@ JK error');
        this.error = error;
        this.relatedEcosysteme = undefined;
        console.log(this.error);
        this.showTable = false;
        this.isLoading = false;
    }

}

    getData(page) {
        getRelatedEcosysteme({recordId: this.recordId,sortedBy: this.sortedBy,sortedDirection: this.sortedDirection,pageSize: this.pageSize,page: page})
        .then((result)=>{
            this.relatedEcosysteme = result;
            this.error = undefined;

            
        /*console.log('@@@ JK relatedEcosysteme');
        console.log(this.relatedEcosysteme);*/

        //To enable/disable the next and previous buttons
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
        
        this.isLoading = false;

        }).catch((error) => {
            this.error = error;
            this.relatedEcosysteme = undefined;
            
        this.isLoading = false;
        })
    }


    //clicking on previous button this method will be called
    previousHandler() {
        this.isLoading = true;
        if (this.page > 1) {
            this.page = this.page - 1; //decrease page by 1
            this.getData(this.page);
        }
    }

    //clicking on next button this method will be called
    nextHandler() {
        this.isLoading = true;
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.getData(this.page);            
        }
    }

    //sort by selected field and returning to first page
    sortColumns( event ) {
        this.isLoading = true;

        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;

        this.page = 1;
        this.getData(this.page);
        
    }  

}