class ReportsController < ApplicationController
    def balance
      # Descomente a linha abaixo depois de implementar o Mailer
      # PersonMailer.balance_report(current_user).deliver_now
      redirect_to root_path, notice: 'Relatório enviado para seu e-mail'
    end
  end