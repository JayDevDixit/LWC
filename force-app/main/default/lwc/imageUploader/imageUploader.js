import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ImageUploader extends LightningElement {
    @api recordId;
    imageUrl;
    acceptedFormats=['.jpg', '.png', '.jpeg'];
    handleUploadFinished(event){
        const uploadedFiles = event.detail.files;
        if(uploadedFiles.length>0){
            const uploadedFileId = uploadedFiles[0].documentId;
            this.imageUrl = `/sfc/servlet.shepherd/document/download/${uploadedFileId}`;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'File uploaded successfully!',
                    variant: 'success', 
                }),
            );
            
        }
    }
    
}