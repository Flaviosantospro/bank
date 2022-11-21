class DepositsController < ApplicationController
  before_action :authenticate_client!

  def new
    @deposit = Credit.new
  end

  def create
    @deposit = Credit.new(credit_type: 'deposit', amount: amount, bank_account: current_client.bank_account)
    if @deposit.save
      flash[:success] = 'Depósito realizado com sucesso.'
      redirect_to new_deposit_path
    else
      @deposit.amount = ''
      flash.now[:error] = 'Não foi possível realizar o depósito.'
      render 'new'
    end
  end

  private

  def credit_params
    params.require(:credit).permit(:amount)
  end

  def amount
    IntegerToCentsConverter.call(credit_params[:amount])
  end
end
