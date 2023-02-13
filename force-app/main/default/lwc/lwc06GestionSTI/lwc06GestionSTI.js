import { LightningElement, api, wire, track } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import RECORDTYPEID_STI from '@salesforce/schema/Case.RecordTypeId';
import PROLONGATION_FIELD from '@salesforce/schema/Case.ProlongationSTI__c';
import { getRecord } from 'lightning/uiRecordApi';
import getData from '@salesforce/apex/LWC06_GestionSTI_CTRL.getData';
import setKO from '@salesforce/apex/LWC06_GestionSTI_CTRL.setKO';
import setOK from '@salesforce/apex/LWC06_GestionSTI_CTRL.setOK';
import setProlongation from '@salesforce/apex/LWC06_GestionSTI_CTRL.setProlongation';
import { refreshApex } from '@salesforce/apex';
import LOCALE from '@salesforce/i18n/locale';

const optionsDate = {year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric"};
const generateObjValPair = (_dataArray) => {
    return _dataArray.map(element => Object.assign({ value: element, label: element }))
}

const actions = ['', 'OK', 'KO', 'Prolongation'];

export default class Lwc06GestionSTI extends LightningElement {
    @api recordId;
    recordTypeId;

    _wiredResult;
    etapeActuelle;
    premierKO;
    deuxiemeKO;
    troisiemeKO;
    nombreActuelKO;
    empreinte;
    nombreTotalKO;
    prolongation;
    estOK;
    nomTechnicien;
    telephoneTechnicien;
    isReadOnly = true;
    showEmpreinte = false;
    picklistActions = [];
    showSpinner = false;
    
    @track selectedAction;
    @track selectedProlongation;
    @track disablePicklistActions = true;
    @track disablePicklistProlongation = true;
    @track disableButtonValider = true;
    @track classCSSKo1 = 'KO-White';
    @track classCSSKo2 = 'KO-White';
    @track classCSSKo3 = 'KO-White';
    @track classCSSOK = 'OK-White';

    @wire(getRecord, {recordId: '$recordId', fields: RECORDTYPEID_STI})
    getRecordTypeId({error, data}) {
        if(data) {
            this.recordTypeId = data.recordTypeId;
        }

        if(error) {
            console.error('Error has occured while trying to get RecordTypeId : ' + error);
        }
    }

    
    @wire(getPicklistValues, { recordTypeId: '$recordTypeId', fieldApiName: PROLONGATION_FIELD })
    getProlongationPicklist({error, data}) {
        if(data) {
            this.picklistProlongation = data.values;
        }

        if(error) {
            console.error('Error has occured while trying to get Picklist values for Prolongation : ' + error);
         }
    }

    @api refreshData() {
        this.selectedProlongation = null;
        this.selectedAction = null;
        this.disableButtonValider = true;
        this.disablePicklistProlongation = true;
        this.disablePicklistActions = true;
        return refreshApex(this._wiredResult);
    }

    @wire(getData, {recordId: '$recordId'})
    getData(result) {
        this._wiredResult = result;
        let data = result.data;
        let error = result.error;

        if(data) {

            this.picklistActions = generateObjValPair(actions);
            let demande = data.demande;
            this.etapeActuelle = demande.EtapeSTI__c;
            this.nombreActuelKO = demande.NbrKOActuelSTI__c;
            this.nombreTotalKO = demande.NbrKOTotalSTI__c;
            this.estOK = demande.OKSTI__c;
            this.isReadOnly = data.isReadOnly;
            if(demande.HeureProchainAppelTechnicienSTI__c !== undefined && demande.HeureProchainAppelTechnicienSTI__c !== null)
                this.empreinte = new Intl.DateTimeFormat(LOCALE, optionsDate).format(new Date(demande.HeureProchainAppelTechnicienSTI__c));
            this.prolongation = demande.TotalProlongationSTI__c;
            this.showEmpreinte = data.showEmpreinte;
            this.nomTechnicien = demande.Technicien__r.Name;
            this.telephoneTechnicien = demande.Technicien__r.Phone;

            this.setKOandOK();
            
            if(this.nombreActuelKO === 3) {
                //this.picklistActions = this.picklistActions.filter(action => action.value !== 'KO' && action.value !== 'Prolongation');
                this.picklistActions = this.picklistActions.filter(action => action.value !== 'KO');
            }

            if(this.isReadOnly === true) {
                this.disablePicklistActions = true;
                this.disableButtonValider = true;
                this.disablePicklistProlongation = true;
            } else {
                this.disablePicklistActions = false;
            }
        }   

        if(error) {
            console.error('Error has occured while trying to load STI Data : ' + error);
        }
    }

    connectedCallback() {}

    setKOandOK() {
        if(this.estOK === true) {
            this.classCSSOK = 'OK-Green';
        }else {
            this.classCSSOK = 'OK-White';
        }

        if(this.nombreActuelKO === 0) {
            this.classCSSKo1 = 'KO-White';
            this.classCSSKo2 = 'KO-White';
            this.classCSSKo3 = 'KO-White';
        }

        if(this.nombreActuelKO === 1) {
            this.classCSSKo1 = 'KO-Red';
            this.classCSSKo2 = 'KO-White';
            this.classCSSKo3 = 'KO-White';
        }

        if(this.nombreActuelKO === 2) {
            this.classCSSKo1 = 'KO-Red';
            this.classCSSKo2 = 'KO-Red';
            this.classCSSKo3 = 'KO-White';
        }

        if(this.nombreActuelKO === 3) {
            this.classCSSKo1 = 'KO-Red';
            this.classCSSKo2 = 'KO-Red';
            this.classCSSKo3 = 'KO-Red';
        }
    }

    handleActionChange(event) {
        this.selectedAction = event.detail.value;

        if(this.selectedAction === 'Prolongation') {
            this.disablePicklistProlongation = false;
            this.disableButtonValider = true;
        } else if(this.selectedAction !== '') {
            this.disablePicklistProlongation = true;
            this.selectedProlongation = null;
            this.disableButtonValider = false;
        } else {
            this.disableButtonValider = true;
            this.disablePicklistProlongation = true;
            this.selectedProlongation = null;
        }
    }

    handleClickValider() {
        this.showSpinner = true;
        if(this.selectedAction === 'KO') {
            setKO({recordId: this.recordId})
            .then(() => {
                this.showSpinner = false;
                this.refreshData();
            })
            .catch(error => {
                this.showSpinner = false;
                console.error(error);
            });
        }

        if(this.selectedAction === 'OK') {
            setOK({recordId: this.recordId})
            .then(() => {
                this.showSpinner = false;
                this.refreshData();
            })
            .catch(error => {
                this.showSpinner = false;
                console.error(error);
            });
        }
        
        if(this.selectedAction === 'Prolongation' && this.selectedProlongation !== null) {
            setProlongation({recordId: this.recordId, prolongation: this.selectedProlongation})
            .then(() => {
                this.showSpinner = false;
                this.refreshData();
            })
            .catch(error => {
                console.error(error);
            })
        }
    }

    handleProlongationChange(event) {
        this.selectedProlongation = event.detail.value;
        this.disableButtonValider = false;
    }
}