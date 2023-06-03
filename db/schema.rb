# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_28_222542) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name"
    t.string "lastname"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_employees_on_company_id"
  end

  create_table "payrolls", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "period_id", null: false
    t.decimal "salary_income"
    t.decimal "non_salary_income"
    t.decimal "deductions"
    t.decimal "transport_allowance"
    t.decimal "net_pay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "deduction_health"
    t.float "deduction_pension"
    t.float "solidarity_fund"
    t.float "subsistence_account"
    t.float "social_security_health"
    t.float "social_security_pension"
    t.float "arl"
    t.float "compensation_fund"
    t.float "icbf"
    t.float "sena"
    t.float "severance_pay"
    t.float "interest_on_severance_pay"
    t.float "service_bonus"
    t.float "vacation"
    t.float "company_total_cost"
    t.float "salary"
    t.float "total_withholdings_and_deductions"
    t.float "total_social_security"
    t.float "total_parafiscal_contributions"
    t.float "total_social_benefits"
    t.index ["employee_id"], name: "index_payrolls_on_employee_id"
    t.index ["period_id"], name: "index_payrolls_on_period_id"
  end

  create_table "periods", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_periods_on_company_id"
  end

  create_table "salaries", force: :cascade do |t|
    t.decimal "value"
    t.date "start_date"
    t.date "end_date"
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_salaries_on_employee_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "lastname"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "companies", "users"
  add_foreign_key "employees", "companies"
  add_foreign_key "payrolls", "employees"
  add_foreign_key "payrolls", "periods"
  add_foreign_key "periods", "companies"
  add_foreign_key "salaries", "employees"
end
