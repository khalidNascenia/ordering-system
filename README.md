A simple ordering system that supports a web user and EDI (Electronic Data Interchange)

## Specifications

### Rails 5.2.0

### Ruby 2.5.0

### Mysql

Clone this repository and go to the cloned directory

And run bundler

    bundle install

### Migrations

    rake db:setup

### Configure application.yml

    ADMIN_EMAIL: "abc@example.com"
    HOST_EMAIL: "someone@gmail.com"
    HOST_PASSWORD: "password"

ADMIN_EMAIL should be set to get order notification.
HOST_EMAIL & HOST_PASSWORD should be set to send emails from dev environment.

### Run development server

    rails server

### Test

Run rspec

    rspec spec

### EDI Document Format (\*.txt)

    AUTH*LDWE9uNePj~
    EM*khalid@nascenia.com~
    PID*11~
    QT*2~

AUTH = Authorization Token, EM = Email, PID = Product ID and QT = Quantity

### Scheduler

    whenever --update-crontab --set environment='development'

Scheduler is set to run every 5 minutes to process/complete orders
