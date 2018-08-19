require 'rails_helper'

RSpec.feature 'Product List' do
    scenario 'unauthenticated user' do 
        visit products_index_path
        expect(find('.container h3')).to have_content('Products for Sale')
    end
end