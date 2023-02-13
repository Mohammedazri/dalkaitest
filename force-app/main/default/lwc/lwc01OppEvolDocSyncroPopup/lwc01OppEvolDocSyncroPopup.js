import { LightningElement, api } from 'lwc';
// Import custom labels
import LWC01_Annuler from '@salesforce/label/c.LWC01_Annuler'; 
import LWC01_Header from '@salesforce/label/c.LWC01_Header'; 

export default class Example extends LightningElement {

    @api checkBool = false;
    @api evolMSG = "";

    label = {
        LWC01_Annuler,
        LWC01_Header
    };

    @api
    showPopUp(){

        this.checkBool = true;
       
    }

    closeModal() { 
 
        this.checkBool = false; 
 
    }

}