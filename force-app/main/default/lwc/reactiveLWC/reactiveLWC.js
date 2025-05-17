import { LightningElement, api } from 'lwc';

export default class ReactiveLWC extends LightningElement {
    //recieve value from flow here
    @api reactiveValue;
}