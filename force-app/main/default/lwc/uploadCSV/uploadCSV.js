import { LightningElement } from 'lwc';
import processCsvFile from '@salesforce/apex/ACRUploadLWCController.processCsvFile';

export default class UploadCSV extends LightningElement {
    isProcessing = false;
    message;

    handleFileChange(event) {
        const file = event.target.files[0];
        if (!file) return;

        this.isProcessing = true;
        this.message = '';

        const reader = new FileReader();
        reader.onload = () => {
            const csvContent = reader.result;
            processCsvFile({ csvData: csvContent })
                .then((result) => {
                    this.message = result;
                })
                .catch((error) => {
                    this.message = 'Error: ' + (error.body?.message || error.message);
                })
                .finally(() => {
                    this.isProcessing = false;
                });
        };
        reader.readAsText(file);
    }
}
