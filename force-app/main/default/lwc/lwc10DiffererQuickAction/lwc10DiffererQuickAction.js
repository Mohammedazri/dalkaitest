import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DATE_FIELD from '@salesforce/schema/Case.Date_heure_differe__c';
import MESSAGE_FIELD from '@salesforce/schema/Case.Message_du_differe__c';
//import saveConsignes from '@salesforce/apex/LWC02_CascadeAppel_CTRL.saveConsignes';
import saveConsignesForDiffere from '@salesforce/apex/LWC02_CascadeAppel_CTRL.saveConsignesForDiffere';
import { updateRecord } from 'lightning/uiRecordApi';
const fields = [DATE_FIELD, MESSAGE_FIELD];


//const FIELDS = [ID_FIELD, DATE_FIELD, MESSAGE_FIELD];

export default class LwcCustomModal extends LightningElement {
    @api objectApiName;
    @api recordId;
    @track error;
    @api updatedListDifferer;
    @api showSpinnerCascade;
    thefields = [DATE_FIELD, MESSAGE_FIELD];
    datediffere = DATE_FIELD;
    message = MESSAGE_FIELD;
    @api customFormModal = false;
    showSpinner = true;
    

    customShowModalPopup() {

        this.customFormModal = true;

    }

    customHideModalPopup() {

        console.log('je suis dans la popup pour le moment');
        this.customFormModal = false;
        this.showSpinnerCascade = false;
        updateRecord({ fields: { Id: this.recordId }})

    }

    handleModal() {
        if(this.customFormModal) {
            this.customFormModal = false;
            this.showSpinner = false;
        }else {
            this.customFormModal = true;
            this.showSpinner = true;
        }
    }

    handleSubmit() {
        this.showSpinner = true;
        saveConsignesForDiffere({ listeConsignes: this.updatedListDifferer })
                        .then(data => {
                            if (data) {
                                this.error = undefined;
                                this.isError = false;
                                this.updatedValuesForDiffere = [];
                                this.recordsNotChanged = true;
                                console.log('la je suis dans le save');
                            }
                        }).catch(error => {
                            this.isError = true;
                            if (error.body.message !== undefined) {
                                this.error = error.body.message;
                            } else if (error.body.pageErrors.length === 1) {
                                this.error = error.body.pageErrors[0].message;
                            } else {
                                this.error = 'Plusieurs erreurs sont survenues! Veuillez contacter votre administrateur!';
                            }

                            this.updatedValuesForDiffere = [];
                            this.recordsNotChanged = true;
                            this.showSpinnerCascade = false;
                        })
                
    }

    handleSuccess() {
        this.showToast('Votre Demande de dépannage a été différée avec succés!', 'success', 'Succès!', 'dismissable');
        this.handleModal();
    }

    handleError(event) {
        //this.showToast('Votre Demande de dépannage n\'a pas été différée suite a une erreur', 'error', 'Erreur!', 'dismissable');
        this.showToast(event.detail.detail, 'error', 'Erreur!', 'dismissable');
        this.showSpinner = false;
    }

    showToast(message, variant, title, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }

}