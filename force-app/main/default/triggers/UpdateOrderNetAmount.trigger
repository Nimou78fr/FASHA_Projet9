trigger UpdateOrderNetAmount on OrderItem (
    after insert,
    after update,
    after delete,
    after undelete
) {

    Set<Id> orderIds = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (OrderItem currentItem : Trigger.new) {
            if (currentItem.OrderId != null) {
                orderIds.add(currentItem.OrderId);
            }
        }
    }

    if (Trigger.isUpdate || Trigger.isDelete) {
        for (OrderItem oldItem : Trigger.old) {
            if (oldItem.OrderId != null) {
                orderIds.add(oldItem.OrderId);
            }
        }
    }

    if (!orderIds.isEmpty()) {
        OrderNetAmountService.updateNetAmounts(orderIds);
    }
}