class Order < ActiveRecord::Base
  belongs_to :order_status
  belongs_to :user, optional: true
  has_many :order_items
  before_create :set_order_status
  before_save :update_subtotal

  audited

  ORDER_PROCESSING = 1
  ORDER_PLACED = 2
  ORDER_SHIPPED = 3
  ORDER_COMPLETED = 4

  scope :placed, lambda {
    where('order_status_id =? ', ORDER_PLACED)
  }
  scope :shipped, lambda {
    where('order_status_id =? ', ORDER_SHIPPED)  
  }

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  AUTH_TOKENS = [
    'LDWE9uNePj',
    'aTp2dL8fju',
    'gIC1uTWTGL',
  ]

  def create_order_from_edi(data)
    if product = Product.find_by(id: data['product_id'])
      order_item = self.order_items.new(
        product_id: product.id,
        order_id: self.id,
        unit_price: product.price,
        quantity: data['qty'],
        total_price: data['qty'] * product.price,
      )
      self.order_status_id = 1
      self.user_id = data['auth']
      self.save
    else
      logger.info "====WORNG===="
      return false
    end
  end

  def get_humanized_status
    status = if order_status_id == ORDER_PROCESSING
                'Processing'
              elsif order_status_id == ORDER_PLACED
                'Placed'
              elsif order_status_id == ORDER_SHIPPED
                'Shipped'
              else
                'Completed'
              end  
  end

private
  def set_order_status
    self.order_status_id = 1
  end

  def update_subtotal
    self[:subtotal] = subtotal
  end

  def self.validate_edi(content)
    valid = email = false
    product_id = quantity = auth = nil
    regex = /\*(.*?)~/
    content.each_line { |line|
      if line =~ /AUTH/
        auth = line.slice(regex, 1)
        valid = self.auth_is_valid?(auth)
      elsif line =~ /EM/
        email = line.slice(regex, 1)
      elsif line =~ /PID/
        product_id = line.slice(regex, 1)
      elsif line =~ /QT/
        quantity = line.slice(regex, 1)
      end
    }
    data = {
      'valid' => valid,
      'email' => email,
      'product_id' => product_id,
      'qty' => quantity,
    }
  end 

  def self.auth_is_valid?(auth)
    AUTH_TOKENS.include?(auth)
  end

  def self.scheduled_process_shipping
    orders = Order.placed
    orders.each do |order|
      order.update_attribute(:order_status_id, ORDER_SHIPPED)
    end
  end

  def self.scheduled_process_complete
    orders = Order.shipped
    orders.each do |order|
      order.update_attribute(:order_status_id, ORDER_COMPLETED)
    end
  end
end