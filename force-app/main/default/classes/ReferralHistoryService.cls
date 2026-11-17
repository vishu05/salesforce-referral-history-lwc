/**
 * @description Service layer for referral-history queries.
 *              Demo code with fictional data only.
 */
public with sharing class ReferralHistoryService {

    public class ReferralRow {
        @AuraEnabled public Id referralId;
        @AuraEnabled public String referralNumber;
        @AuraEnabled public String status;
        @AuraEnabled public String programme;
        @AuraEnabled public Date referralDate;
        @AuraEnabled public String sourceOrganisation;
        @AuraEnabled public Integer daysOpen;
        @AuraEnabled public Boolean isRecent;
    }

    public static List<ReferralRow> getHistory(Id personId, String statusFilter, Integer maxRows) {
        Integer limitSize = (maxRows == null || maxRows < 1) ? 50 : Math.min(maxRows, 200);
        List<Support_Referral__c> records = [
            SELECT Id, Name, Status__c, Programme__c, Referral_Date__c, Source_Organisation__c
            FROM Support_Referral__c
            WHERE Person_Profile__c = :personId
            ORDER BY Referral_Date__c DESC NULLS LAST
            LIMIT :limitSize
        ];
        List<ReferralRow> rows = new List<ReferralRow>();
        for (Support_Referral__c r : records) {
            if (String.isNotBlank(statusFilter) && r.Status__c != statusFilter) {
                continue;
            }
            ReferralRow row = new ReferralRow();
            row.referralId = r.Id;
            row.referralNumber = r.Name;
            row.status = r.Status__c;
            row.programme = r.Programme__c;
            row.referralDate = r.Referral_Date__c;
            row.sourceOrganisation = r.Source_Organisation__c;
            row.daysOpen = (r.Referral_Date__c == null) ? null
                : r.Referral_Date__c.daysBetween(Date.today());
            row.isRecent = (row.daysOpen != null && row.daysOpen <= 90);
            rows.add(row);
        }
        return rows;
    }

    public static Integer countPriorReferrals(Id personId, Id excludeReferralId) {
        return [
            SELECT COUNT() FROM Support_Referral__c
            WHERE Person_Profile__c = :personId AND Id != :excludeReferralId
        ];
    }
}
