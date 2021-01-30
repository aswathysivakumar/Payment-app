# For storing payment related info
class Payment < ApplicationRecord
  STATUS = { success: 'Success', failed: 'Failed', pending: 'Pending' }.freeze
  belongs_to :customer

  scope :payment_details, lambda { |user|
    includes(customer: :recipient)
      .where(customer_id: user)
      .order('created_at DESC')
  }

  def update_status(status)
    update_attributes(status: STATUS[status.to_sym])
  end
end
