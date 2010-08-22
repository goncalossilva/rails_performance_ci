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

ActiveRecord::Schema.define(:version => 20100822002710) do

  create_table "apps", :force => true do |t|
    t.string   "name",                             :null => false
    t.string   "repository",                       :null => false
    t.string   "frequency",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "benchmark_history", :default => 0
  end

  create_table "perf_benchmarks", :force => true do |t|
    t.float    "total_time"
    t.datetime "date",       :null => false
    t.integer  "app_id",     :null => false
    t.string   "commit"
  end

  create_table "perf_differences", :force => true do |t|
    t.string  "prev_commit",    :null => false
    t.string  "curr_commit",    :null => false
    t.integer "prev_method_id", :null => false
    t.integer "curr_method_id", :null => false
    t.float   "difference",     :null => false
    t.string  "test_name"
  end

  create_table "perf_method_associations", :force => true do |t|
    t.integer "parent_id"
    t.integer "child_id"
  end

  create_table "perf_methods", :force => true do |t|
    t.string  "name",           :null => false
    t.integer "calls"
    t.float   "total_time"
    t.float   "self_time"
    t.integer "perf_thread_id", :null => false
  end

  create_table "perf_tests", :force => true do |t|
    t.string  "name",              :null => false
    t.float   "total_time",        :null => false
    t.integer "perf_benchmark_id", :null => false
  end

  create_table "perf_threads", :force => true do |t|
    t.integer "thread_id",    :null => false
    t.float   "total_time",   :null => false
    t.integer "perf_test_id", :null => false
  end

end
