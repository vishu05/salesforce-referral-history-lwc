/**
 * @description Fictional seed data for tests/demos. No real person data.
 */
@isTest
public class ReferralTestDataFactory {

    public static Person_Profile__c createPerson(String fullName) {
        Person_Profile__c p = new Person_Profile__c(
            Name = fullName,
            Date_of_Birth__c = Date.today().addYears(-12),
            External_Key__c = 'DEMO-' + fullName.replace(' ', '-').toUpperCase()
        );
        insert p;
        return p;
    }

    public static List<Support_Referral__c> createReferrals(Id personId, Integer count) {
        List<Support_Referral__c> rows = new List<Support_Referral__c>();
        for (Integer i = 0; i < count; i++) {
            rows.add(new Support_Referral__c(
                Person_Profile__c = personId,
                Status__c = (Math.mod(i, 2) == 0 ? 'Open' : 'Closed'),
                Referral_Date__c = Date.today().addDays(-30 * i),
                Source_Organisation__c = 'Harborview Community Services (fictional)'
            ));
        }
        insert rows;
        return rows;
    }
}
