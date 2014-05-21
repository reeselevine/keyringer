class Order < ActiveRecord::Base
  attr_accessible :address1, :address2, :first_name, :last_name, :cart_id, :city, :country, :email, :expire_date, :ip_address, :payment_method, :phone_number, :postal_code, :province, :state,:express_token,:card_number, :card_verification
  belongs_to :cart
  has_many :transactions, :class_name => "OrderTransaction" ,:limit => 1,:order => "created_at DESC"
  attr_accessor :card_number, :card_verification
  validate :validate_card, :on => :create
  has_one :shipment
  attr_accessible :shipment_attributes
  accepts_nested_attributes_for :shipment, :allow_destroy => true

  def purchase(total_price)
    result_response = process_purchase(total_price)
    transactions.create!(:action => "purchase", :amount => price_in_cents(total_price), :result_response => result_response)
    cart.update_attribute(:purchased_at, Time.now) if result_response.success?
    result_response.success?
  end

  def price_in_cents(total_price)
    (total_price * 100).round
  end

  def express_token=(token)
    self[:express_token] = token
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
      self.first_name = details.params["first_name"]
      self.last_name = details.params["last_name"]
    end
  end

  private
  def process_purchase(total_price)
    if express_token.blank?
      PRO_GATEWAY.purchase(price_in_cents(total_price), credit_card, purchase_options)
    else
      EXPRESS_GATEWAY.purchase(price_in_cents(total_price), express_purchase_options)
    end
  end
  def express_purchase_options
    {
        :ip => ip_address,
        :token => express_token,
        :payer_id => express_payer_id
    }
  end

  def purchase_options
    {
        :ip => ip_address,
        :billing_address => {
            :name => first_name.concat(" ").concat(last_name),
            :address1 => address1,
            :address2 => address2,
            :phone => phone_number,
            :city => city,
            :state => (state.nil? || state.blank?) ? province : state,
            :country => country,
            :zip => postal_code
        }
    }
  end

  def validate_card
    if express_token.blank? && !credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors[:base] << message
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
        :type => payment_method,
        :number => card_number,
        :verification_value => card_verification,
        :month => expire_date.month,
        :year => expire_date.year,
        :first_name => first_name,
        :last_name => last_name
    )
  end
end
