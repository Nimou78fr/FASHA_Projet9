@IsTest
private class testUpdateAllAccounts {

    @IsTest
    static void testBatch() {
        Account acc1 = new Account(
            Name = 'Test Account 1'
        );
        insert acc1;

        Product2 pd1 = new Product2(
            Name = 'Chemise Verte longue XYZ',
            Family = 'Chemise',
            IsActive = true
        );
        insert pd1;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbe;

        Order o1 = new Order(
            AccountId = acc1.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert o1;

        insert new List<OrderItem>{
            new OrderItem(
                OrderId = o1.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 10,
                UnitPrice = 150
            ),
            new OrderItem(
                OrderId = o1.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 20,
                UnitPrice = 1000
            )
        };

        o1.Status = 'Activated';
        update o1;

        Test.startTest();
        Database.executeBatch(new UpdateAllAccounts(), 200);
        Test.stopTest();
        
        Account updatedAccount = [
    SELECT Chiffre_d_affaire__c
    FROM Account
    WHERE Id = :acc1.Id
];

System.assertEquals(
    21500,
    updatedAccount.Chiffre_d_affaire__c,
    'Le batch doit calculer le total des lignes de la commande activée.'
);
    }
}