class Api::V1::TransactionsController < Api::V1::BaseController
  def client_token
    @client_token = generate_client_token
    render json: { success: true, data: @client_token }
  end

  def create
    @result = Braintree::Transaction.sale(amount: "10.00",
                                          payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
      render json: { success: true }, status: 201
    else
      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      render json: { success: false, error: flash[:alert] }, status: 422
    end
  end

  private

  def generate_client_token
    Braintree::ClientToken.generate
  end
end