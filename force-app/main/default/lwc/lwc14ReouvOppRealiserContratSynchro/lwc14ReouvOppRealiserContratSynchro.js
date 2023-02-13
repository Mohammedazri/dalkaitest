import { LightningElement, api } from 'lwc';
// Import custom labels
import LWC01_Annuler from '@salesforce/label/c.LWC01_Annuler'; 
import LWC01_Header from '@salesforce/label/c.LWC01_Header'; 
import LWC14_MessageInfo from '@salesforce/label/c.LWC14_MessageInfo'; 

export default class Lwc14ReouvOppRealiserContratSynchro extends LightningElement {

    @api checkBool = false;

    label = {
        LWC01_Annuler,
        LWC01_Header,
        LWC14_MessageInfo
    };

    @api
    showPopUp(){

        this.checkBool = true;
       
    }

    closeModal() { 
 
        this.checkBool = false; 
 
    }

}