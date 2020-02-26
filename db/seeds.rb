# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create name: 'Default User', username: 'default_user', password: 'password'
shop = Shop.create name: 'Shop 1', shop_type: 'IP', full_address: '123 Nguyen Van Luong', city: 'HCM', district: 'Go Vap'

user.shops.push shop

#auto-gen when user - shop relation established
checklist = user.checklists.first
checklist.reference = '12345'

stock = Stock.create name: 'Stock 1', sku: '123ABC', barcode: '1234567891011', category: 'Testers', group: 'Group 1', role: 'Tester', packaging: 'Paperbag', role_shop: 'IP'
shop.stocks.push stock
checklist.stocks.push stock
