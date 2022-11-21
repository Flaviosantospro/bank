class WithdrawsController < ApplicationController
  before_action :authenticate_client!

  def new
    @withdraw = Debit.new
  end

  def create
    @withdraw = Debit.new(debit_type: 'withdraw', amount: amount, bank_account: current_client.bank_account)
    if @withdraw.save
      flash[:success] = 'Saque realizado com sucesso.'
      redirect_to new_withdraw_path
    else
      @withdraw.amount = ''
      flash.now[:error] = 'Não foi possível realizar o saque.'
      render 'new'
    end
  end

  private

  def debit_params
    params.require(:debit).permit(:amount)
  end

  def amount
    IntegerToCentsConverter.call(debit_params[:amount])
  end
end
