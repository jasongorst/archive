# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Account.create! email: 'admin@example.com',
                password: 'a_not_very_secret_password',
                admin: true
