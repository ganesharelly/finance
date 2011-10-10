module MainHelper

  @@action_to_buton_text_mapping =  {"transactions" => 'Transactions', "filetodb" => 'Load to DB' ,
                                                                     "statistics" => 'Statistics'}
  
  def button_link(name)
    "<div class='" + button_class(name) + "'>" + name + "</div>"
  end

  def button_class(name)
    @@action_to_buton_text_mapping[params[:action].to_s].eql?(name) ? 'button_selected' : 'button'
  end

  def get_search_default_date(params_date)
     params_date ? { :day =>  params_date["done_on(3i)".to_s] ? params_date["done_on(3i)".to_s] : "",
        :month =>  params_date["done_on(2i)".to_s] ? params_date["done_on(2i)".to_s] : "",
        :year =>  params_date["done_on(1i)".to_s] ? params_date["done_on(1i)".to_s] : ""
        } : {}
  end
  
end
