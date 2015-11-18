class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
	  t.string :salesforce_username
	  t.string :salesforce_password  
      t.string :name
      t.string :last_name
      t.string :email
      t.string :company
      t.string :job_title
      t.string :phone
      t.string :website

      t.timestamps
    end
  end
end
