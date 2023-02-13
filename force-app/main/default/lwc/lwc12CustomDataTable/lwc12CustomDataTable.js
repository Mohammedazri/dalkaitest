import { LightningElement, track, api } from 'lwc';
import { FlowNavigationBackEvent, FlowNavigationNextEvent } from "lightning/flowSupport";

const columns = [
        { label: 'DKCode', fieldName: 'dkCode' },
        { label: 'Nom Emplacement', fieldName: 'nomEmplacement'},
        { label: 'Ville', fieldName: 'ville' },
        { label: 'Code Postal', fieldName: 'codePostal' },
        { label: 'Usage', fieldName: 'usage' },
        { label: 'Numéro de Contrat', fieldName: 'numeroContrat' },
];  

export default class Lwc12 extends LightningElement {

    @track columns = columns;
    @api emplacementList = [];
    @api selectedEmpList = [];
    @api availableActions = [];


    getSelectedEmplacement(event) {
        this.getSelectedEmplacement = event.detail.selectedRows;
        this.selectedEmpList = event.detail.selectedRows;
        console.log('la taille de la liste aprés récap ' + JSON.stringify(this.selectedEmpList));
        console.log('selected row' + this.selectedEmpList.length);
        
        /*for (let i = 0; i < selectedRows.length; i++) {
            selectedNames.push(selectedEmpList[i].dkCode);
        }*/
    }

    handleNext() {
        if (this.availableActions.find((action) => action === "NEXT")){
            if(this.selectedEmpList.length > 0)  {
                console.log('la taille de la liste aprés récap ' + this.selectedEmpList.length);
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