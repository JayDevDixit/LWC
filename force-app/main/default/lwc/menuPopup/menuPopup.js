import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ModalComponent extends LightningModal {
    @api options=[];
    handleOptionClick(e){
        const {target} = e;
        const {id} = target.dataset;
        this.close(id);
    }
}