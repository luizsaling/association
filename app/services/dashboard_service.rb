class DashboardService
    def initialize(user)
      @user = user
    end
  
    def dashboard_data
      Rails.cache.fetch(cache_key, expires_in: 1.hour) do
        {
          active_people_pie_chart: active_people_pie_chart,
          total_debts: total_debts,
          total_payments: total_payments,
          balance: balance,
          last_debts: last_debts,
          last_payments: last_payments,
          my_people: my_people,
          top_person: top_person,
          bottom_person: bottom_person
        }
      end
    end
  
    private
  
    def cache_key
      "dashboard_data_for_user_#{user.id}"
    end
  
    def user
      @user
    end
  
    def active_people_pie_chart
      {
        active: active_people_count,
        inactive: inactive_people_count
      }
    end
  
    def active_people_count
      Person.where(active: true).count
    end
  
    def inactive_people_count
      Person.where(active: false).count
    end
  
    def total_debts
      active_people_ids = active_people.select(:id)
      Rails.cache.fetch("#{cache_key}/total_debts", expires_in: 1.hour) do
        Debt.where(person_id: active_people_ids).sum(:amount)
      end
    end
  
    def total_payments
      active_people_ids = active_people.select(:id)
      Rails.cache.fetch("#{cache_key}/total_payments", expires_in: 1.hour) do
        Payment.where(person_id: active_people_ids).sum(:amount)
      end
    end
  
    def balance
      total_payments - total_debts
    end
  
    def last_debts
      Debt.order(created_at: :desc).limit(10).pluck(:id, :amount)
    end
  
    def last_payments
      Payment.order(created_at: :desc).limit(10).pluck(:id, :amount)
    end
  
    def my_people
      Person.where(user: @user).order(:created_at).limit(10)
    end 
  
    def active_people
      Person.where(active: true)
    end
  
    def people_with_positive_balance
      Person.all.select { |person| person.balance > 0 }
    end
  
    def top_person
      people_with_positive_balance.max_by(&:balance)
    end
  
    def bottom_person
      people_with_positive_balance.min_by(&:balance)
    end
  end
  