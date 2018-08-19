require 'rails_helper'

feature "Add to cart" do 
    scenario "first time visit" do 
        visit products_index_path
        expect(find('.cart-text a')).to have_content('0 Items in Cart ( $0.00 )')
    end

    scenario "clicks on add to cart" do 
        visit products_index_path
        first('input[name="commit"]').click
        expect(first('.cart-text a')).to have_content('1 Items in Cart')
    end
end