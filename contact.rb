gem 'activerecord', '=4.2.7'
require 'active_record'
require 'mini_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'crm.sqlite3')

class Contact < ActiveRecord::Base
  # attr_accessor :id, :first_name, :last_name, :email, :note
  field :first_name, as: :string
  field :last_name, as: :string
  field :email, as: :string
  field :note, as: :text
  field :is_active, as: :boolean

  validates :first_name, :last_name, :email, presence: true

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end

Contact.auto_upgrade!
