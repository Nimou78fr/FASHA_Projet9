@IsTest
private class UpdateAccountCATest {

    @IsTest
    static void testMoreThanOneHundredOrders() {

        Account testAccount = new Account(
            Name = 'Compte test volumétrie'
        );
        insert testAccount;

        Id standardPricebookId =
            Test.getStandardPricebookId();

        Product2 product = new Product2(
            Name = 'Produit test volumétrie',
            IsActive = true
        );
        insert product;

        PricebookEntry pricebookEntry =
            new PricebookEntry(
                Pricebook2Id = standardPricebookId,
                Product2Id = product.Id,
                UnitPrice = 100,
                IsActive = true
            );
        insert pricebookEntry;

        List<Order> ordersToInsert =
            new List<Order>();

        for (Integer index = 0; index < 150; index++) {
            ordersToInsert.add(
                new Order(
                    AccountId = testAccount.Id,
                    EffectiveDate = Date.today(),
                    Status = 'Draft',
                    Pricebook2Id = standardPricebookId
                )
            );
        }

        insert ordersToInsert;

        List<OrderItem> itemsToInsert =
            new List<OrderItem>();

        for (Order currentOrder : ordersToInsert) {
            itemsToInsert.add(
                new OrderItem(
                    OrderId = currentOrder.Id,
                    PricebookEntryId = pricebookEntry.Id,
                    Quantity = 1,
                    UnitPrice = 100
                )
            );
        }

        insert itemsToInsert;

        for (Order currentOrder : ordersToInsert) {
            currentOrder.Status = 'Activated';
        }

        Test.startTest();

        update ordersToInsert;

        Test.stopTest();

        Account updatedAccount = [
            SELECT Chiffre_d_affaire__c
            FROM Account
            WHERE Id = :testAccount.Id
        ];

        System.assertEquals(
            15000,
            updatedAccount.Chiffre_d_affaire__c,
            'Le chiffre d’affaires doit inclure les 150 commandes.'
        );
    }
}