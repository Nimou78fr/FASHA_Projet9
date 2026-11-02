public with sharing class MyTeamOrdersController {

    @AuraEnabled(cacheable=true)
    public static Decimal getSumOrdersByAccount(
        Id accountId
    ) {
        if (accountId == null) {
            return 0;
        }

        AggregateResult result = [
            SELECT SUM(TotalAmount) totalAmount
            FROM Order
            WHERE AccountId = :accountId
            AND Status = 'Activated'
        ];

        Decimal totalAmount =
            (Decimal) result.get('totalAmount');

        return totalAmount == null
            ? 0
            : totalAmount;
    }
}