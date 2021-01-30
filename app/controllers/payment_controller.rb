# For payment related routing
class PaymentController < ApplicationController
  skip_before_action :authenticate_user!

  # API for listing the payment details with status, recipient details etc
  def payment_history
    # payment_details is a scope in payment model
    payments = Payment.payment_details(current_user)
    render json: payments
  end

  # Saw one gem for payment initiation(pain) while researching - sepa_king
  # Need to create a xml before sending request to bank, for that we use sepa_king
  def payment_request
    @payment = Payment.create(payment_params)
    sepa_direct_debit = SEPA::DirectDebit.new(recipient_params)
    sepa_direct_debit.add_transaction(debtor_params)
    # with this xml request will be set to bank and payment will be initiated
    sepa_direct_debit.to_xml
    @response = request_to_bank
    update_payment_status
  end

  private

  def payment_params
    params
      .require(:payment)
      .permit(:amount, :currency, :iban, recipient_id)
  end

  def recipient
    Recipient.find payment_params[:recipient_id]
  end

  def recipient_params
    { name: recipient.name, bic: recipient.bic, iban: recipient.iban,
      creditor_identifier: recipeint.creditor_identifier }
  end

  def debtor_params
    { name: current_user.name, bic: current_user.bic, iban: current_user.iban,
      amount: payment_params[:amount], currency: payment_params[:currency],
      reference: 'XYZ/2013-08-ABO/6789', mandate_id: 'K-02-2011-12345',
      mandate_date_of_signature: Date.new(2011, 1, 25),
      local_instrument: 'CORE', sequence_type: 'OOFF', 
      requested_date: Date.new(2013, 9, 5), batch_booking: true }
  end

  def request_to_bank
    # Request to bank via respective API , it can be done as a module in lib folder
  end

  def update_payment_status
    # update_status is a method in payment model
    if @response.success?
      @payment.update_status('success')
    elsif @response.pending?
      @payment.update_status('pending')
    else
      @payment.update_status(status: 'failure')
    end
  end
end
