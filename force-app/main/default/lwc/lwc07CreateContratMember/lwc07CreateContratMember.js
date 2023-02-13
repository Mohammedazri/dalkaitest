import { LightningElement,track,api } from 'lwc';
export default class ModalPopupLWC extends LightningElement {
    @api contratid;
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
    refreshparent2(event) {
        this.isModalOpen = false;
        const selectedEvent = new CustomEvent("refreshparent");
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
      }

}