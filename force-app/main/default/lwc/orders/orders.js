import { LightningElement, api, wire } from 'lwc';

import getSumOrdersByAccount from
    '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

export default class Orders extends LightningElement {
    @api recordId;

    sumOrdersOfCurrentAccount = 0;
    error;

    @wire(getSumOrdersByAccount, {
        accountId: '$recordId'
    })
    wiredOrders({ data, error }) {
        if (data !== undefined) {
            this.sumOrdersOfCurrentAccount = Number(data);
            this.error = undefined;
        } else if (error) {
            this.sumOrdersOfCurrentAccount = 0;
            this.error = error;
        }
    }

    get hasError() {
        return this.error !== undefined;
    }

    get hasActivatedOrders() {
        return (
            !this.hasError &&
            this.sumOrdersOfCurrentAccount > 0
        );
    }
}