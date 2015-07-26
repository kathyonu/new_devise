# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
CreatePlan.call(stripe_id: 'basic', name: 'Basic', amount: 999, interval: 'month', currency: 'gbp', trial_period_days: 5)
CreatePlan.call(stripe_id: 'standard', name: 'Standard', amount: 2999, interval: 'month', currency: 'gbp', trial_period_days: 5)
CreatePlan.call(stripe_id: 'pro', name: 'Pro', amount: 9999, interval: 'month', currency: 'gbp', trial_period_days: 5)