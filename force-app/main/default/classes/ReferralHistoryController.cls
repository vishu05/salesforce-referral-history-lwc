/**
 * @description Aura/LWC controller for the referral-history components.
 */
public with sharing class ReferralHistoryController {

    @AuraEnabled(cacheable=true)
    public static List<ReferralHistoryService.ReferralRow> getReferralHistory(
        Id personId, String statusFilter, Integer maxRows
    ) {
        if (personId == null) {
            throw new AuraHandledException('A person Id is required.');
        }
        return ReferralHistoryService.getHistory(personId, statusFilter, maxRows);
    }

    @AuraEnabled(cacheable=true)
    public static Integer getPriorReferralCount(Id personId, Id referralId) {
        if (personId == null) {
            return 0;
        }
        return ReferralHistoryService.countPriorReferrals(personId, referralId);
    }
}
