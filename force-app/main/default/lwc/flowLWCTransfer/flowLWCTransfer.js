import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
export default class FlowLWCTransfer extends LightningElement {
    @api name;
    handleChange(event) {
        this.name = event.target.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('name', this.name));
    }
}