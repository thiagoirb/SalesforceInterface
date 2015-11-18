require 'test_helper'

class LeadsControllerTest < ActionController::TestCase

#test if the last item was correctly inserted
   test "verification of insertion" do
		insertion_params = ["thiagoirb@gmail.com", "qwer1234xko4PbK8xDXvC7EP8xyYuC825",
		"Thiago", "Bacic", "thiagoirb@gmail.com", "Company", "Engineer", "12345678", "www.test.com.br"]
		
		lead = Lead.new(salesforce_username:"thiagoirb@gmail.com", salesforce_password:"qwer1234xko4PbK8xDXvC7EP8xyYuC825",
						name:"Thiago", last_name:"Bacic", email:"thiagoirb@gmail.com", company:"Company",
						job_title:"Engineer", phone:"12345678", website:"www.test.com.br")
		
		@controller.AddLeadToSalesforce(lead)
		
		require 'C:\RailsInstaller\Ruby2.1.0\lib\ruby\gems\2.1.0\gems\salesforce_bulk-1.0.3\lib\salesforce_bulk'
		salesforce = SalesforceBulk::Api.new(lead.salesforce_username, lead.salesforce_password)
		res = salesforce.query("Lead", "select firstname, lastname, email, company, title, phone, website, createddate
										from Lead order by createddate desc limit 1")	
		res = res.result.records.to_a.map {|row| row.to_s.split(/,/) }.first

		assert_equal insertion_params[2], res[0]
		assert_equal insertion_params[3], res[1]
		assert_equal insertion_params[4], res[2]
		assert_equal insertion_params[5], res[3]
		assert_equal insertion_params[6], res[4]
		assert_equal insertion_params[7], res[5]
		assert_equal insertion_params[8], res[6]
   end
   

end



