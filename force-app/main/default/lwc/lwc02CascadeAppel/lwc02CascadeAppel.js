import { LightningElement, wire, api, track } from 'lwc';
import { generateObjValPair } from 'c/lwc04CustomDataTable'
import getData from '@salesforce/apex/LWC02_CascadeAppel_CTRL.getData';
import saveConsignes from '@salesforce/apex/LWC02_CascadeAppel_CTRL.saveConsignes';
import calloutCascadeAppel from '@salesforce/apex/LWC02_CascadeAppel_CTRL.callWebServiceCascadeAppel';
import getLayoutMetadata from '@salesforce/apex/LWC02_CascadeAppel_CTRL.getLayoutMetadata';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

const reponses = ['Refusé', 'Attribué', 'Différé', 'Messagerie', 'Non contacté'];
const dureeGlobal = ['00:30', '00:35', '00:40', '00:45', '00:50', '00:55', '01:00', '01:05', '01:10', '01:15', '01:20', '01:25', '01:30', '01:35', '01:40', '01:45', '01:50', '01:55', '02:00'];

export default class Lwc02CascadeAppel extends LightningElement {
    channelNameConsigne = '/data/Consigne__ChangeEvent';
    old_channelNameDemande = '/data/CaseChangeEvent';
    channelNameDemande = '/event/CaseEvent__e';
    data = [];
    filteredData = [];
    idSIAs = [];
    options;
    selectedOption;
    error;
    subscriptionConsigne;
    subscriptionDemande;
    isSubscribedConsigne = false;
    isBlur = true;
    _wiredResult;
    _previousResult;
    updatedValues = new Array();
    updatedValuesForDiffere = new Array();
    showSpinner = true;
    @api recordId;
    isReadOnly;
    recordsNotChanged = true;
    isError = false;
    transactionKeyConsigne;
    transactionKeyDemande;
    consigneKeys;
    cssClass = 'datatable-blur';
    uiRecordCreate;
    activeSectionNamesEdit = [];
    isModalOpen = false;
    recordTypeId;
    caseRecordTypeName;
    isDifferer = false;
    numtel = '+33660423635';
    handleSubmit() {
        this.showSpinner = true;
    }

    handleSuccess() {
        this.showToast('Votre nouvelle Consigne a été créée avec succés!', 'success', 'Succès!', 'dismissable')
        this.handleModal();
    }

    handleError() {
        this.showSpinner = false;
    }

    handleModal() {
        if (this.isModalOpen) {
            this.isModalOpen = false;
            this.showSpinner = false;
        } else {
            this.isModalOpen = true;
            this.showSpinner = true;
            getLayoutMetadata()
                .then((data) => {
                    this.showSpinner = false;
                    this.uiRecordCreate = JSON.parse(data);
                    for (let section of this.uiRecordCreate.layoutSections) {
                        this.activeSectionNamesEdit.push(section.label);

                        if (section.layoutColumns !== null) {
                            for (let column of section.layoutColumns) {
                                if (column.layoutItems !== null) {
                                    for (let item of column.layoutItems) {
                                        if (item.behavior === 'Required') {
                                            item.isRequired = true;
                                        } else {
                                            item.isRequired = false;
                                        }

                                        if (item.field === 'Demande__c') {
                                            item.value = this.recordId;
                                        }

                                        if (item.behavior === 'Readonly') {
                                            item.isReadOnly = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }).catch(error => {
                    if (error) {
                        this.error = error.body.message;
                    }
                });
        }
    }

    handleSubscribeDemande() {
        const messageCallback = (response) => {
            let caseId = response.data.payload.CaseId__c;

            if (caseId === this.recordId) {
                this.refreshData();
            }
        }

        subscribe(this.channelNameDemande, -1, messageCallback).then((response) => {
            this.subscriptionDemande = response;
        });
    }

    old_handleSubscribeDemande() {
        const messageCallback = (response) => {
            let changeType = response.data.payload.ChangeEventHeader.changeType;

            if (changeType === 'UPDATE') {
                let ownerOrStatusChanged = false;
                let changedFields = response.data.payload.ChangeEventHeader.changedFields;
                changedFields.forEach(element => {
                    if (element === 'OwnerId' || element === 'Status') {
                        ownerOrStatusChanged = true;
                    }
                });

                if (ownerOrStatusChanged) {
                    this.refreshData();
                }
            }
        }

        subscribe(this.channelNameDemande, -1, messageCallback).then((response) => {
            this.subscriptionDemande = response;
        });
    }

    handleSubscribeConsigne() {
        const messageCallback = (response) => {
            let transactionKey = response.data.payload.ChangeEventHeader.transactionKey;
            let changeType = response.data.payload.ChangeEventHeader.changeType;

            if (changeType === 'CREATE') {
                let idDemande = response.data.payload.Demande__c;
                let reponseConsigne = response.data.payload.Reponse__c;

                if (idDemande === this.recordId && transactionKey !== this.transactionKeyConsigne && (reponseConsigne === 'Non contacté' || (reponseConsigne === 'Attribué' && this.caseRecordTypeName === 'Demande_de_depannage'))) {
                    this.transactionKeyConsigne = transactionKey;
                    this.refreshData();
                } else if (reponseConsigne !== 'Non contacté') {
                    eval("$A.get('e.force:refreshView').fire();");
                }
            } else if (changeType === 'UPDATE') {
                let demandeIds = response.data.payload.ChangeEventHeader.recordIds;
                let found = false;
                if (demandeIds && this.consigneKeys && transactionKey !== this.transactionKeyConsigne) {
                    this.transactionKeyConsigne = transactionKey;
                    this.consigneKeys.forEach(element1 => {
                        demandeIds.forEach(element2 => {
                            if (element1 === element2) {
                                found = true;
                            }
                        });
                    });

                    if (found) {
                        this.refreshData();
                    }
                }
            }
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelNameConsigne, -1, messageCallback).then((response) => {
            this.subscriptionConsigne = response;
        });
    }

    handleSelect(event) {
        this.selectedOption = event.detail.value;

        if (this.selectedOption != '') {
            this.filteredData = this.data.filter(consigne => consigne.RecordType.DeveloperName === 'Consignes_Manuelle' || consigne.IdSIA__c === this.selectedOption).sort((a, b) => (a.Ordre__c === null) ? 1 : (b.Ordre__c - a.Ordre__c > 0 ? -1 : 0));
            this.showAlertMessage = 'Plusieurs SIA sont disponibles.';
        } else {
            this.showAlertMessage = 'Veuillez sélectionner un SIA, plusieurs SIA sont disponibles.'
            this.filterConsigneManuelle();
        }
    }

    filterConsigneManuelle() {
        this.filteredData = this.data.filter(consigne => consigne.RecordType.DeveloperName === 'Consignes_Manuelle');
    }

    @api
    refreshData() {
        if (!this.isError) {
            this.isError = false;
            this.showSpinner = true;
            this.data = [];
            this.filteredData = [];
            this.idSIAs = [];
            return refreshApex(this._wiredResult);
        }
        return null;
    }

    registerErrorListener() {
        onError((error) => {
            console.error('Received error from server: ', JSON.stringify(error));
            this.isError = true;
            this.showAlert = false;
            this.error = 'Un problème technique est survenu, veuillez rafraichir la page!';
            this.showSpinner = false;
            this.filteredData = [];
        });
    }

    loadConsignes() {
        if (!this.isSubscribedConsigne) {
            this.handleSubscribeConsigne();
            this.registerErrorListener();
            this.isSubscribedConsigne = true;
        }

        this.showSpinner = true;
        calloutCascadeAppel({ recordId: this.recordId })
            .then((data) => {
                this.isBlur = false;
                this.cssClass = 'datatable';

                if (data === false) {
                    this.filteredData = this.filteredData.filter(consigne => consigne.RecordType.DeveloperName !== 'Consignes_Automatique');
                    this.showSpinner = false;
                    this.showAlert = true;
                    this.showAlertMessage = 'Aucune consigne automatique récupérée. Veuillez prévenir votre administrateur.';
                } else {
                    this.showAlert = false;
                }
            }).catch(error => {
                if (error) {
                    this.error = error.body.message;
                    console.error(JSON.stringify(error));
                }
            });
    }

    connectedCallback() {
        this.handleSubscribeDemande();
        this.registerErrorListener();

        this.columns = [
            { label: 'Ordre', fieldName: 'N_ordre__c', type: 'numeric' },
            { label: 'Matricule', fieldName: 'Matricule__c' },
            { label: 'Nom', fieldName: 'Nom_du_technicien__c' },
            { label: 'Numéro de téléphone', fieldName: 'Numero_de_telephone__c', type: 'clickToDial', 
                typeAttributes: {
                    value: {fieldName: 'Numero_de_telephone__c'}
                }
            },
            
            { label: 'Type de ressource', fieldName: 'TypeRessource__c' },
            { label: 'Id SIA', fieldName: 'IdSIA__c', type: 'text' },
            { label: 'Délai', fieldName: 'Delai__c', type: 'text' },
            {
                label: 'Réponse', fieldName: 'Reponse__c', type: 'normalpicklist',
                typeAttributes: {
                    picklistOptions: generateObjValPair(reponses),
                    value: { fieldName: 'Reponse__c' },
                    context: { fieldName: 'Id' },
                    fieldApiName: 'Reponse__c'
                }
            },
            {
                label: 'Durée globale', fieldName: 'Duree_globale__c', type: 'normalpicklist',
                typeAttributes: {
                    picklistOptions: generateObjValPair(dureeGlobal),
                    value: { fieldName: 'Duree_globale__c' },
                    context: { fieldName: 'Id' },
                    fieldApiName: 'Duree_globale__c'
                }
            },
        ];
    }

    handleChange(evt) {
        this.myValue = numtel; // updates the internal state
    }

    unsubscribeConsigne() {
        this.isSubscribedConsigne = false;
        unsubscribe(this.subscriptionConsigne, (response) => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
        });
    }

    unsubscribeDemande() {
        unsubscribe(this.subscriptionDemande, (response) => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
        });
    }

    disconnectedCallback() {
        if (this.isSubscribedConsigne) {
            this.unsubscribeConsigne();
        }
        this.unsubscribeDemande();
    }

    saveConsignes() {
        this.showSpinner = true;
        if (this.updatedValues.length > 0) {
            this.updatedValues.forEach(updatedValue => {
                let matricule;
                let reponse;
                let dureeGlobal;
                this.filteredData.forEach(value => {
                    console.log("le delai " + value.Delai__c);
                    if (updatedValue.Id === value.Id && (updatedValue.Reponse__c === 'Refusé')) {
                        matricule = value.Matricule__c;
                        console.log("le matricule: " + matricule);
                        reponse = updatedValue.Reponse__c;
                        console.log("la reponse: " + reponse);
                        dureeGlobal = updatedValue.Reponse__c;
                    } else if (updatedValue.Reponse__c === 'Différé') {
                        this.isDifferer = true;
                    }
                });

                this.filteredData.forEach(value => {
                    if (value.Matricule__c === matricule && value.Id !== updatedValue.Id) {
                        let matchedMatricules = this.updatedValues.filter(consigne => consigne.Id === value.Id);
                        console.log("matched matricule" + JSON.stringify(matchedMatricules));
                        if (matchedMatricules === undefined || matchedMatricules.length === 0) {
                            this.updatedValues.push({ Id: value.Id, Reponse__c: reponse, Duree_globale__c: dureeGlobal });
                        }
                    }
                });
            });

            console.table('those are the updatedValues' + JSON.stringify(this.updatedValues));
            
            this.updatedValues.forEach(updatedResponse => {
                if (updatedResponse.Reponse__c != 'Différé') {
                    saveConsignes({ listeConsignes: this.updatedValues })
                        .then(data => {
                            if (data) {
                                this.error = undefined;
                                this.isError = false;
                                this.updatedValues = [];
                                this.recordsNotChanged = true;
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

                            this.updatedValues = [];
                            this.recordsNotChanged = true;
                            //this.showSpinner = false;
                        })
                }
            });

            this.showSpinner = false;

        }
    }
    saveConsignesForDiffere() {
        this.showSpinner = true;
        if (this.updatedValuesForDiffere.length > 0) {
           
            
            this.updatedValuesForDiffere.forEach(updatedResponse => {
                if (updatedResponse.Reponse__c == 'Différé') {
                    saveConsignesForDiffere({ listeConsignes: this.updatedValuesForDiffere })
                        .then(data => {
                            if (data) {
                                this.error = undefined;
                                this.isError = false;
                                this.updatedValuesForDiffere = [];
                                this.recordsNotChanged = true;
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
                            //this.showSpinner = false;
                        })
                }
            });

            this.showSpinner = false;

        }
    }


    setConsigneKeys(data) {
        if (data) {
            this.consigneKeys = [];
            data.forEach(element => {
                this.consigneKeys.push(element.Id);
            });
        }
    }

    @wire(getData, { recordId: '$recordId' })
    getConsignes(result) {
        this._wiredResult = result;
        if (result.data) {
            eval("$A.get('e.force:refreshView').fire();");
            this.data = result.data.listConsignes;
            this.setConsigneKeys(this.data);
            this.isReadOnly = result.data.isReadOnly;
            this.error = null;

            this.caseRecordTypeName = result.data.caseRecordTypeName;

            if (result.data.listeIdSIA.length > 1) {
                this.idSIAs.push({ value: '', label: '' });
            }

            this.recordTypeId = result.data.recordTypeId_Manuelle;

            result.data.listeIdSIA.forEach(element => {
                this.idSIAs.push({ value: element, label: element });
            });

            this.options = JSON.parse(JSON.stringify(this.idSIAs));
            this.filteredData = this.data;

            if (this.idSIAs.length == 1) {
                this.selectedOption = this.idSIAs[0].value;
            } else {
                this.selectedOption = '';
                this.filterConsigneManuelle();
            }

            if (this.idSIAs.length > 1 && this.isSubscribedConsigne) {
                this.showAlert = true;
                this.showAlertMessage = 'Veuillez sélectionner un SIA, plusieurs SIA sont disponibles.'
                //this.showAlertMessage = 'Plusieurs SIA sont disponibles.';
            }

            if (this.isReadOnly) {
                this.cssClass = 'datatable-blur';
                this.isBlur = true;
                this.showAlert = false;
            }

            this.showSpinner = false;
            this.isError = false;
        } else {
            this.showSpinner = false;
        }

        if (result.error) {
            this.isError = true;
        }
    }

    pickliListChanged(event) {
        event.stopPropagation();
        let consigneId = String(event.detail.context);
        let consigneReponse = String(event.detail.value);
        let found = false;
        let foundForDiffere = false;
        this.recordsNotChanged = true;

        this.updatedValues.forEach(consigne => {
            if (consigne.Id === consigneId && consigneReponse !== 'Non contacté') {
                found = true;
                consigne.Reponse__c = consigneReponse;
            }

            if (consigne.Id === consigneId && consigneReponse === 'Non contacté') {
                this.updatedValues = this.updatedValues.filter(value => value.Id !== consigneId);
            }
        });

        if (!found && consigneReponse !== 'Non contacté') {
            this.updatedValues.push({ Id: consigneId, Reponse__c: consigneReponse });
        }

        if (this.updatedValues.length > 0) {
            this.recordsNotChanged = false;
        }
        this.updatedValuesForDiffere.forEach(consigne => {
            if (consigne.Id === consigneId && consigneReponse == 'Différé') {
                foundForDiffere = true;
                consigne.Reponse__c = consigneReponse;
            }
        }); 

        if (!foundForDiffere && consigneReponse == 'Différé') {
            this.updatedValuesForDiffere.push({ Id: consigneId, Reponse__c: consigneReponse });
        }
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