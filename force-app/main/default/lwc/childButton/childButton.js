

import { LightningElement, api } from "lwc";


export default class ChildComponent1 extends LightningElement {
 buttonNotSelected = true;
 @api reset = () => {
   this.buttonNotSelected = true;
 };
 handleClickSelect = (event) => {
   this.buttonNotSelected = false;
   this.dispatchEvent(new CustomEvent("child_selected", { bubbles: true }));
 };
 handleClickDeselect = (event) => {
   this.buttonNotSelected = true;
   this.dispatchEvent(new CustomEvent("child_deselected", { bubbles: true }));
 };
}
