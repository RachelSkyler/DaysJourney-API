class User 
  require 'digest/sha1'

  # For setting up mongoid to user model. 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  ## For devise
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recorverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: DateTime

  ## Rememberable
  field :remember_created_at, type: DateTime

  ##Trackable
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: DateTime
  field :last_sign_in_at, type: DateTime
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip, type: String

  ## add user_name
  field :user_name, type: String

  ## Database authenticatable in migrate.
  #   t.string :email,              :null => false, :default => ""
  #   t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      #t.string   :reset_password_token
      #t.datetime :reset_password_sent_at

      ## Rememberable
      #t.datetime :remember_created_at

      ## Trackable
      #t.integer  :sign_in_count, :default => 0, :null => false
      #t.datetime :current_sign_in_at
      #t.datetime :last_sign_in_at
      #t.string   :current_sign_in_ip
      #t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

  # Bi-directional relation with Path.
  has_many :paths, validate: false, inverse_of: :user
  
  # Fields that are required in order to have a valid user
  validates :email, :encrypted_password, :user_name, :sign_in_count, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, pepper: "rachelskyler"

  # Customise validate function. this method's logic is same with the origina but you can add log if you want.
  # You must configure pepper hash.  
  def valid_password?(password)
      return false if encrypted_password.blank?
      bcrypt   = ::BCrypt::Password.new(encrypted_password)
      password = ::BCrypt::Engine.hash_secret("#{password}#{self.class.pepper}", bcrypt.salt)
      Devise.secure_compare(password, encrypted_password)
  end
end
