import { LightningElement, api } from 'lwc';

export default class ReferralTimeline extends LightningElement {
    @api rows = [];

    get items() {
        return (this.rows || []).map((r) => ({
            id: r.referralId,
            label: `${r.referralNumber} - ${r.status}`,
            detail: `${r.programme || 'General'} | ${r.referralDate || ''} | ${r.sourceOrganisation || ''}`,
            isRecent: r.isRecent
        }));
    }
    get hasItems() { return this.items.length > 0; }
}
