import { LightningElement, track } from 'lwc';
import fetchDataFromDrive from '@salesforce/apex/ApiController.fetchDataFromDrive';
import uploadFileToDrive from '@salesforce/apex/ApiController.uploadFileToDrive';

export default class GoogleDrive extends LightningElement {
    @track files = [];
    @track data;
    @track fileIndex;
    acceptedFormats=['.jpg', '.png', '.jpeg','.doc','.docx','.txt'];
    columns=[
        {label:'Id',fieldName:'id'},
        {label:'File Name',fieldName:'name'},
        {label:'File Type',fieldName:'mimeType'},
        {label:'Created Time',fieldName:'createdTime'},
        {label:'owners',fieldName:'owners'},
        {label:'webViewLink',fieldName:'webViewLink'},
        {label:'iconLink',fieldName:'iconLink'},
        {label:'Size',fieldName:'sizeInMB'},  
        {
            type: 'button',
            typeAttributes: {
                label: 'Open',
                name: 'open',
                variant: 'brand'
            }
        }      

    ];
    handleRowAction(event){
        console.log('Row action triggered');
        const row = event.detail.row;
        const webViewLink = row.webViewLink;
        if(webViewLink)
            window.open(webViewLink, '_blank');
        else
        console.log('No webview link available');
    }

    fetchData(event){
        this.data = '';
        this.files = [];
        fetchDataFromDrive().then(result=>{
            this.data = JSON.parse(result);
            this.files = this.data['files'];
            console.log('Fetch data from drive');
            let i = 0;
            for(let file of this.files){
                file.index = i;
                i+=1
                file.iframeWidth = '0px';
                file.iframeHeight = '0px';
                file.status = 'Open File';
                file.sizeInMB = (file.size / (1024 * 1024)).toFixed(2) + ' MB';

            }
            // console.log('Result---'+this.files[0]['mimeType']);
        }).catch(error => {
            this.error = error;
            console.error('Error fetching data:', error);
            this.showToast('Error','Error occured during fetching or parsing data from API','Error')
        });
    }

    openFile(event){
        this.fileIndex = event.currentTarget.dataset.index;
        let file = this.files[this.fileIndex];
        if(event.target.label == 'Open File'){
            if(file.iframelink==undefined)
                file.iframelink = file.webViewLink;
            file.iframeWidth = '100%';
            file.iframeHeight = '500px';
            file.status = 'Close File';
            event.target.variant = 'destructive';
        }else{
            // file.iframelink = '';
             file.iframeWidth = '0';
             file.iframeHeight = '0';
             file.status = 'Open File';
            event.target.variant = 'brand';

        }
    }
    uploadFileToDrive(fileName, fileBlob) {
        console.log('Handle upload to drive');
        // Pass the Blob directly to Apex
        uploadFileToDrive({ fileName: fileName, fileBody: fileBlob })
            .then(result => {
                console.log('File uploaded successfully: ' + result);
                this.fetchData();
            })
            .catch(error => {
                console.error('Error uploading file:', error);
            });
    }
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        if (uploadedFiles.length > 0) {
            const file = uploadedFiles[0];
            const fileBlob = this.convertFileToBlob(file);
    
            if (fileBlob) {
                const reader = new FileReader();
                reader.onload = () => {
                    const fileContent = reader.result.split(',')[1];  // Extract base64 content
                    this.uploadFileToDrive(file.name, fileContent);
                };
                reader.readAsDataURL(fileBlob);
            }
        }
    }
    convertFileToBlob(file) {
        // Convert Salesforce's file object to a Blob (simulating)
        return new Blob([file], { type: file.type });  // Assuming file.type contains the correct MIME type
    }
    
    

}