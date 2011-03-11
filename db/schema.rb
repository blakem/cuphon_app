# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110311222246) do

  create_table "merchants", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "phone"
    t.string   "company_name"
    t.string   "keyword"
    t.string   "ip_address"
    t.string   "setup_key"
    t.string   "cc_number"
    t.string   "cc_month"
    t.string   "cc_year"
    t.string   "cc_code"
    t.integer  "cc_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twiml_sms_requests", :force => true do |t|
    t.string   "SmsSid"
    t.string   "AccountSid"
    t.string   "From"
    t.string   "To"
    t.string   "Body"
    t.string   "FromCity"
    t.string   "FromState"
    t.string   "FromZip"
    t.string   "FromCountry"
    t.string   "ToCity"
    t.string   "ToState"
    t.string   "ToZip"
    t.string   "ToCountry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "response"
  end

end
