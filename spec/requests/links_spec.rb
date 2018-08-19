require 'spec_helper'
require 'rails_helper'

describe "Links:" do
  it "should have the title 'Products for Sale'" do
    visit products_index_path
    expect(find('.container h3')).to have_content('Products for Sale')
  end

  it "should have the title 'Upload your EDI'" do 
    visit upload_edi_path
    expect(find('h2')).to have_content('Upload your EDI')
  end
end