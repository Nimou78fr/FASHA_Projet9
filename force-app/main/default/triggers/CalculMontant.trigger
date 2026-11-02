trigger CalculMontant on Order (
    before insert,
    before update
) {
    for (Order currentOrder : Trigger.new) {
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
}