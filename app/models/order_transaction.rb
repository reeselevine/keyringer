class OrderTransaction < ActiveRecord::Base
  attr_accessible :action, :amount, :authorization, :message, :order_id, :params, :success
  attr_accessible :result_response
  belongs_to :order

  serialize :params

  def result_response=(result_response)
    self.success = result_response.success?
    self.authorization = result_response.authorization
    self.message = result_response.message
    self.params = result_response.params
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success = false
    self.authorization = nil
    self.message = e.message
    self.params = {}
  end
end
