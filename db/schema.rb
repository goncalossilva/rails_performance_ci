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

ActiveRecord::Schema.define(:version => 20101006170727) do

  create_table "applications", :force => true do |t|
    t.string   "name",                             :null => false
    t.string   "permalink",                        :null => false
    t.string   "uri",                              :null => false
    t.string   "branch",     :default => "master"
    t.boolean  "public",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commits", :force => true do |t|
    t.string   "sha1",           :null => false
    t.string   "message"
    t.string   "author"
    t.datetime "time"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "result_benchmarks", :force => true do |t|
    t.text     "output",     :default => ""
    t.boolean  "successful", :default => false
    t.float    "total_time"
    t.integer  "commit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "result_methods", :force => true do |t|
    t.string   "name"
    t.integer  "calls"
    t.float    "total_time"
    t.float    "self_time"
    t.integer  "result_thread_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "result_tests", :force => true do |t|
    t.string   "name",                :null => false
    t.float    "total_time"
    t.integer  "result_benchmark_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "result_threads", :force => true do |t|
    t.integer  "thread_id",      :null => false
    t.float    "total_time"
    t.integer  "result_test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
