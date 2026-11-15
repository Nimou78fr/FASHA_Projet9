public with sharing class OrderNetAmountService {

    public static void updateNetAmounts(Set<Id> orderIds) {

        if (orderIds == null || orderIds.isEmpty()) {
            return;
        }

        List<Order> ordersToUpdate = [
            SELECT
                Id,
                TotalAmount,
                ShipmentCost__c,
                NetAmount__c
            FROM Order
            WHERE Id IN :orderIds
        ];

        for (Order currentOrder : ordersToUpdate) {

            Decimal totalAmount =
                currentOrder.TotalAmount == null
                    ? 0
                    : currentOrder.TotalAmount;

            Decimal shipmentCost =
                currentOrder.ShipmentCost__c == null
                    ? 0
                    : currentOrder.ShipmentCost__c;

            currentOrder.NetAmount__c =
                totalAmount - shipmentCost;
        }

        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }
}
