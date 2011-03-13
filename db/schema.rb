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

ActiveRecord::Schema.define(:version => 20110313064440) do

  create_table "api_calls", :force => true do |t|
    t.string   "device_id"
    t.string   "call"
    t.text     "response"
    t.text     "payload"
    t.text     "variables"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_cuphons", :force => true do |t|
    t.string   "device_id"
    t.integer  "brand_id"
    t.integer  "campaign_id"
    t.string   "title"
    t.string   "description"
    t.string   "extended"
    t.string   "image_id"
    t.string   "short_url"
    t.datetime "expires_at"
    t.datetime "deleted_at"
    t.datetime "opened_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_discover", :force => true do |t|
    t.string   "title"
    t.integer  "brand_id"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "featured",   :limit => 0
    t.string   "instant",    :limit => 0
  end

  create_table "brands", :force => true do |t|
    t.string   "title"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "featured",    :limit => 0
    t.string   "instant",     :limit => 0
    t.string   "active",      :limit => 0
  end

  create_table "brands_aliases", :force => true do |t|
    t.integer  "brand_id"
    t.string   "alias"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands_campaigns", :force => true do |t|
    t.integer  "brand_id"
    t.string   "title"
    t.string   "description"
    t.text     "extended"
    t.string   "image_id"
    t.datetime "expires_at"
    t.integer  "total_sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands_instant", :force => true do |t|
    t.integer  "brand_id"
    t.string   "title"
    t.string   "description"
    t.text     "extended"
    t.string   "image_id"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_instant_cuphons", :force => true do |t|
    t.string   "device_id"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_merchant_logins", :force => true do |t|
    t.integer  "merchant_id"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "password_resets", :force => true do |t|
    t.string   "forgot_code"
    t.integer  "merchant_id"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "used",        :limit => 0
  end

  create_table "preview_emails", :force => true do |t|
    t.string   "email"
    t.string   "ip_address"
    t.string   "created"
    t.string   "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "short_urls", :force => true do |t|
    t.string   "url"
    t.string   "merchant_title"
    t.string   "unsubscribe_title"
    t.string   "text_1"
    t.string   "text_2"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "opened",            :limit => 0
  end

  create_table "short_urls_log", :force => true do |t|
    t.string   "url"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_incoming", :force => true do |t|
    t.string   "sid"
    t.string   "from"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", :force => true do |t|
    t.string   "device_id"
    t.string   "push_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",       :limit => 0
    t.string   "active",     :limit => 0
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "brand_title"
    t.integer  "brand_id"
    t.string   "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["brand_id"], :name => "index_subscriptions_on_brand_id"
  add_index "subscriptions", ["device_id"], :name => "index_subscriptions_on_device_id"

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

  create_table "twittersquare_data", :force => true do |t|
    t.string   "city"
    t.string   "foursquare_venue_id"
    t.string   "venue_name"
    t.string   "tweet_text"
    t.string   "tweet_id"
    t.string   "state"
    t.string   "twitter_name"
    t.integer  "followers_count"
    t.string   "created"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
