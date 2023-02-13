import { LightningElement, api } from 'lwc';
const areSame = (str, str2) =>  str === str2

export default class Lwc03DatatablePicklist extends LightningElement {
    @api picklistOptions
    @api value;
    @api label;
    @api context;
    @api fieldApiName

    connectedCallback() {
        this.picklistOptions = this.picklistOptions.map( element => Object.assign({}, element, {isSelected: areSame(element.value, this.value)}))
    }

    handleChange(event) {
        const selectedEvent = new CustomEvent('picklistchanged', {
            detail: {
                value: event.target.value, 
                fieldApiname:this.fieldApiName,
                context: this.context
            }, 
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(selectedEvent);
    }
}