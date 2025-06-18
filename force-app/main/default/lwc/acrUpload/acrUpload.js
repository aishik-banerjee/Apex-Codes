import { LightningElement, track } from 'lwc';
import uploadACRRecords from '@salesforce/apex/ACRUploadControllerLWC.processCSV';

export default class AcrUpload extends LightningElement {
    @track errorMessages = [];
    @track successMessage = '';

    handleFileChange(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = () => {
                const base64 = reader.result.split(',')[1];
                uploadACRRecords({ base64Data: base64 })
                    .then(result => {
                        this.errorMessages = result.errors;
                        this.successMessage = result.success;
                    })
                    .catch(error => {
                        this.errorMessages = ['Upload failed: ' + error.body.message];
                    });
            };
            reader.readAsDataURL(file);
        }
    }

    downloadTemplate() {
        const csvContent = 'data:text/csv;charset=utf-8,ShipToAbbreviation__c,Included_in_Portal__c\n';
        const encodedUri = encodeURI(csvContent);
        const link = document.createElement('a');
        link.setAttribute('href', encodedUri);
        link.setAttribute('download', 'ACR_Template.csv');
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}