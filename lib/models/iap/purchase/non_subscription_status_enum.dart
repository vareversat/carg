enum NonSubscriptionStatusEnum {
  purchased,
  cancelled,
  pending,
}

NonSubscriptionStatusEnum nonSubscriptionStatusFrom(int? state) {
  switch (state) {
    case 0:
      return NonSubscriptionStatusEnum.purchased;
    case 1:
      return NonSubscriptionStatusEnum.cancelled;
    case 3:
      return NonSubscriptionStatusEnum.pending;
    case null:
    default:
      return NonSubscriptionStatusEnum.cancelled;
  }
}
