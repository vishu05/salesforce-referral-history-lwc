import { LightningElement, api, wire, track } from 'lwc';
import getReferralHistory from '@salesforce/apex/ReferralHistoryController.getReferralHistory';
import getPriorReferralCount from '@salesforce/apex/ReferralHistoryController.getPriorReferralCount';

const COLUMNS = [
    { label: 'Referral', fieldName: 'referralNumber', type: 'text' },
    { label: 'Status', fieldName: 'status', type: 'text' },
    { label: 'Programme', fieldName: 'programme', type: 'text' },
    { label: 'Referral Date', fieldName: 'referralDate', type: 'date' },
    { label: 'Source', fieldName: 'sourceOrganisation', type: 'text' },
    { label: 'Days Open', fieldName: 'daysOpen', type: 'number' }
];

export default class ReferralHistory extends LightningElement {
    @api recordId;
    @api maxRows = 50;
    @track statusFilter = '';
    columns = COLUMNS;
    rows = [];
    priorCount = 0;
    error;

    get isEmpty() { return !this.rows || this.rows.length === 0; }
    get summary() { return `${this.priorCount} prior referral(s) on file`; }

    @wire(getReferralHistory, { personId: '$recordId', statusFilter: '$statusFilter', maxRows: '$maxRows' })
    wiredHistory({ data, error }) {
        if (data) { this.rows = data; this.error = undefined; }
        else if (error) { this.error = error; this.rows = []; }
    }

    @wire(getPriorReferralCount, { personId: '$recordId', referralId: null })
    wiredCount({ data }) { if (data !== undefined) this.priorCount = data; }

    handleStatusChange(event) { this.statusFilter = event.detail.value; }

    get statusOptions() {
        return [
            { label: 'All statuses', value: '' },
            { label: 'Open', value: 'Open' },
            { label: 'Closed', value: 'Closed' }
        ];
    }
}
