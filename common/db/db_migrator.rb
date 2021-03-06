require 'sequel'
require 'sequel/adapters/shared/mysql'
require 'config/config-distribution'
require 'asutils'

Sequel::MySQL.default_engine = 'InnoDB'
Sequel::MySQL.default_charset = 'utf8'

Sequel.database_timezone = :utc
Sequel.typecast_timezone = :utc

Sequel.extension :migration
Sequel.extension :core_extensions 


module ColumnDefs

  def self.textField(name, opts = {})
    if $db_type == :derby
      [name, :clob, opts]
    else
      [name, :text, opts]
    end
  end


  def self.longString(name, opts = {})
    [name, String, opts.merge(:size => 17408)]
  end

  def self.halfLongString(name, opts = {})
    [name, String, opts.merge(:size => 8704)]
  end


  def self.textBlobField(name, opts = {})
    if $db_type == :derby
      [name, :clob, opts]
    else
      self.blobField(name, opts)
    end
  end


  def self.blobField(name, opts = {})
    if $db_type == :postgres
      [name, :bytea, opts]
    elsif $db_type == :h2
      [name, String, opts.merge(:size => 128000)]
    else
      [name, :blob, opts]
    end
  end


  def self.mediumBlobField(name, opts = {})
    if $db_type == :postgres
      [name, :bytea, opts]
    elsif $db_type == :h2
      [name, String, opts.merge(:size => 128000)]
    elsif $db_type == :mysql
      [name, :mediumblob, opts]
    else
      [name, :blob, opts]
    end
  end

end


# Sequel uses a nice DSL for creating tables but not for altering tables.  The
# definitions below try to provide a reasonable experience for both cases.
# Creation is the normal:
#
#   HalfLongString :title, :null => true
#
# while altering is (to add a column):
#
#   HalfLongString :title
#

module SequelColumnTypes

  def create_column(*column_def)
    if self.respond_to?(:column)
      column(*column_def)
    else
      add_column(*column_def)
    end
  end


  def TextField(field, opts = {})
    create_column(*ColumnDefs.textField(field, opts))
  end


  def LongString(field, opts = {})
    create_column(*ColumnDefs.longString(field, opts))
  end

  def HalfLongString(field, opts = {})
    create_column(*ColumnDefs.halfLongString(field, opts))
  end


  def TextBlobField(field, opts = {})
    create_column(*ColumnDefs.textBlobField(field, opts))
  end


  def BlobField(field, opts = {})
    create_column(*ColumnDefs.blobField(field, opts))
  end


  def MediumBlobField(field, opts = {})
    create_column(*ColumnDefs.mediumBlobField(field, opts))
  end


  def DynamicEnum(field, opts = {})
    Integer field, opts
    foreign_key([field], :enumeration_value, :key => :id)
  end


  def apply_name_columns
    String :authority_id, :null => true
    String :dates, :null => true
    TextField :qualifier, :null => true
    DynamicEnum :source_id, :null => true
    DynamicEnum :rules_id, :null => true
    TextField :sort_name, :null => false
    Integer :sort_name_auto_generate
  end


  def apply_mtime_columns(create_time = true)
    String :created_by
    String :last_modified_by

    if create_time
      DateTime :create_time, :null => false
    end

    DateTime :system_mtime, :null => false, :index => true
    DateTime :user_mtime, :null => false, :index => true
  end

end


module Sequel

  module Schema
    class CreateTableGenerator
      include SequelColumnTypes
    end

    class AlterTableGenerator
      include SequelColumnTypes
    end
  end

end


class DBMigrator

  MIGRATIONS_DIR = File.join(File.dirname(__FILE__), "migrations")
  PLUGIN_MIGRATIONS = []
  PLUGIN_MIGRATION_DIRS = {}
  AppConfig[:plugins].each do |plugin|
    mig_dir = ASUtils.find_local_directories("migrations", plugin).shift
    if mig_dir && Dir.exists?(mig_dir)
      PLUGIN_MIGRATIONS << plugin
      PLUGIN_MIGRATION_DIRS[plugin] = mig_dir
    end
  end

  def self.setup_database(db)
    $db_type = db.database_type
    Sequel::Migrator.run(db, MIGRATIONS_DIR)
    PLUGIN_MIGRATIONS.each { |plugin| Sequel::Migrator.run(db, PLUGIN_MIGRATION_DIRS[plugin],
                                                           :table => "#{plugin}_schema_info") }
  end


  def self.nuke_database(db)
    $db_type = db.database_type
    PLUGIN_MIGRATIONS.reverse.each { |plugin| Sequel::Migrator.run(db, PLUGIN_MIGRATION_DIRS[plugin],
                                                                     :table => "#{plugin}_schema_info", :target => 0) }
    Sequel::Migrator.run(db, MIGRATIONS_DIR, :target => 0)
  end

  def self.needs_updating?(db)
    $db_type = db.database_type
    return true unless Sequel::Migrator.is_current?(db, MIGRATIONS_DIR)
    PLUGIN_MIGRATIONS.each { |plugin| return true unless Sequel::Migrator.is_current?(db, PLUGIN_MIGRATIONS_DIR[plugin],
                                                                                      :table => "#{plugin}_schema_info") }
    return false
  end

end
