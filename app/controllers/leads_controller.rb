class LeadsController < ApplicationController

	def create
		@lead = Lead.new(lead_params)
		
		begin
			AddLeadToSalesforce(@lead)
		rescue Exception => e
			flash[:notice] = e
		end
		
		redirect_to :action => 'new'
	end

	
	def lead_params
		params.require(:lead).permit(:salesforce_username, :salesforce_password, :name, :last_name, :email, :company, :job_title, :phone, :website)
	end
	  
	def AddLeadToSalesforce(lead)
		require 'C:\RailsInstaller\Ruby2.1.0\lib\ruby\gems\2.1.0\gems\salesforce_bulk-1.0.3\lib\salesforce_bulk'
		salesforce = SalesforceBulk::Api.new(lead.salesforce_username, lead.salesforce_password)

		new_account = Hash["firstname" => lead.name, "lastname" => lead.last_name,
						"email" => lead.email, "company" => lead.company,
						"title" => lead.job_title, "phone" => lead.phone, "website" => lead.website]
		
		records_to_insert = Array.new
		records_to_insert.push(new_account)
		result = salesforce.create("Lead", records_to_insert, true)

				
		if result.result.errors.count > 0
			flash[:notice] = result.result.errors.first
		else
			flash[:notice] = "The user was successfully added to Salesforce."
		end
		
		res = salesforce.query("Lead", "select firstname, lastname, email, company, title, phone, website, createddate
										from Lead order by createddate desc limit 1")	
		flash[:notice] = res.result.records.to_a.map {|row| row.to_s.split(/,/) }.first
	end
	  
	  
	  
	end
	
