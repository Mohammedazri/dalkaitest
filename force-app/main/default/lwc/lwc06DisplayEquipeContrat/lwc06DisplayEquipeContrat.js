import { LightningElement,api,track } from 'lwc';
import deleteContratShare from '@salesforce/apex/lwc06GetRelatedContratShare_Controller.deleteContratShare';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Lwc06DisplayEquipeContrat extends LightningElement {
    @api userprofileurl;
    @api username;
    @api useraccess;
    @api userid;
    @api csid;
    @api notdeleteable;
    elementcsId;
    isModalOpen = false;
    opendeleteform(event){
        this.isModalOpen = true;
        this.elementcsId = event.target.id.substring(0,18)
    }
    deleteContratShare(event) {
        deleteContratShare({csId: this.elementcsId })
        .then((result)=>{ 
            if(result=='OK'){
                const event = new ShowToastEvent({
                    title: 'Succès',
                    message: 'Membre supprimé de l\'équipe du contrat',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
                this.isModalOpen = false;

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
            const selectedEvent = new CustomEvent("refreshparent");
            this.dispatchEvent(selectedEvent);
        }).catch((error) => {
            console.log(error);
            
        })           
        }
        closeModal(event){
            this.isModalOpen = false;
        }
    }