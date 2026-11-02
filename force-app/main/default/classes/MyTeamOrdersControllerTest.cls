@IsTest
private class MyTeamOrdersControllerTest {

    @IsTest
    static void testActivatedOrdersTotal() {

        Account testAccount = new Account(
            Name = 'Compte test LWC'
        );
        insert testAccount;

        Id standardPricebookId =
            Test.getStandardPricebookId();

        Product2 product = new Product2(
            Name = 'Produit test LWC',
            IsActive = true
        );
        insert product;

        PricebookEntry pricebookEntry =
            new PricebookEntry(
                Pricebook2Id = standardPricebookId,
                Product2Id = product.Id,
                UnitPrice = 250,
                IsActive = true
            );
        insert pricebookEntry;

        Order activatedOrder = new Order(
            AccountId = testAccount.Id,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = standardPricebookId
        );
        insert activatedOrder;

        insert new OrderItem(
            OrderId = activatedOrder.Id,
            PricebookEntryId = pricebookEntry.Id,
            Quantity = 4,
            UnitPrice = 250
        );

        activatedOrder.Status = 'Activated';
        update activatedOrder;

        Test.startTest();

        Decimal result =
            MyTeamOrdersController.getSumOrdersByAccount(
                testAccount.Id
            );

        Test.stopTest();

        System.assertEquals(
            1000,
            result,
            'Le contrôleur doit retourner le total activé du compte.'
        );
    }

    @IsTest
    static void testAccountWithoutActivatedOrder() {

        Account testAccount = new Account(
            Name = 'Compte sans commande activée'
        );
        insert testAccount;

        Test.startTest();

        Decimal result =
            MyTeamOrdersController.getSumOrdersByAccount(
                testAccount.Id
            );

        Test.stopTest();

        System.assertEquals(
            0,
            result,
            'Le contrôleur doit retourner zéro.'
        );
    }

    @IsTest
    static void testNullAccountId() {

        Test.startTest();

        Decimal result =
            MyTeamOrdersController.getSumOrdersByAccount(
                null
            );

        Test.stopTest();

        System.assertEquals(0, result);
    }
}