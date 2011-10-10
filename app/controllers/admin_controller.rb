class AdminController < ApplicationController
  layout 'layouts/main'
  
  def regular_payments


  end

  def new_rp
    @new = true
    render :template => 'admin/regular_payments'
  end

  def save_rp
    puts params.inspect
    if params[:rp_id]#edit

    else#create new
      rp = RegularPayment.new({:name => params[:name]})

    end
  end
end
