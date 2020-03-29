# ruby encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'

user = User.create name: 'Default User', username: 'default_user', password: 'password'
shop = Shop.create name: 'Shop 1', shop_type: 'IP', full_address: '123 Nguyễn Văn Lượng', city: 'HCM', district: 'Gò Vấp'
stock1 = Stock.create name: 'P/S TP KIDS RE0112 120X35G', sku: '21006988', barcode: '1234567891011', category: 'TOOTHPASTE', group: 'ORAL'
stock2 = Stock.create name: 'AXE DEO APOLLO 2X6X150ML', sku: '21018836', barcode: '1234567891012', category: 'DEODORANT', group: 'DEO'

user.shops.push shop

#auto-gen when user - shop relation established
checklist = user.checklists.first
checklist.reference = 'oos template test'
checklist.checklist_type = 'oos'
checklist.save

shop.stocks.push stock1
shop.stocks.push stock2
checklist.stocks.push stock1
checklist.stocks.push stock2
#auto-gen when checklist - stock relation established
citem = checklist.checklist_items.first
citem.data = {
  'no sale' => true,
  'result' => 'not found root cause',
  'mechanics' => 'test mechanics'
}.to_json
citem.save

citem = checklist.checklist_items.last
citem.data = {
  'no sale' => false,
  'result' => 'no gift',
  'mechanics' => ''
}.to_json
citem.save
