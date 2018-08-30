module ApplicationHelper

  def sortable(column,title)
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    css = "btn btn-primary"
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:name => params[:name], :status => params[:status], :sort => column, :direction => direction}, {:class => css}
  end
  
end
