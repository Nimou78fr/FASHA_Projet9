@IsTest
private class CalculMontantTest {

    @TestSetup
    static void createTestData() {

        Product2 product = new Product2(
            Name = 'Produit montant net',
            IsActive = true
        );
        insert product;

        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pricebookEntry;
    }

    @IsTest
    static void testNetAmountAfterOrderItemInsert() {

        Account testAccount = new Account(
            Name = 'Compte test montant net'
        );
        insert testAccount;

        Order testOrder = new Order(
            AccountId = testAccount.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = Test.getStandardPricebookId(),
            ShipmentCost__c = 20
        );
        insert testOrder;

        PricebookEntry pricebookEntry = [
            SELECT Id
            FROM PricebookEntry
            WHERE Product2.Name = 'Produit montant net'
            LIMIT 1
        ];

        Test.startTest();

        insert new OrderItem(
            OrderId = testOrder.Id,
            PricebookEntryId = pricebookEntry.Id,
            Quantity = 2,
            UnitPrice = 100
        );

        Test.stopTest();

        Order updatedOrder = [
            SELECT
                TotalAmount,
                ShipmentCost__c,
                NetAmount__c
            FROM Order
            WHERE Id = :testOrder.Id
        ];

        System.assertEquals(
            200,
            updatedOrder.TotalAmount,
            'Le montant total doit être égal à 200.'
        );

        System.assertEquals(
            180,
            updatedOrder.NetAmount__c,
            'Le montant net doit être égal à 200 - 20.'
        );
    }

    @IsTest
    static void testNetAmountAfterShipmentCostUpdate() {

        Account testAccount = new Account(
            Name = 'Compte test frais de livraison'
        );
        insert testAccount;

        Order testOrder = new Order(
            AccountId = testAccount.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = Test.getStandardPricebookId(),
            ShipmentCost__c = 50
        );
        insert testOrder;

        Test.startTest();

        testOrder.ShipmentCost__c = 75;
        update testOrder;

        Test.stopTest();

        Order updatedOrder = [
            SELECT
                TotalAmount,
                ShipmentCost__c,
                NetAmount__c
            FROM Order
            WHERE Id = :testOrder.Id
        ];

        Decimal expectedAmount =
            (updatedOrder.TotalAmount == null
                ? 0
                : updatedOrder.TotalAmount)
            - 75;

        System.assertEquals(
            expectedAmount,
            updatedOrder.NetAmount__c,
            'Le montant net doit être recalculé après modification des frais.'
        );
    }
}