import { LightningElement, track, api } from 'lwc';
import { FlowNavigationBackEvent, FlowNavigationNextEvent } from "lightning/flowSupport";
import retrieveEmplacements from '@salesforce/apex/LWC11_DemandesEnMasseV2_CTRL.getEmplacements';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
 
const actions = [
                    { label: 'Ajouter', name: 'Ajouter' },
                ];

const columns = [   
                    
                    {type:'button-icon', initialWidth: 75, typeAttributes: {rowActions: actions, iconName: 'utility:add', title: 'Ajouter', variant: 'border-filled', alternativeText: 'Ajouter', menuAlignment: 'right' }},
                    { label: 'DKCode', fieldName: 'dkCode' },
                    { label: 'Nom Emplacement', fieldName: 'nomEmplacement'},
                    { label: 'Ville', fieldName: 'ville' },
                    { label: 'Code Postal', fieldName: 'codePostal' },
                    { label: 'Usage', fieldName: 'usage' },
                    { label: 'Numéro de Contrat', fieldName: 'numeroContrat' },
                ];                
                
let i=0;    


export default class Lwc11DemandesEnMasseV2 extends LightningElement {
    @api availableActions = [];
    @api selectedRows = [];
    elementSelected = [];
    @track page = 1; //initialize 1st page
    @track items = []; //contains all the records.
    @track data; //data  displayed in the table
    @track columns = columns; //holds column info.
    @track startingRecord = 1; //start record position per page
    @track endingRecord = 0; //end record position per page
    @track pageSize = 15; //default value we are assigning
    @track totalRecountCount = 0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    @track searchText = '';
    @track searchType = '';
    @track isLoading = false;
    @track sortDirection = 'asc';
    @track isDesktop;
    @track isMobile;
    @track showModal = false;
    @track modalFieldInfo;
    @track sortedBy;
    @track mydata;
    @track currentPageSize = 0;
    @track selectedEmp = [];
 
 
    //check field validation
    handleCheckValidation() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.fieldvalidate');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });
        return isValid;
    }
 
    searchEmplacement(){
        console.log('taille de la liste' + this.selectedRows.length);
        if(this.handleCheckValidation()) {
            if(this.searchText == ''){
                this.page = 1;
                this.sortDirection = 'asc';
                this.sortBy = '';
                this.data = [];
                this.totalPage = 1;
                this.totalRecountCount = 0;
                return false;
            }
            this.isLoading = true;
            retrieveEmplacements({searchText : this.searchText, searchType : this.searchType})
            .then(data=>{
                console.log(data);
                this.mydata = this.items = data.lstEmplacements;
 
                var parseData = data.lstEmplacements;
                /*parseData.forEach(record=>{
                    record.linkName = '/'+record.contrat__r;
                });*/
                this.items = parseData;
                this.page = 1;
                this.sortDirection = 'asc';
                this.sortBy = '';
                this.totalRecountCount = data.lstEmplacements.length;
                this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                //here we slice the data according page size
                this.data = this.items.slice(0, this.pageSize); 
                this.endingRecord = this.data.length;
                this.error = undefined;
                this.isLoading = false;
                this.currentPageSize = this.endingRecord - this.startingRecord + 1;
            }) .catch(error=>{
                console.log(error);
                this.error = error;
                this.data = undefined;
                this.isLoading = false;
                this.showToast(this.error, 'Error', 'Error'); //show toast for error
            })
        }
    }
 
    handleSearchTypeChange(event){
        this.searchType = event.detail.value;
    }
 
    handleChange(event){
        if(event.target.name == 'SearchText'){
            this.searchText = event.target.value;
        }else{
            this.searchText = event.target.value;
            this.searchType = event.target.name;
        }
    }
 
    closeModal(){
        this.showModal = false;
    }
 
    get isContractDisabled(){
        return (this.searchType !== 'Contract' && this.searchText != '' ? true : false);
    }
 
    get isClientGroupDisabled(){
        return (this.searchType !== 'ClientGroup' && this.searchText != '' ? true : false);
    }
 
    get isZipCodeDisabled(){
        return (this.searchType !== 'ZipCode' && this.searchText != '' ? true : false);
    }

    get isAdressDisabled(){
        return (this.searchType !== 'Adress' && this.searchText != '' ? true : false);
    }
    
    get isDKCodeDisabled(){
        return (this.searchType !== 'DKCode' && this.searchText != '' ? true : false);
    }

    get isCityDisabled(){
        return (this.searchType !== 'City' && this.searchText != '' ? true : false);
    }

    get isEntityDisabled(){
        return (this.searchType !== 'Entity' && this.searchText != '' ? true : false);
    }

    get isPartnerDisabled(){
        return (this.searchType !== 'Partner' && this.searchText != '' ? true : false);
    }
 
    get isSearchTextDisabled(){
        return this.searchType == '' ? true : false;
    }
 
    //press on previous button this method will be called
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }
 
    //press on next button this method will be called
    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }             
    }
 
    get isPreviousDisable(){
        return (this.page == 1 ? true : false);
    }
 
    get isNextDisable(){
        return (this.page === this.totalPage || (this.page > this.totalPage)) ? true : false;
    }
 
    //this method displays records page by page
    displayRecordPerPage(page){
         
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
 
        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 
 
        this.data = this.items.slice(this.startingRecord, this.endingRecord);
 
        //increment by 1 to display the startingRecord count, 
        //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
        this.startingRecord = this.startingRecord + 1;
 
        //console.log(this.startingRecord);
        //console.log(this.endingRecord);
        this.currentPageSize = this.endingRecord - this.startingRecord + 1;
    }    
 
    showToast(message, variant, title) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
 
    onHandleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
 
    sortData(fieldname, direction) {
        /*if (fieldname == 'linkName') {
            fieldname = 'numeroContrat';
        }*/
        let parseData = [...this.items];
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
 
        console.log(keyValue);
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
         
        /*parseData.forEach(record=>{
            record.linkName = '/'+record.contrat__r;
        });*/
        this.items = parseData;
        this.displayRecordPerPage(this.page);
    }
    

    handleRowAction(event) {

        this.selectedRows.push(event.detail.row);

        this.selectedRows = Array.from(new Set(this.selectedRows.map(JSON.stringify))).map(JSON.parse);

        console.log('selected row' + JSON.stringify(this.selectedRows));

        console.log('la taille de la liste aprés clique ' + this.selectedRows.length);
 
    }


    handleNext() {
        if (this.availableActions.find((action) => action === "NEXT")){
            if (this.selectedRows.length >= 1) {
                console.log('la taille de la liste aprés récap ' + this.selectedRows.length);
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            } else {
                alert('Veuillez sélectionner au minimum un emplacement');
                
            }
        }
        
    }

    handleBack() {
        if (this.availableActions.find((action) => action === "BACK")) {
            const navigateBackEvent = new FlowNavigationBackEvent();
            this.dispatchEvent(navigateBackEvent);
        }
    }

    
}