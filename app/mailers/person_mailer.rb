class PersonMailer < ApplicationMailer
  require 'csv'

  def balance_report(user)
    @user = user
    @people = Person.order(:name)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['Nome', 'Saldo']
      @people.order(:name).each do |person|
        csv << [person.name, person.balance]
      end
    end

    attachments['relatorio_saldo.csv'] = csv_data
    mail(to: @user.email, subject: 'Relatório de Saldo')
  end
end
