import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createContratShare from '@salesforce/apex/lwc08AddNewContratMemberController.createContratShare';

export default class DynamicRecordCreationRows extends NavigationMixin(LightningElement) {
    
    @api contratid;
    users=[];
    access =[];
    ObjectConfig = [ //Array of objects
    {
        'label':  'Utilisateur', 
        'APIName': 'User', 
        'fields':'Name,FirstName,LastName,Nom_agence__c,DkCode__c',
        'displayFields':'Name,Nom_agence__c,DkCode__c', 
        'iconName': 'standard:user',
        'FilterCondition' : 'isActive = true'
    },
];
handleAccountChange(event){
    console.log('***In handleAccountChange**');
}

handlesearchInputChange(event){
    console.log('***In handlesearchInputChange**');
}
value = 'Read';
get options() {
    return [
        { label: 'Lecture', value: 'Read' },
        { label: 'Lecture/Écriture', value: 'Edit' },
    ];
}

keyIndex = 0;
@track itemList = [
    {
        id: 0
    }
];

addRow() {
    ++this.keyIndex;
    var newItem = [{ id: this.keyIndex }];
    this.itemList = this.itemList.concat(newItem);
}

removeRow(event) {
    if (this.itemList.length >= 2) {
        this.itemList = this.itemList.filter(function (element) {
            return parseInt(element.id) !== parseInt(event.target.accessKey);
        });
    }
}

handleSubmit() {
    var noerror = true;
    this.users=[];
    this.template.querySelectorAll('c-lwc09-custom-looup').forEach(element => {
        if(element.selectedRecord!=null){
            this.users.push(element.selectedRecord.Id);
        }
        else{
            noerror = false;
            this.users =[];
            const event = new ShowToastEvent({
                title: 'Erreur',
                message: 'Il faut choisir un utilisateur',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            ;
        }
    });
    if(noerror){
        this.template.querySelectorAll('lightning-combobox').forEach(element => {
            this.access.push(element.value);
        });
        console.log(this.users);
        console.log(this.access);
        createContratShare({contratid: this.contratid,listUserId: this.users,listAccess: this.access})
        .then((result)=>{
            if(result=="OK"){
                const event = new ShowToastEvent({
                    title: 'Succès',
                    message: 'Membre(s) ajoutés à l\'équipe du contrat',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
                
                /**/
                const selectedEvent = new CustomEvent("refreshparent2");
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            }
            else{
                const event = new ShowToastEvent({
                    title: 'Erreur',
                    message: result,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            }
        })
        
    }
}
}