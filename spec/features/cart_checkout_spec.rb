require 'rails_helper'

feature "Cart checkout" do 
    context "is in cart page" do 

        before do
            visit products_index_path
            first('input[name="commit"]').click
            expect(first('.cart-text a')).to have_content('1 Items in Cart')
            visit cart_path
        end

        scenario "update product quantity" do
            first('#order_item_quantity').click
            first('input[name="commit"]').click
            expect(page).to have_link('Place Order')
        end

        scenario "delete an item from cart" do 
            first('a.btn-danger').click
            expect(page).not_to have_link('Place Order')
        end
    end
end