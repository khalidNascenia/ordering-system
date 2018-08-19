class UserMailer < ApplicationMailer
    default from: 'no-reply@example.com'

    def place_order(order)
        @order = order
        mail to: ENV['ADMIN_EMAIL'],
             subject: "An order has been placed"
    end
end
