@isTest
private class ReferralHistoryControllerTest {

    @isTest
    static void returnsHistoryForPerson() {
        Person_Profile__c person = ReferralTestDataFactory.createPerson('Alex Example');
        ReferralTestDataFactory.createReferrals(person.Id, 3);

        Test.startTest();
        List<ReferralHistoryService.ReferralRow> rows =
            ReferralHistoryController.getReferralHistory(person.Id, null, 50);
        Integer priors = ReferralHistoryController.getPriorReferralCount(person.Id, null);
        Test.stopTest();

        System.assertEquals(3, rows.size(), 'Expected 3 referral rows');
        System.assertEquals(3, priors, 'Expected 3 prior referrals');
    }

    @isTest
    static void filtersByStatus() {
        Person_Profile__c person = ReferralTestDataFactory.createPerson('Jamie Example');
        ReferralTestDataFactory.createReferrals(person.Id, 4);

        List<ReferralHistoryService.ReferralRow> openRows =
            ReferralHistoryController.getReferralHistory(person.Id, 'Open', 50);

        for (ReferralHistoryService.ReferralRow r : openRows) {
            System.assertEquals('Open', r.status);
        }
    }

    @isTest
    static void rejectsMissingPerson() {
        Boolean thrown = false;
        try {
            ReferralHistoryController.getReferralHistory(null, null, 10);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        System.assertEquals(true, thrown, 'Expected AuraHandledException');
    }

    @isTest
    static void bulkHistoryQuery() {
        Person_Profile__c person = ReferralTestDataFactory.createPerson('Bulk Example');
        ReferralTestDataFactory.createReferrals(person.Id, 200);
        List<ReferralHistoryService.ReferralRow> rows =
            ReferralHistoryController.getReferralHistory(person.Id, null, 200);
        System.assertEquals(200, rows.size());
    }
}
