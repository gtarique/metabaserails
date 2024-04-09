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

ActiveRecord::Schema[7.1].define(version: 2024_01_30_090852) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "action", id: :integer, default: nil, comment: "An action is something you can do, such as run a readwrite query", force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the action was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp of when the action was updated"
    t.text "type", null: false, comment: "Type of action"
    t.integer "model_id", null: false, comment: "The associated model"
    t.string "name", limit: 254, null: false, comment: "The name of the action"
    t.text "description", comment: "The description of the action"
    t.text "parameters", comment: "The saved parameters for this action"
    t.text "parameter_mappings", comment: "The saved parameter mappings for this action"
    t.text "visualization_settings", comment: "The UI visualization_settings for this action"
    t.string "public_uuid", limit: 36, comment: "Unique UUID used to in publically-accessible links to this Action."
    t.integer "made_public_by_id", comment: "The ID of the User who first publically shared this Action."
    t.integer "creator_id", comment: "The user who created the action"
    t.boolean "archived", default: false, null: false, comment: "Whether or not the action has been archived"
    t.string "entity_id", limit: 21, comment: "Random NanoID tag for unique identity."
    t.index ["creator_id"], name: "idx_action_creator_id"
    t.index ["made_public_by_id"], name: "idx_action_made_public_by_id"
    t.index ["model_id"], name: "idx_action_model_id"
    t.index ["public_uuid"], name: "idx_action_public_uuid"
    t.unique_constraint ["entity_id"], name: "action_entity_id_key"
    t.unique_constraint ["public_uuid"], name: "action_public_uuid_key"
  end

  create_table "activity", id: :integer, default: nil, force: :cascade do |t|
    t.string "topic", limit: 32, null: false
    t.timestamptz "timestamp", null: false
    t.integer "user_id"
    t.string "model", limit: 32
    t.integer "model_id"
    t.integer "database_id"
    t.integer "table_id"
    t.string "custom_id", limit: 48
    t.text "details", null: false
    t.index "(\nCASE\n    WHEN ((model)::text = 'Dataset'::text) THEN ('card_'::text || model_id)\n    WHEN (model_id IS NULL) THEN NULL::text\n    ELSE ((lower((model)::text) || '_'::text) || model_id)\nEND)", name: "idx_activity_entity_qualified_id"
    t.index ["custom_id"], name: "idx_activity_custom_id"
    t.index ["timestamp"], name: "idx_activity_timestamp"
    t.index ["user_id"], name: "idx_activity_user_id"
  end

  create_table "application_permissions_revision", id: :integer, default: nil, force: :cascade do |t|
    t.text "before", null: false
    t.text "after", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.text "remark"
    t.index ["user_id"], name: "idx_application_permissions_revision_user_id"
  end

  create_table "audit_log", id: :integer, default: nil, comment: "Used to store application events for auditing use cases", force: :cascade do |t|
    t.string "topic", limit: 32, null: false, comment: "The topic of a given audit event"
    t.timestamptz "timestamp", null: false, comment: "The time an event was recorded"
    t.timestamptz "end_timestamp", comment: "The time an event ended, if applicable"
    t.integer "user_id", comment: "The user who performed an action or triggered an event"
    t.string "model", limit: 32, comment: "The name of the model this event applies to (e.g. Card, Dashboard), if applicable"
    t.integer "model_id", comment: "The ID of the model this event applies to, if applicable"
    t.text "details", null: false, comment: "A JSON map with metadata about the event"
    t.index "(\nCASE\n    WHEN ((model)::text = 'Dataset'::text) THEN ('card_'::text || model_id)\n    WHEN (model_id IS NULL) THEN NULL::text\n    ELSE ((lower((model)::text) || '_'::text) || model_id)\nEND)", name: "idx_audit_log_entity_qualified_id"
  end

  create_table "bookmark_ordering", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "type", limit: 255, null: false
    t.integer "item_id", null: false
    t.integer "ordering", null: false
    t.index ["user_id"], name: "idx_bookmark_ordering_user_id"
    t.unique_constraint ["user_id", "ordering"], name: "unique_bookmark_user_id_ordering"
    t.unique_constraint ["user_id", "type", "item_id"], name: "unique_bookmark_user_id_type_item_id"
  end

  create_table "card_bookmark", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "card_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.index ["card_id"], name: "idx_card_bookmark_card_id"
    t.index ["user_id"], name: "idx_card_bookmark_user_id"
    t.unique_constraint ["user_id", "card_id"], name: "unique_card_bookmark_user_id_card_id"
  end

  create_table "card_label", id: :integer, default: nil, force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "label_id", null: false
    t.index ["card_id"], name: "idx_card_label_card_id"
    t.index ["label_id"], name: "idx_card_label_label_id"
    t.unique_constraint ["card_id", "label_id"], name: "unique_card_label_card_id_label_id"
  end

  create_table "collection", id: :integer, default: nil, force: :cascade do |t|
    t.text "name", null: false
    t.text "description"
    t.boolean "archived", default: false, null: false
    t.string "location", limit: 254, default: "/", null: false
    t.integer "personal_owner_id"
    t.string "slug", limit: 510, null: false
    t.string "namespace", limit: 254
    t.string "authority_level", limit: 255
    t.string "entity_id", limit: 21
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "Timestamp of when this Collection was created."
    t.string "type", limit: 256, comment: "This is used to differentiate instance-analytics collections from all other collections."
    t.index ["location"], name: "idx_collection_location"
    t.index ["personal_owner_id"], name: "idx_collection_personal_owner_id"
    t.unique_constraint ["entity_id"], name: "collection_entity_id_key"
    t.unique_constraint ["personal_owner_id"], name: "unique_collection_personal_owner_id"
  end

  create_table "collection_bookmark", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "collection_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.index ["collection_id"], name: "idx_collection_bookmark_collection_id"
    t.index ["user_id"], name: "idx_collection_bookmark_user_id"
    t.unique_constraint ["user_id", "collection_id"], name: "unique_collection_bookmark_user_id_collection_id"
  end

  create_table "collection_permission_graph_revision", id: :integer, default: nil, force: :cascade do |t|
    t.text "before", null: false
    t.text "after", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.text "remark"
    t.index ["user_id"], name: "idx_collection_permission_graph_revision_user_id"
  end

  create_table "connection_impersonations", id: :integer, default: nil, comment: "Table for holding connection impersonation policies", force: :cascade do |t|
    t.integer "db_id", null: false, comment: "ID of the database this connection impersonation policy affects"
    t.integer "group_id", null: false, comment: "ID of the permissions group this connection impersonation policy affects"
    t.text "attribute", comment: "User attribute associated with the database role to use for this connection impersonation policy"
    t.index ["db_id"], name: "idx_conn_impersonations_db_id"
    t.index ["group_id"], name: "idx_conn_impersonations_group_id"
    t.unique_constraint ["group_id", "db_id"], name: "conn_impersonation_unique_group_id_db_id"
  end

  create_table "core_session", id: { type: :string, limit: 254 }, force: :cascade do |t|
    t.integer "user_id", null: false
    t.timestamptz "created_at", null: false
    t.text "anti_csrf_token"
    t.index ["user_id"], name: "idx_core_session_user_id"
  end

  create_table "core_user", id: :integer, default: nil, force: :cascade do |t|
    t.citext "email", null: false
    t.string "first_name", limit: 254
    t.string "last_name", limit: 254
    t.string "password", limit: 254
    t.string "password_salt", limit: 254, default: "default"
    t.timestamptz "date_joined", null: false
    t.timestamptz "last_login"
    t.boolean "is_superuser", default: false, null: false
    t.boolean "is_active", default: true, null: false
    t.string "reset_token", limit: 254
    t.bigint "reset_triggered"
    t.boolean "is_qbnewb", default: true, null: false
    t.text "login_attributes"
    t.datetime "updated_at", precision: nil
    t.string "sso_source", limit: 254
    t.string "locale", limit: 5
    t.boolean "is_datasetnewb", default: true, null: false
    t.text "settings"
    t.index "(('user_'::text || id))", name: "idx_user_qualified_id"
    t.index "((((first_name)::text || ' '::text) || (last_name)::text))", name: "idx_user_full_name"
    t.index "lower((email)::text)", name: "idx_lower_email"
    t.unique_constraint ["email"], name: "core_user_email_key"
  end

  create_table "dashboard_bookmark", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "dashboard_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.index ["dashboard_id"], name: "idx_dashboard_bookmark_dashboard_id"
    t.index ["user_id"], name: "idx_dashboard_bookmark_user_id"
    t.unique_constraint ["user_id", "dashboard_id"], name: "unique_dashboard_bookmark_user_id_dashboard_id"
  end

  create_table "dashboard_favorite", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "dashboard_id", null: false
    t.index ["dashboard_id"], name: "idx_dashboard_favorite_dashboard_id"
    t.index ["user_id"], name: "idx_dashboard_favorite_user_id"
    t.unique_constraint ["user_id", "dashboard_id"], name: "unique_dashboard_favorite_user_id_dashboard_id"
  end

  create_table "dashboard_tab", id: :integer, default: nil, comment: "Join table connecting dashboard to dashboardcards", force: :cascade do |t|
    t.integer "dashboard_id", null: false, comment: "The dashboard that a tab is on"
    t.text "name", null: false, comment: "Displayed name of the tab"
    t.integer "position", null: false, comment: "Position of the tab with respect to others tabs in dashboard"
    t.string "entity_id", limit: 21, comment: "Random NanoID tag for unique identity."
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp at which the tab was created"
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "The timestamp at which the tab was last updated"
    t.index ["dashboard_id"], name: "idx_dashboard_tab_dashboard_id"
    t.unique_constraint ["entity_id"], name: "dashboard_tab_entity_id_key"
  end

  create_table "dashboardcard_series", id: :integer, default: nil, force: :cascade do |t|
    t.integer "dashboardcard_id", null: false
    t.integer "card_id", null: false
    t.integer "position", null: false
    t.index ["card_id"], name: "idx_dashboardcard_series_card_id"
    t.index ["dashboardcard_id"], name: "idx_dashboardcard_series_dashboardcard_id"
  end

  create_table "databasechangelog", id: false, force: :cascade do |t|
    t.string "id", limit: 255, null: false
    t.string "author", limit: 255, null: false
    t.string "filename", limit: 255, null: false
    t.datetime "dateexecuted", precision: nil, null: false
    t.integer "orderexecuted", null: false
    t.string "exectype", limit: 10, null: false
    t.string "md5sum", limit: 35
    t.string "description", limit: 255
    t.string "comments", limit: 255
    t.string "tag", limit: 255
    t.string "liquibase", limit: 20
    t.string "contexts", limit: 255
    t.string "labels", limit: 255
    t.string "deployment_id", limit: 10

    t.unique_constraint ["id", "author", "filename"], name: "idx_databasechangelog_id_author_filename"
  end

  create_table "databasechangeloglock", id: :integer, default: nil, force: :cascade do |t|
    t.boolean "locked", null: false
    t.datetime "lockgranted", precision: nil
    t.string "lockedby", limit: 255
  end

  create_table "dependency", id: :integer, default: nil, force: :cascade do |t|
    t.string "model", limit: 32, null: false
    t.integer "model_id", null: false
    t.string "dependent_on_model", limit: 32, null: false
    t.integer "dependent_on_id", null: false
    t.timestamptz "created_at", null: false
    t.index ["dependent_on_id"], name: "idx_dependency_dependent_on_id"
    t.index ["dependent_on_model"], name: "idx_dependency_dependent_on_model"
    t.index ["model"], name: "idx_dependency_model"
    t.index ["model_id"], name: "idx_dependency_model_id"
  end

  create_table "dimension", id: :integer, default: nil, force: :cascade do |t|
    t.integer "field_id", null: false
    t.string "name", limit: 254, null: false
    t.string "type", limit: 254, null: false
    t.integer "human_readable_field_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "entity_id", limit: 21
    t.index ["field_id"], name: "idx_dimension_field_id"
    t.index ["human_readable_field_id"], name: "idx_dimension_human_readable_field_id"
    t.unique_constraint ["entity_id"], name: "dimension_entity_id_key"
    t.unique_constraint ["field_id"], name: "unique_dimension_field_id"
  end

  create_table "http_action", primary_key: "action_id", id: { type: :integer, comment: "The related action", default: nil }, comment: "An http api call type of action", force: :cascade do |t|
    t.text "template", null: false, comment: "A template that defines method,url,body,headers required to make an api call"
    t.text "response_handle", comment: "A program to take an api response and transform to an appropriate response for emitters"
    t.text "error_handle", comment: "A program to take an api response to determine if an error occurred"
  end

  create_table "implicit_action", primary_key: "action_id", id: { type: :integer, comment: "The associated action", default: nil }, comment: "An action with dynamic parameters based on the underlying model", force: :cascade do |t|
    t.text "kind", null: false, comment: "The kind of implicit action create/update/delete"
  end

  create_table "label", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 254, null: false
    t.string "slug", limit: 254, null: false
    t.string "icon", limit: 128
    t.index ["slug"], name: "idx_label_slug"
    t.unique_constraint ["slug"], name: "label_slug_key"
  end

  create_table "login_history", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "timestamp", default: -> { "now()" }, null: false
    t.integer "user_id", null: false
    t.string "session_id", limit: 254
    t.string "device_id", limit: 36, null: false
    t.text "device_description", null: false
    t.text "ip_address", null: false
    t.index ["session_id", "device_id"], name: "idx_user_id_device_id"
    t.index ["session_id"], name: "idx_session_id"
    t.index ["timestamp"], name: "idx_timestamp"
    t.index ["user_id", "timestamp"], name: "idx_user_id_timestamp"
    t.index ["user_id"], name: "idx_user_id"
  end

  create_table "metabase_database", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.text "details", null: false
    t.string "engine", limit: 254, null: false
    t.boolean "is_sample", default: false, null: false
    t.boolean "is_full_sync", default: true, null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.string "metadata_sync_schedule", limit: 254, default: "0 50 * * * ? *", null: false
    t.string "cache_field_values_schedule", limit: 254, default: "0 50 0 * * ? *", null: false
    t.string "timezone", limit: 254
    t.boolean "is_on_demand", default: false, null: false
    t.boolean "auto_run_queries", default: true, null: false
    t.boolean "refingerprint"
    t.integer "cache_ttl"
    t.string "initial_sync_status", limit: 32, default: "complete", null: false
    t.integer "creator_id"
    t.text "settings"
    t.text "dbms_version", comment: "A JSON object describing the flavor and version of the DBMS."
    t.boolean "is_audit", default: false, null: false, comment: "Only the app db, visible to admins via auditing should have this set true."
    t.index ["creator_id"], name: "idx_metabase_database_creator_id"
  end

  create_table "metabase_field", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.string "base_type", limit: 255, null: false
    t.string "semantic_type", limit: 255
    t.boolean "active", default: true, null: false
    t.text "description"
    t.boolean "preview_display", default: true, null: false
    t.integer "position", default: 0, null: false
    t.integer "table_id", null: false
    t.integer "parent_id"
    t.string "display_name", limit: 254
    t.string "visibility_type", limit: 32, default: "normal", null: false
    t.integer "fk_target_field_id"
    t.timestamptz "last_analyzed"
    t.text "points_of_interest"
    t.text "caveats"
    t.text "fingerprint"
    t.integer "fingerprint_version", default: 0, null: false
    t.text "database_type", null: false
    t.text "has_field_values"
    t.text "settings"
    t.integer "database_position", default: 0, null: false
    t.integer "custom_position", default: 0, null: false
    t.string "effective_type", limit: 255
    t.string "coercion_strategy", limit: 255
    t.string "nfc_path", limit: 254
    t.boolean "database_required", default: false, null: false
    t.boolean "json_unfolding", default: false, null: false, comment: "Enable/disable JSON unfolding for a field"
    t.boolean "database_is_auto_increment", default: false, null: false, comment: "Indicates this field is auto incremented"
    t.index "(('field_'::text || id))", name: "idx_field_entity_qualified_id"
    t.index ["parent_id"], name: "idx_field_parent_id"
    t.index ["table_id", "name"], name: "idx_uniq_field_table_id_parent_id_name_2col", unique: true, where: "(parent_id IS NULL)"
    t.index ["table_id"], name: "idx_field_table_id"
    t.unique_constraint ["table_id", "parent_id", "name"], name: "idx_uniq_field_table_id_parent_id_name"
  end

  create_table "metabase_fieldvalues", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.text "values"
    t.text "human_readable_values"
    t.integer "field_id", null: false
    t.boolean "has_more_values", default: false
    t.string "type", limit: 32, default: "full", null: false
    t.text "hash_key"
    t.timestamptz "last_used_at", default: -> { "now()" }, null: false, comment: "Timestamp of when these FieldValues were last used."
    t.index ["field_id"], name: "idx_fieldvalues_field_id"
  end

  create_table "metabase_table", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "name", limit: 256, null: false
    t.text "description"
    t.string "entity_type", limit: 254
    t.boolean "active", null: false
    t.integer "db_id", null: false
    t.string "display_name", limit: 256
    t.string "visibility_type", limit: 254
    t.string "schema", limit: 254
    t.text "points_of_interest"
    t.text "caveats"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "field_order", limit: 254, default: "database", null: false
    t.string "initial_sync_status", limit: 32, default: "complete", null: false
    t.boolean "is_upload", default: false, null: false, comment: "Was the table created from user-uploaded (i.e., from a CSV) data?"
    t.index ["db_id", "name"], name: "idx_uniq_table_db_id_schema_name_2col", unique: true, where: "(schema IS NULL)"
    t.index ["db_id", "schema"], name: "idx_metabase_table_db_id_schema"
    t.index ["db_id"], name: "idx_table_db_id"
    t.index ["show_in_getting_started"], name: "idx_metabase_table_show_in_getting_started"
    t.unique_constraint ["db_id", "schema", "name"], name: "idx_uniq_table_db_id_schema_name"
  end

  create_table "metric", id: :integer, default: nil, force: :cascade do |t|
    t.integer "table_id", null: false
    t.integer "creator_id", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.boolean "archived", default: false, null: false
    t.text "definition", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.text "how_is_this_calculated"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "entity_id", limit: 21
    t.index ["creator_id"], name: "idx_metric_creator_id"
    t.index ["show_in_getting_started"], name: "idx_metric_show_in_getting_started"
    t.index ["table_id"], name: "idx_metric_table_id"
    t.unique_constraint ["entity_id"], name: "metric_entity_id_key"
  end

  create_table "metric_important_field", id: :integer, default: nil, force: :cascade do |t|
    t.integer "metric_id", null: false
    t.integer "field_id", null: false
    t.index ["field_id"], name: "idx_metric_important_field_field_id"
    t.index ["metric_id"], name: "idx_metric_important_field_metric_id"
    t.unique_constraint ["metric_id", "field_id"], name: "unique_metric_important_field_metric_id_field_id"
  end

  create_table "model_index", id: :integer, default: nil, comment: "Used to keep track of which models have indexed columns.", force: :cascade do |t|
    t.integer "model_id", comment: "The ID of the indexed model."
    t.text "pk_ref", null: false, comment: "Serialized JSON of the primary key field ref."
    t.text "value_ref", null: false, comment: "Serialized JSON of the label field ref."
    t.text "schedule", null: false, comment: "The cron schedule for when value syncing should happen."
    t.text "state", null: false, comment: "The status of the index: initializing, indexed, error, overflow."
    t.timestamptz "indexed_at", comment: "When the status changed"
    t.text "error", comment: "The error message if the status is error."
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "The timestamp of when these changes were made."
    t.integer "creator_id", null: false, comment: "ID of the user who created the event"
    t.index ["creator_id"], name: "idx_model_index_creator_id"
    t.index ["model_id"], name: "idx_model_index_model_id"
  end

  create_table "model_index_value", id: false, comment: "Used to keep track of the values indexed in a model", force: :cascade do |t|
    t.integer "model_index_id", comment: "The ID of the indexed model."
    t.integer "model_pk", null: false, comment: "The primary key of the indexed value"
    t.text "name", null: false, comment: "The label to display identifying the indexed value."

    t.unique_constraint ["model_index_id", "model_pk"], name: "unique_model_index_value_model_index_id_model_pk"
  end

  create_table "moderation_review", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.string "status", limit: 255
    t.text "text"
    t.integer "moderated_item_id", null: false
    t.string "moderated_item_type", limit: 255, null: false
    t.integer "moderator_id", null: false
    t.boolean "most_recent", null: false
    t.index ["moderated_item_type", "moderated_item_id"], name: "idx_moderation_review_item_type_item_id"
  end

  create_table "motor_alert_locks", force: :cascade do |t|
    t.bigint "alert_id", null: false
    t.string "lock_timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_id", "lock_timestamp"], name: "index_motor_alert_locks_on_alert_id_and_lock_timestamp", unique: true
    t.index ["alert_id"], name: "index_motor_alert_locks_on_alert_id"
  end

  create_table "motor_alerts", force: :cascade do |t|
    t.bigint "query_id", null: false
    t.string "name", null: false
    t.text "description"
    t.text "to_emails", null: false
    t.boolean "is_enabled", default: true, null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_alerts_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["query_id"], name: "index_motor_alerts_on_query_id"
    t.index ["updated_at"], name: "index_motor_alerts_on_updated_at"
  end

  create_table "motor_api_configs", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.text "preferences", null: false
    t.text "credentials", null: false
    t.text "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_api_configs_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "motor_audits", force: :cascade do |t|
    t.string "auditable_id"
    t.string "auditable_type"
    t.string "associated_id"
    t.string "associated_type"
    t.bigint "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.bigint "version", default: 0
    t.text "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "motor_auditable_associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "motor_auditable_index"
    t.index ["created_at"], name: "index_motor_audits_on_created_at"
    t.index ["request_uuid"], name: "index_motor_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "motor_auditable_user_index"
  end

  create_table "motor_configs", force: :cascade do |t|
    t.string "key", null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_motor_configs_on_key", unique: true
    t.index ["updated_at"], name: "index_motor_configs_on_updated_at"
  end

  create_table "motor_dashboards", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "motor_dashboards_title_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_dashboards_on_updated_at"
  end

  create_table "motor_forms", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "api_path", null: false
    t.string "http_method", null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.string "api_config_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_forms_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_forms_on_updated_at"
  end

  create_table "motor_note_tag_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "note_id", null: false
    t.index ["note_id", "tag_id"], name: "motor_note_tags_note_id_tag_id_index", unique: true
    t.index ["tag_id"], name: "index_motor_note_tag_tags_on_tag_id"
  end

  create_table "motor_note_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_note_tags_name_unique_index", unique: true
  end

  create_table "motor_notes", force: :cascade do |t|
    t.text "body"
    t.bigint "author_id"
    t.string "author_type"
    t.string "record_id", null: false
    t.string "record_type", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id", "author_type"], name: "motor_notes_author_id_author_type_index"
    t.index ["record_id", "record_type"], name: "motor_notes_record_id_record_type_index"
  end

  create_table "motor_notifications", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "recipient_id", null: false
    t.string "recipient_type", null: false
    t.string "record_id"
    t.string "record_type"
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "recipient_type"], name: "motor_notifications_recipient_id_recipient_type_index"
    t.index ["record_id", "record_type"], name: "motor_notifications_record_id_record_type_index"
  end

  create_table "motor_queries", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "sql_body", null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_queries_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_queries_on_updated_at"
  end

  create_table "motor_reminders", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.string "author_type", null: false
    t.bigint "recipient_id", null: false
    t.string "recipient_type", null: false
    t.string "record_id"
    t.string "record_type"
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id", "author_type"], name: "motor_reminders_author_id_author_type_index"
    t.index ["recipient_id", "recipient_type"], name: "motor_reminders_recipient_id_recipient_type_index"
    t.index ["record_id", "record_type"], name: "motor_reminders_record_id_record_type_index"
    t.index ["scheduled_at"], name: "index_motor_reminders_on_scheduled_at"
  end

  create_table "motor_resources", force: :cascade do |t|
    t.string "name", null: false
    t.text "preferences", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_motor_resources_on_name", unique: true
    t.index ["updated_at"], name: "index_motor_resources_on_updated_at"
  end

  create_table "motor_taggable_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "taggable_id", null: false
    t.string "taggable_type", null: false
    t.index ["tag_id"], name: "index_motor_taggable_tags_on_tag_id"
    t.index ["taggable_id", "taggable_type", "tag_id"], name: "motor_polymorphic_association_tag_index", unique: true
  end

  create_table "motor_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_tags_name_unique_index", unique: true
  end

  create_table "native_query_snippet", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 254, null: false
    t.text "description"
    t.text "content", null: false
    t.integer "creator_id", null: false
    t.boolean "archived", default: false, null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.integer "collection_id"
    t.string "entity_id", limit: 21
    t.index ["collection_id"], name: "idx_snippet_collection_id"
    t.index ["creator_id"], name: "idx_native_query_snippet_creator_id"
    t.index ["name"], name: "idx_snippet_name"
    t.unique_constraint ["entity_id"], name: "native_query_snippet_entity_id_key"
    t.unique_constraint ["name"], name: "native_query_snippet_name_key"
  end

  create_table "parameter_card", id: :integer, default: nil, comment: "Join table connecting cards to entities (dashboards, other cards, etc.) that use the values generated by the card for filter values", force: :cascade do |t|
    t.timestamptz "updated_at", default: -> { "now()" }, null: false, comment: "most recent modification time"
    t.timestamptz "created_at", default: -> { "now()" }, null: false, comment: "creation time"
    t.integer "card_id", null: false, comment: "ID of the card generating the values"
    t.string "parameterized_object_type", limit: 32, null: false, comment: "Type of the entity consuming the values (dashboard, card, etc.)"
    t.integer "parameterized_object_id", null: false, comment: "ID of the entity consuming the values"
    t.string "parameter_id", limit: 36, null: false, comment: "The parameter ID"
    t.index ["card_id"], name: "idx_parameter_card_card_id"
    t.index ["parameterized_object_id"], name: "idx_parameter_card_parameterized_object_id"
    t.unique_constraint ["parameterized_object_id", "parameterized_object_type", "parameter_id"], name: "unique_parameterized_object_card_parameter"
  end

  create_table "permissions", id: :integer, default: nil, force: :cascade do |t|
    t.string "object", limit: 254, null: false
    t.integer "group_id", null: false
    t.index ["group_id", "object"], name: "idx_permissions_group_id_object"
    t.index ["group_id"], name: "idx_permissions_group_id"
    t.index ["object"], name: "idx_permissions_object"
    t.unique_constraint ["group_id", "object"], name: "permissions_group_id_object_key"
  end

  create_table "permissions_group", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.index ["name"], name: "idx_permissions_group_name"
    t.unique_constraint ["name"], name: "unique_permissions_group_name"
  end

  create_table "permissions_group_membership", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.boolean "is_group_manager", default: false, null: false
    t.index ["group_id", "user_id"], name: "idx_permissions_group_membership_group_id_user_id"
    t.index ["group_id"], name: "idx_permissions_group_membership_group_id"
    t.index ["user_id"], name: "idx_permissions_group_membership_user_id"
    t.unique_constraint ["user_id", "group_id"], name: "unique_permissions_group_membership_user_id_group_id"
  end

  create_table "permissions_revision", id: :integer, default: nil, force: :cascade do |t|
    t.text "before", null: false
    t.text "after", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.text "remark"
    t.index ["user_id"], name: "idx_permissions_revision_user_id"
  end

  create_table "persisted_info", id: :integer, default: nil, force: :cascade do |t|
    t.integer "database_id", null: false
    t.integer "card_id", null: false
    t.text "question_slug", null: false
    t.text "table_name", null: false
    t.text "definition"
    t.text "query_hash"
    t.boolean "active", default: false, null: false
    t.text "state", null: false
    t.timestamptz "refresh_begin", null: false
    t.timestamptz "refresh_end"
    t.timestamptz "state_change_at"
    t.text "error"
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.integer "creator_id"
    t.index ["creator_id"], name: "idx_persisted_info_creator_id"
    t.index ["database_id"], name: "idx_persisted_info_database_id"
    t.unique_constraint ["card_id"], name: "persisted_info_card_id_key"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pulse", id: :integer, default: nil, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.string "name", limit: 254
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.boolean "skip_if_empty", default: false, null: false
    t.string "alert_condition", limit: 254
    t.boolean "alert_first_only"
    t.boolean "alert_above_goal"
    t.integer "collection_id"
    t.integer "collection_position", limit: 2
    t.boolean "archived", default: false
    t.integer "dashboard_id"
    t.text "parameters", null: false
    t.string "entity_id", limit: 21
    t.index ["collection_id"], name: "idx_pulse_collection_id"
    t.index ["creator_id"], name: "idx_pulse_creator_id"
    t.index ["dashboard_id"], name: "idx_pulse_dashboard_id"
    t.unique_constraint ["entity_id"], name: "pulse_entity_id_key"
  end

  create_table "pulse_card", id: :integer, default: nil, force: :cascade do |t|
    t.integer "pulse_id", null: false
    t.integer "card_id", null: false
    t.integer "position", null: false
    t.boolean "include_csv", default: false, null: false
    t.boolean "include_xls", default: false, null: false
    t.integer "dashboard_card_id"
    t.string "entity_id", limit: 21
    t.index ["card_id"], name: "idx_pulse_card_card_id"
    t.index ["dashboard_card_id"], name: "idx_pulse_card_dashboard_card_id"
    t.index ["pulse_id"], name: "idx_pulse_card_pulse_id"
    t.unique_constraint ["entity_id"], name: "pulse_card_entity_id_key"
  end

  create_table "pulse_channel", id: :integer, default: nil, force: :cascade do |t|
    t.integer "pulse_id", null: false
    t.string "channel_type", limit: 32, null: false
    t.text "details", null: false
    t.string "schedule_type", limit: 32, null: false
    t.integer "schedule_hour"
    t.string "schedule_day", limit: 64
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "schedule_frame", limit: 32
    t.boolean "enabled", default: true, null: false
    t.string "entity_id", limit: 21
    t.index ["pulse_id"], name: "idx_pulse_channel_pulse_id"
    t.index ["schedule_type"], name: "idx_pulse_channel_schedule_type"
    t.unique_constraint ["entity_id"], name: "pulse_channel_entity_id_key"
  end

  create_table "pulse_channel_recipient", id: :integer, default: nil, force: :cascade do |t|
    t.integer "pulse_channel_id", null: false
    t.integer "user_id", null: false
    t.index ["pulse_channel_id"], name: "idx_pulse_channel_recipient_pulse_channel_id"
    t.index ["user_id"], name: "idx_pulse_channel_recipient_user_id"
  end

  create_table "qrtz_blob_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.binary "blob_data"
  end

  create_table "qrtz_calendars", primary_key: ["sched_name", "calendar_name"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "calendar_name", limit: 200, null: false
    t.binary "calendar", null: false
  end

  create_table "qrtz_cron_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "cron_expression", limit: 120, null: false
    t.string "time_zone_id", limit: 80
  end

  create_table "qrtz_fired_triggers", primary_key: ["sched_name", "entry_id"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "entry_id", limit: 95, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "instance_name", limit: 200, null: false
    t.bigint "fired_time", null: false
    t.bigint "sched_time"
    t.integer "priority", null: false
    t.string "state", limit: 16, null: false
    t.string "job_name", limit: 200
    t.string "job_group", limit: 200
    t.boolean "is_nonconcurrent"
    t.boolean "requests_recovery"
    t.index ["sched_name", "instance_name", "requests_recovery"], name: "idx_qrtz_ft_inst_job_req_rcvry"
    t.index ["sched_name", "instance_name"], name: "idx_qrtz_ft_trig_inst_name"
    t.index ["sched_name", "job_group"], name: "idx_qrtz_ft_jg"
    t.index ["sched_name", "job_name", "job_group"], name: "idx_qrtz_ft_j_g"
    t.index ["sched_name", "trigger_group"], name: "idx_qrtz_ft_tg"
    t.index ["sched_name", "trigger_name", "trigger_group"], name: "idx_qrtz_ft_t_g"
  end

  create_table "qrtz_job_details", primary_key: ["sched_name", "job_name", "job_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "job_name", limit: 200, null: false
    t.string "job_group", limit: 200, null: false
    t.string "description", limit: 250
    t.string "job_class_name", limit: 250, null: false
    t.boolean "is_durable", null: false
    t.boolean "is_nonconcurrent", null: false
    t.boolean "is_update_data", null: false
    t.boolean "requests_recovery", null: false
    t.binary "job_data"
    t.index ["sched_name", "job_group"], name: "idx_qrtz_j_grp"
    t.index ["sched_name", "requests_recovery"], name: "idx_qrtz_j_req_recovery"
  end

  create_table "qrtz_locks", primary_key: ["sched_name", "lock_name"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "lock_name", limit: 40, null: false
  end

  create_table "qrtz_paused_trigger_grps", primary_key: ["sched_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_group", limit: 200, null: false
  end

  create_table "qrtz_scheduler_state", primary_key: ["sched_name", "instance_name"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "instance_name", limit: 200, null: false
    t.bigint "last_checkin_time", null: false
    t.bigint "checkin_interval", null: false
  end

  create_table "qrtz_simple_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.bigint "repeat_count", null: false
    t.bigint "repeat_interval", null: false
    t.bigint "times_triggered", null: false
  end

  create_table "qrtz_simprop_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "str_prop_1", limit: 512
    t.string "str_prop_2", limit: 512
    t.string "str_prop_3", limit: 512
    t.integer "int_prop_1"
    t.integer "int_prop_2"
    t.bigint "long_prop_1"
    t.bigint "long_prop_2"
    t.decimal "dec_prop_1", precision: 13, scale: 4
    t.decimal "dec_prop_2", precision: 13, scale: 4
    t.boolean "bool_prop_1"
    t.boolean "bool_prop_2"
  end

  create_table "qrtz_triggers", primary_key: ["sched_name", "trigger_name", "trigger_group"], force: :cascade do |t|
    t.string "sched_name", limit: 120, null: false
    t.string "trigger_name", limit: 200, null: false
    t.string "trigger_group", limit: 200, null: false
    t.string "job_name", limit: 200, null: false
    t.string "job_group", limit: 200, null: false
    t.string "description", limit: 250
    t.bigint "next_fire_time"
    t.bigint "prev_fire_time"
    t.integer "priority"
    t.string "trigger_state", limit: 16, null: false
    t.string "trigger_type", limit: 8, null: false
    t.bigint "start_time", null: false
    t.bigint "end_time"
    t.string "calendar_name", limit: 200
    t.integer "misfire_instr", limit: 2
    t.binary "job_data"
    t.index ["sched_name", "calendar_name"], name: "idx_qrtz_t_c"
    t.index ["sched_name", "job_group"], name: "idx_qrtz_t_jg"
    t.index ["sched_name", "job_name", "job_group"], name: "idx_qrtz_t_j"
    t.index ["sched_name", "misfire_instr", "next_fire_time", "trigger_group", "trigger_state"], name: "idx_qrtz_t_nft_st_misfire_grp"
    t.index ["sched_name", "misfire_instr", "next_fire_time", "trigger_state"], name: "idx_qrtz_t_nft_st_misfire"
    t.index ["sched_name", "misfire_instr", "next_fire_time"], name: "idx_qrtz_t_nft_misfire"
    t.index ["sched_name", "next_fire_time"], name: "idx_qrtz_t_next_fire_time"
    t.index ["sched_name", "trigger_group", "trigger_state"], name: "idx_qrtz_t_n_g_state"
    t.index ["sched_name", "trigger_group"], name: "idx_qrtz_t_g"
    t.index ["sched_name", "trigger_name", "trigger_group", "trigger_state"], name: "idx_qrtz_t_n_state"
    t.index ["sched_name", "trigger_state", "next_fire_time"], name: "idx_qrtz_t_nft_st"
    t.index ["sched_name", "trigger_state"], name: "idx_qrtz_t_state"
  end

  create_table "query", primary_key: "query_hash", id: :binary, force: :cascade do |t|
    t.integer "average_execution_time", null: false
    t.text "query"
  end

  create_table "query_action", primary_key: "action_id", id: { type: :integer, comment: "The related action", default: nil }, comment: "A readwrite query type of action", force: :cascade do |t|
    t.integer "database_id", null: false, comment: "The associated database"
    t.text "dataset_query", null: false, comment: "The MBQL writeback query"
    t.index ["database_id"], name: "idx_query_action_database_id"
  end

  create_table "query_cache", primary_key: "query_hash", id: :binary, force: :cascade do |t|
    t.timestamptz "updated_at", null: false
    t.binary "results", null: false
    t.index ["updated_at"], name: "idx_query_cache_updated_at"
  end

  create_table "query_execution", id: :integer, default: nil, force: :cascade do |t|
    t.binary "hash", null: false
    t.timestamptz "started_at", null: false
    t.integer "running_time", null: false
    t.integer "result_rows", null: false
    t.boolean "native", null: false
    t.string "context", limit: 32
    t.text "error"
    t.integer "executor_id"
    t.integer "card_id"
    t.integer "dashboard_id"
    t.integer "pulse_id"
    t.integer "database_id"
    t.boolean "cache_hit"
    t.integer "action_id", comment: "The ID of the action associated with this query execution, if any."
    t.boolean "is_sandboxed", comment: "Is query from a sandboxed user"
    t.binary "cache_hash", comment: "Hash of normalized query, calculated in middleware.cache"
    t.index "(('card_'::text || card_id))", name: "idx_query_execution_card_qualified_id"
    t.index ["action_id"], name: "idx_query_execution_action_id"
    t.index ["card_id", "started_at"], name: "idx_query_execution_card_id_started_at"
    t.index ["card_id"], name: "idx_query_execution_card_id"
    t.index ["context"], name: "idx_query_execution_context"
    t.index ["executor_id"], name: "idx_query_execution_executor_id"
    t.index ["hash", "started_at"], name: "idx_query_execution_query_hash_started_at"
    t.index ["started_at"], name: "idx_query_execution_started_at"
  end

  create_table "recent_views", id: :integer, default: nil, comment: "Used to store recently viewed objects for each user", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "The user associated with this view"
    t.string "model", limit: 16, null: false, comment: "The name of the model that was viewed"
    t.integer "model_id", null: false, comment: "The ID of the model that was viewed"
    t.datetime "timestamp", precision: nil, null: false, comment: "The time a view was recorded"
    t.index ["user_id"], name: "idx_recent_views_user_id"
  end

  create_table "report_card", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.string "display", limit: 254, null: false
    t.text "dataset_query", null: false
    t.text "visualization_settings", null: false
    t.integer "creator_id", null: false
    t.integer "database_id", null: false
    t.integer "table_id"
    t.string "query_type", limit: 16
    t.boolean "archived", default: false, null: false
    t.integer "collection_id"
    t.string "public_uuid", limit: 36
    t.integer "made_public_by_id"
    t.boolean "enable_embedding", default: false, null: false
    t.text "embedding_params"
    t.integer "cache_ttl"
    t.text "result_metadata"
    t.integer "collection_position", limit: 2
    t.boolean "dataset", default: false, null: false
    t.string "entity_id", limit: 21
    t.text "parameters"
    t.text "parameter_mappings"
    t.boolean "collection_preview", default: true, null: false
    t.string "metabase_version", limit: 100, comment: "Metabase version used to create the card."
    t.index ["collection_id"], name: "idx_card_collection_id"
    t.index ["creator_id"], name: "idx_card_creator_id"
    t.index ["database_id"], name: "idx_report_card_database_id"
    t.index ["made_public_by_id"], name: "idx_report_card_made_public_by_id"
    t.index ["public_uuid"], name: "idx_card_public_uuid"
    t.index ["table_id"], name: "idx_report_card_table_id"
    t.unique_constraint ["entity_id"], name: "report_card_entity_id_key"
    t.unique_constraint ["public_uuid"], name: "report_card_public_uuid_key"
  end

  create_table "report_cardfavorite", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.integer "card_id", null: false
    t.integer "owner_id", null: false
    t.index ["card_id"], name: "idx_cardfavorite_card_id"
    t.index ["owner_id"], name: "idx_cardfavorite_owner_id"
    t.unique_constraint ["card_id", "owner_id"], name: "idx_unique_cardfavorite_card_id_owner_id"
  end

  create_table "report_dashboard", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.integer "creator_id", null: false
    t.text "parameters", null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "public_uuid", limit: 36
    t.integer "made_public_by_id"
    t.boolean "enable_embedding", default: false, null: false
    t.text "embedding_params"
    t.boolean "archived", default: false, null: false
    t.integer "position"
    t.integer "collection_id"
    t.integer "collection_position", limit: 2
    t.integer "cache_ttl"
    t.string "entity_id", limit: 21
    t.boolean "auto_apply_filters", default: true, null: false, comment: "Whether or not to auto-apply filters on a dashboard"
    t.index ["collection_id"], name: "idx_dashboard_collection_id"
    t.index ["creator_id"], name: "idx_dashboard_creator_id"
    t.index ["made_public_by_id"], name: "idx_report_dashboard_made_public_by_id"
    t.index ["public_uuid"], name: "idx_dashboard_public_uuid"
    t.index ["show_in_getting_started"], name: "idx_report_dashboard_show_in_getting_started"
    t.unique_constraint ["entity_id"], name: "report_dashboard_entity_id_key"
    t.unique_constraint ["public_uuid"], name: "report_dashboard_public_uuid_key"
  end

  create_table "report_dashboardcard", id: :integer, default: nil, force: :cascade do |t|
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.integer "size_x", null: false
    t.integer "size_y", null: false
    t.integer "row", null: false
    t.integer "col", null: false
    t.integer "card_id"
    t.integer "dashboard_id", null: false
    t.text "parameter_mappings", null: false
    t.text "visualization_settings", null: false
    t.string "entity_id", limit: 21
    t.integer "action_id", comment: "The related action"
    t.integer "dashboard_tab_id", comment: "The referenced tab id that dashcard is on, it's nullable for dashboard with no tab"
    t.index ["action_id"], name: "idx_report_dashboardcard_action_id"
    t.index ["card_id"], name: "idx_dashboardcard_card_id"
    t.index ["dashboard_id"], name: "idx_dashboardcard_dashboard_id"
    t.index ["dashboard_tab_id"], name: "idx_report_dashboardcard_dashboard_tab_id"
    t.unique_constraint ["entity_id"], name: "report_dashboardcard_entity_id_key"
  end

  create_table "revision", id: :integer, default: nil, force: :cascade do |t|
    t.string "model", limit: 16, null: false
    t.integer "model_id", null: false
    t.integer "user_id", null: false
    t.timestamptz "timestamp", null: false
    t.text "object", null: false
    t.boolean "is_reversion", default: false, null: false
    t.boolean "is_creation", default: false, null: false
    t.text "message"
    t.boolean "most_recent", default: false, null: false, comment: "Whether a revision is the most recent one"
    t.string "metabase_version", limit: 100, comment: "Metabase version used to create the revision."
    t.index ["model", "model_id"], name: "idx_revision_model_model_id"
    t.index ["most_recent"], name: "idx_revision_most_recent"
    t.index ["user_id"], name: "idx_revision_user_id"
  end

  create_table "sandboxes", id: :integer, default: nil, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "table_id", null: false
    t.integer "card_id"
    t.text "attribute_remappings"
    t.integer "permission_id", comment: "The ID of the corresponding permissions path for this sandbox"
    t.index ["card_id"], name: "idx_sandboxes_card_id"
    t.index ["permission_id"], name: "idx_sandboxes_permission_id"
    t.index ["table_id", "group_id"], name: "idx_gtap_table_id_group_id"
    t.unique_constraint ["table_id", "group_id"], name: "unique_gtap_table_id_group_id"
  end

  create_table "secret", primary_key: ["id", "version"], force: :cascade do |t|
    t.integer "id", null: false
    t.integer "version", default: 1, null: false
    t.integer "creator_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at"
    t.string "name", limit: 254, null: false
    t.string "kind", limit: 254, null: false
    t.string "source", limit: 254
    t.binary "value", null: false
    t.index ["creator_id"], name: "idx_secret_creator_id"
  end

  create_table "segment", id: :integer, default: nil, force: :cascade do |t|
    t.integer "table_id", null: false
    t.integer "creator_id", null: false
    t.string "name", limit: 254, null: false
    t.text "description"
    t.boolean "archived", default: false, null: false
    t.text "definition", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.text "points_of_interest"
    t.text "caveats"
    t.boolean "show_in_getting_started", default: false, null: false
    t.string "entity_id", limit: 21
    t.index ["creator_id"], name: "idx_segment_creator_id"
    t.index ["show_in_getting_started"], name: "idx_segment_show_in_getting_started"
    t.index ["table_id"], name: "idx_segment_table_id"
    t.unique_constraint ["entity_id"], name: "segment_entity_id_key"
  end

  create_table "setting", primary_key: "key", id: { type: :string, limit: 254 }, force: :cascade do |t|
    t.text "value", null: false
  end

  create_table "table_privileges", id: false, comment: "Table for user and role privileges by table", force: :cascade do |t|
    t.integer "table_id", null: false, comment: "Table ID"
    t.string "role", limit: 255, comment: "Role name. NULL indicates the privileges are the current user's"
    t.boolean "select", default: false, null: false, comment: "Privilege to select from the table"
    t.boolean "update", default: false, null: false, comment: "Privilege to update records in the table"
    t.boolean "insert", default: false, null: false, comment: "Privilege to insert records into the table"
    t.boolean "delete", default: false, null: false, comment: "Privilege to delete records from the table"
    t.index ["role"], name: "idx_table_privileges_role"
    t.index ["table_id"], name: "idx_table_privileges_table_id"
  end

  create_table "task_history", id: :integer, default: nil, force: :cascade do |t|
    t.string "task", limit: 254, null: false
    t.integer "db_id"
    t.timestamptz "started_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamptz "ended_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "duration", null: false
    t.text "task_details"
    t.index ["db_id"], name: "idx_task_history_db_id"
    t.index ["ended_at"], name: "idx_task_history_end_time"
    t.index ["started_at"], name: "idx_task_history_started_at"
  end

  create_table "timeline", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "description", limit: 255
    t.string "icon", limit: 128, null: false
    t.integer "collection_id"
    t.boolean "archived", default: false, null: false
    t.integer "creator_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.boolean "default", default: false, null: false
    t.string "entity_id", limit: 21
    t.index ["collection_id"], name: "idx_timeline_collection_id"
    t.index ["creator_id"], name: "idx_timeline_creator_id"
    t.unique_constraint ["entity_id"], name: "timeline_entity_id_key"
  end

  create_table "timeline_event", id: :integer, default: nil, force: :cascade do |t|
    t.integer "timeline_id", null: false
    t.string "name", limit: 255, null: false
    t.string "description", limit: 255
    t.timestamptz "timestamp", null: false
    t.boolean "time_matters", null: false
    t.string "timezone", limit: 255, null: false
    t.string "icon", limit: 128, null: false
    t.boolean "archived", default: false, null: false
    t.integer "creator_id", null: false
    t.timestamptz "created_at", default: -> { "now()" }, null: false
    t.timestamptz "updated_at", default: -> { "now()" }, null: false
    t.index ["creator_id"], name: "idx_timeline_event_creator_id"
    t.index ["timeline_id", "timestamp"], name: "idx_timeline_event_timeline_id_timestamp"
    t.index ["timeline_id"], name: "idx_timeline_event_timeline_id"
  end

  create_table "view_log", id: :integer, default: nil, force: :cascade do |t|
    t.integer "user_id"
    t.string "model", limit: 16, null: false
    t.integer "model_id", null: false
    t.timestamptz "timestamp", null: false
    t.text "metadata"
    t.boolean "has_access", comment: "Whether the user who initiated the view had read access to the item being viewed."
    t.string "context", limit: 32, comment: "The context of the view, can be collection, question, or dashboard. Only for cards."
    t.index "((((model)::text || '_'::text) || model_id))", name: "idx_view_log_entity_qualified_id"
    t.index ["model_id"], name: "idx_view_log_model_id"
    t.index ["timestamp"], name: "idx_view_log_timestamp"
    t.index ["user_id"], name: "idx_view_log_user_id"
  end

  add_foreign_key "action", "core_user", column: "creator_id", name: "fk_action_creator_id"
  add_foreign_key "action", "core_user", column: "made_public_by_id", name: "fk_action_made_public_by_id", on_delete: :cascade
  add_foreign_key "action", "report_card", column: "model_id", name: "fk_action_model_id", on_delete: :cascade
  add_foreign_key "activity", "core_user", column: "user_id", name: "fk_activity_ref_user_id", on_delete: :cascade
  add_foreign_key "application_permissions_revision", "core_user", column: "user_id", name: "fk_general_permissions_revision_user_id"
  add_foreign_key "bookmark_ordering", "core_user", column: "user_id", name: "fk_bookmark_ordering_user_id", on_delete: :cascade
  add_foreign_key "card_bookmark", "core_user", column: "user_id", name: "fk_card_bookmark_user_id", on_delete: :cascade
  add_foreign_key "card_bookmark", "report_card", column: "card_id", name: "fk_card_bookmark_dashboard_id", on_delete: :cascade
  add_foreign_key "card_label", "label", name: "fk_card_label_ref_label_id", on_delete: :cascade
  add_foreign_key "card_label", "report_card", column: "card_id", name: "fk_card_label_ref_card_id", on_delete: :cascade
  add_foreign_key "collection", "core_user", column: "personal_owner_id", name: "fk_collection_personal_owner_id", on_delete: :cascade
  add_foreign_key "collection_bookmark", "collection", name: "fk_collection_bookmark_collection_id", on_delete: :cascade
  add_foreign_key "collection_bookmark", "core_user", column: "user_id", name: "fk_collection_bookmark_user_id", on_delete: :cascade
  add_foreign_key "collection_permission_graph_revision", "core_user", column: "user_id", name: "fk_collection_revision_user_id", on_delete: :cascade
  add_foreign_key "connection_impersonations", "metabase_database", column: "db_id", name: "fk_conn_impersonation_db_id", on_delete: :cascade
  add_foreign_key "connection_impersonations", "permissions_group", column: "group_id", name: "fk_conn_impersonation_group_id", on_delete: :cascade
  add_foreign_key "core_session", "core_user", column: "user_id", name: "fk_session_ref_user_id", on_delete: :cascade
  add_foreign_key "dashboard_bookmark", "core_user", column: "user_id", name: "fk_dashboard_bookmark_user_id", on_delete: :cascade
  add_foreign_key "dashboard_bookmark", "report_dashboard", column: "dashboard_id", name: "fk_dashboard_bookmark_dashboard_id", on_delete: :cascade
  add_foreign_key "dashboard_favorite", "core_user", column: "user_id", name: "fk_dashboard_favorite_user_id", on_delete: :cascade
  add_foreign_key "dashboard_favorite", "report_dashboard", column: "dashboard_id", name: "fk_dashboard_favorite_dashboard_id", on_delete: :cascade
  add_foreign_key "dashboard_tab", "report_dashboard", column: "dashboard_id", name: "fk_dashboard_tab_ref_dashboard_id", on_delete: :cascade
  add_foreign_key "dashboardcard_series", "report_card", column: "card_id", name: "fk_dashboardcard_series_ref_card_id", on_delete: :cascade
  add_foreign_key "dashboardcard_series", "report_dashboardcard", column: "dashboardcard_id", name: "fk_dashboardcard_series_ref_dashboardcard_id", on_delete: :cascade
  add_foreign_key "dimension", "metabase_field", column: "field_id", name: "fk_dimension_ref_field_id", on_delete: :cascade
  add_foreign_key "dimension", "metabase_field", column: "human_readable_field_id", name: "fk_dimension_displayfk_ref_field_id", on_delete: :cascade
  add_foreign_key "http_action", "action", name: "fk_http_action_ref_action_id", on_delete: :cascade
  add_foreign_key "implicit_action", "action", name: "fk_implicit_action_action_id", on_delete: :cascade
  add_foreign_key "login_history", "core_session", column: "session_id", name: "fk_login_history_session_id", on_delete: :nullify
  add_foreign_key "login_history", "core_user", column: "user_id", name: "fk_login_history_user_id", on_delete: :cascade
  add_foreign_key "metabase_database", "core_user", column: "creator_id", name: "fk_database_creator_id", on_delete: :nullify
  add_foreign_key "metabase_field", "metabase_field", column: "parent_id", name: "fk_field_parent_ref_field_id", on_delete: :cascade
  add_foreign_key "metabase_field", "metabase_table", column: "table_id", name: "fk_field_ref_table_id", on_delete: :cascade
  add_foreign_key "metabase_fieldvalues", "metabase_field", column: "field_id", name: "fk_fieldvalues_ref_field_id", on_delete: :cascade
  add_foreign_key "metabase_table", "metabase_database", column: "db_id", name: "fk_table_ref_database_id", on_delete: :cascade
  add_foreign_key "metric", "core_user", column: "creator_id", name: "fk_metric_ref_creator_id", on_delete: :cascade
  add_foreign_key "metric", "metabase_table", column: "table_id", name: "fk_metric_ref_table_id", on_delete: :cascade
  add_foreign_key "metric_important_field", "metabase_field", column: "field_id", name: "fk_metric_important_field_metabase_field_id", on_delete: :cascade
  add_foreign_key "metric_important_field", "metric", name: "fk_metric_important_field_metric_id", on_delete: :cascade
  add_foreign_key "model_index", "core_user", column: "creator_id", name: "fk_model_index_creator_id", on_delete: :cascade
  add_foreign_key "model_index", "report_card", column: "model_id", name: "fk_model_index_model_id", on_delete: :cascade
  add_foreign_key "model_index_value", "model_index", name: "fk_model_index_value_model_id", on_delete: :cascade
  add_foreign_key "motor_alert_locks", "motor_alerts", column: "alert_id"
  add_foreign_key "motor_alerts", "motor_queries", column: "query_id"
  add_foreign_key "motor_note_tag_tags", "motor_note_tags", column: "tag_id"
  add_foreign_key "motor_note_tag_tags", "motor_notes", column: "note_id"
  add_foreign_key "motor_taggable_tags", "motor_tags", column: "tag_id"
  add_foreign_key "native_query_snippet", "collection", name: "fk_snippet_collection_id", on_delete: :nullify
  add_foreign_key "native_query_snippet", "core_user", column: "creator_id", name: "fk_snippet_creator_id", on_delete: :cascade
  add_foreign_key "parameter_card", "report_card", column: "card_id", name: "fk_parameter_card_ref_card_id", on_delete: :cascade
  add_foreign_key "permissions", "permissions_group", column: "group_id", name: "fk_permissions_group_id", on_delete: :cascade
  add_foreign_key "permissions_group_membership", "core_user", column: "user_id", name: "fk_permissions_group_membership_user_id", on_delete: :cascade
  add_foreign_key "permissions_group_membership", "permissions_group", column: "group_id", name: "fk_permissions_group_group_id", on_delete: :cascade
  add_foreign_key "permissions_revision", "core_user", column: "user_id", name: "fk_permissions_revision_user_id", on_delete: :cascade
  add_foreign_key "persisted_info", "core_user", column: "creator_id", name: "fk_persisted_info_ref_creator_id"
  add_foreign_key "persisted_info", "metabase_database", column: "database_id", name: "fk_persisted_info_database_id", on_delete: :cascade
  add_foreign_key "persisted_info", "report_card", column: "card_id", name: "fk_persisted_info_card_id", on_delete: :cascade
  add_foreign_key "pulse", "collection", name: "fk_pulse_collection_id", on_delete: :nullify
  add_foreign_key "pulse", "core_user", column: "creator_id", name: "fk_pulse_ref_creator_id", on_delete: :cascade
  add_foreign_key "pulse", "report_dashboard", column: "dashboard_id", name: "fk_pulse_ref_dashboard_id", on_delete: :cascade
  add_foreign_key "pulse_card", "pulse", name: "fk_pulse_card_ref_pulse_id", on_delete: :cascade
  add_foreign_key "pulse_card", "report_card", column: "card_id", name: "fk_pulse_card_ref_card_id", on_delete: :cascade
  add_foreign_key "pulse_card", "report_dashboardcard", column: "dashboard_card_id", name: "fk_pulse_card_ref_pulse_card_id", on_delete: :cascade
  add_foreign_key "pulse_channel", "pulse", name: "fk_pulse_channel_ref_pulse_id", on_delete: :cascade
  add_foreign_key "pulse_channel_recipient", "core_user", column: "user_id", name: "fk_pulse_channel_recipient_ref_user_id", on_delete: :cascade
  add_foreign_key "pulse_channel_recipient", "pulse_channel", name: "fk_pulse_channel_recipient_ref_pulse_channel_id", on_delete: :cascade
  add_foreign_key "qrtz_blob_triggers", "qrtz_triggers", column: ["sched_name", "trigger_name", "trigger_group"], primary_key: ["sched_name", "trigger_name", "trigger_group"], name: "fk_qrtz_blob_triggers_triggers"
  add_foreign_key "qrtz_cron_triggers", "qrtz_triggers", column: ["sched_name", "trigger_name", "trigger_group"], primary_key: ["sched_name", "trigger_name", "trigger_group"], name: "fk_qrtz_cron_triggers_triggers"
  add_foreign_key "qrtz_simple_triggers", "qrtz_triggers", column: ["sched_name", "trigger_name", "trigger_group"], primary_key: ["sched_name", "trigger_name", "trigger_group"], name: "fk_qrtz_simple_triggers_triggers"
  add_foreign_key "qrtz_simprop_triggers", "qrtz_triggers", column: ["sched_name", "trigger_name", "trigger_group"], primary_key: ["sched_name", "trigger_name", "trigger_group"], name: "fk_qrtz_simprop_triggers_triggers"
  add_foreign_key "qrtz_triggers", "qrtz_job_details", column: ["sched_name", "job_name", "job_group"], primary_key: ["sched_name", "job_name", "job_group"], name: "fk_qrtz_triggers_job_details"
  add_foreign_key "query_action", "action", name: "fk_query_action_ref_action_id", on_delete: :cascade
  add_foreign_key "query_action", "metabase_database", column: "database_id", name: "fk_query_action_database_id", on_delete: :cascade
  add_foreign_key "recent_views", "core_user", column: "user_id", name: "fk_recent_views_ref_user_id", on_delete: :cascade
  add_foreign_key "report_card", "collection", name: "fk_card_collection_id", on_delete: :nullify
  add_foreign_key "report_card", "core_user", column: "creator_id", name: "fk_card_ref_user_id", on_delete: :cascade
  add_foreign_key "report_card", "core_user", column: "made_public_by_id", name: "fk_card_made_public_by_id", on_delete: :cascade
  add_foreign_key "report_card", "metabase_database", column: "database_id", name: "fk_report_card_ref_database_id", on_delete: :cascade
  add_foreign_key "report_card", "metabase_table", column: "table_id", name: "fk_report_card_ref_table_id", on_delete: :cascade
  add_foreign_key "report_cardfavorite", "core_user", column: "owner_id", name: "fk_cardfavorite_ref_user_id", on_delete: :cascade
  add_foreign_key "report_cardfavorite", "report_card", column: "card_id", name: "fk_cardfavorite_ref_card_id", on_delete: :cascade
  add_foreign_key "report_dashboard", "collection", name: "fk_dashboard_collection_id", on_delete: :nullify
  add_foreign_key "report_dashboard", "core_user", column: "creator_id", name: "fk_dashboard_ref_user_id", on_delete: :cascade
  add_foreign_key "report_dashboard", "core_user", column: "made_public_by_id", name: "fk_dashboard_made_public_by_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "action", name: "fk_report_dashboardcard_ref_action_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "dashboard_tab", name: "fk_report_dashboardcard_ref_dashboard_tab_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "report_card", column: "card_id", name: "fk_dashboardcard_ref_card_id", on_delete: :cascade
  add_foreign_key "report_dashboardcard", "report_dashboard", column: "dashboard_id", name: "fk_dashboardcard_ref_dashboard_id", on_delete: :cascade
  add_foreign_key "revision", "core_user", column: "user_id", name: "fk_revision_ref_user_id", on_delete: :cascade
  add_foreign_key "sandboxes", "metabase_table", column: "table_id", name: "fk_gtap_table_id", on_delete: :cascade
  add_foreign_key "sandboxes", "permissions", name: "fk_sandboxes_ref_permissions", on_delete: :cascade
  add_foreign_key "sandboxes", "permissions_group", column: "group_id", name: "fk_gtap_group_id", on_delete: :cascade
  add_foreign_key "sandboxes", "report_card", column: "card_id", name: "fk_gtap_card_id", on_delete: :cascade
  add_foreign_key "secret", "core_user", column: "creator_id", name: "fk_secret_ref_user_id"
  add_foreign_key "segment", "core_user", column: "creator_id", name: "fk_segment_ref_creator_id", on_delete: :cascade
  add_foreign_key "segment", "metabase_table", column: "table_id", name: "fk_segment_ref_table_id", on_delete: :cascade
  add_foreign_key "table_privileges", "metabase_table", column: "table_id", name: "fk_table_privileges_table_id", on_delete: :cascade
  add_foreign_key "timeline", "collection", name: "fk_timeline_collection_id", on_delete: :cascade
  add_foreign_key "timeline", "core_user", column: "creator_id", name: "fk_timeline_creator_id", on_delete: :cascade
  add_foreign_key "timeline_event", "core_user", column: "creator_id", name: "fk_event_creator_id", on_delete: :cascade
  add_foreign_key "timeline_event", "timeline", name: "fk_events_timeline_id", on_delete: :cascade
  add_foreign_key "view_log", "core_user", column: "user_id", name: "fk_view_log_ref_user_id", on_delete: :cascade
end
