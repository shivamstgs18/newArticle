Rails.configuration.stripe = {
  publishable_key: 'pk_test_51NcZYbSGgVwjcnGkqzlaPFknSFLgIhHqqIQLvjbhnqrI0k3I1yWmWPZUdSJABDIJHmJb0xc2imFWWky63fB987zW00eQqQrANI',
  secret_key: 'sk_test_51NcZYbSGgVwjcnGkpvkmMH4RRe7E7Al4NAEQfsUchAFODTUqTryhULARXAEZYmySScEeYft9UKVDd3O6g9XYJzEJ00KEZUvv3n'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
