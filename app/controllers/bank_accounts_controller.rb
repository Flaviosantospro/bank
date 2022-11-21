class BankAccountsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_bank_account, only: %i[destroy reactivate statement]
  before_action :set_statement_date_range, only: :statement

  def destroy
    if @bank_account.closed!
      flash[:success] = 'Conta bancária encerrada com sucesso.'
    else
      flash.now[:error] = 'Algo deu errado.'
    end
    redirect_to root_path
  end

  def reactivate
    if @bank_account.active!
      flash[:success] = 'Conta bancária reativada com sucesso.'
    else
      flash.now[:error] = 'Algo deu errado.'
    end
    redirect_to root_path
  end

  def balance; end

  def statement
    credits = @bank_account.credits.where(created_at: @date_range)
    debits = @bank_account.debits.where(created_at: @date_range)
    @transactions = (credits + debits).sort_by(&:created_at).reverse!
  end

  private

  def set_bank_account
    @bank_account = current_client.bank_account
  end

  def statement_params
    params.permit(:start_date, :end_date)
  end

  def set_statement_date_range
    start_datetime = statement_params[:start_date].try(:to_datetime).try(:beginning_of_day)
    end_datetime = statement_params[:end_date].try(:to_datetime).try(:end_of_day)

    @date_range = if start_datetime && end_datetime
                    start_datetime..end_datetime
                  else
                    7.days.ago.beginning_of_day..DateTime.now
                  end
  end
end
