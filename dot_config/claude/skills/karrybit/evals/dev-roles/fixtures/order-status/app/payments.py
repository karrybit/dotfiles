class PaymentGateway:
    """External payment provider. Every call goes over the network and can fail."""

    def charge(self, amount):
        raise NotImplementedError

    def refund(self, payment_id, idempotency_key):
        raise NotImplementedError
