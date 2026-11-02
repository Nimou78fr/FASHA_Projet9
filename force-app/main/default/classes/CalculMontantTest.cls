@IsTest
private class CalculMontantTest {

    @IsTest
    static void testNetAmountOnMultipleOrders() {

        Account testAccount = new Account(
            Name = 'Compte test montant net'
        );
        insert testAccount;

        Id standardPricebookId =
            Test.getStandardPricebookId();

        List<Order> ordersToInsert = new List<Order>();

        for (Integer index = 0; index < 3; index++) {
            ordersToInsert.add(
                new Order(
                    AccountId = testAccount.Id,
                    EffectiveDate = Date.today(),
                    Status = 'Draft',
                    Pricebook2Id = standardPricebookId,
                    ShipmentCost__c = 20
                )
            );
        }

        Test.startTest();

        insert ordersToInsert;

        Test.stopTest();

        List<Order> insertedOrders = [
            SELECT
                Id,
                TotalAmount,
                ShipmentCost__c,
                NetAmount__c
            FROM Order
            WHERE Id IN :ordersToInsert
        ];

        System.assertEquals(
            3,
            insertedOrders.size(),
            'Les trois commandes doivent être traitées.'
        );

        for (Order currentOrder : insertedOrders) {
            System.assertEquals(
                -20,
                currentOrder.NetAmount__c,
                'Le montant net doit être calculé sur chaque commande.'
            );
        }
    }

    @IsTest
    static void testNetAmountAfterOrderUpdate() {

        Account testAccount = new Account(
            Name = 'Compte test mise à jour'
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

        Decimal expectedNetAmount =
            (updatedOrder.TotalAmount == null
                ? 0
                : updatedOrder.TotalAmount)
            -
            (updatedOrder.ShipmentCost__c == null
                ? 0
                : updatedOrder.ShipmentCost__c);

        System.assertEquals(
            expectedNetAmount,
            updatedOrder.NetAmount__c,
            'Le montant net doit être recalculé après modification.'
        );
    }
}