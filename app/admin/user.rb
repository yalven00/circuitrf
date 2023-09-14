ActiveAdmin.register User do
menu :priority => 2

  index do

    column :name        
    column :email                     
    column :company           
    column :created_at


    # default_actions
  end

  filter :email

  form do |f|                         
    f.inputs "Admin Details" do       
      f.input :email                  
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.actions
  end
  
end
