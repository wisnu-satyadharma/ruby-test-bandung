class TreeviewConverter
  def self.convert attachment_id
    attachment = Attachment.find_by(id: attachment_id)
    html = ""    
    return html if attachment.blank? 
    if attachment.object_type == "directory"
      html << "<li> #{attachment.item_file_name}"
    elsif attachment.object_type == "file"
      html << "<li> <a class='js_link' href='/attachments/#{attachment.id}/show_contain'>#{attachment.item_file_name}</a>"
    end
          
    if attachment.children.present?
      html << "<ul>"
      attachment.children.each do |children|
        html << TreeviewConverter.convert(children.id)
      end
      html << "</ul>"
    end      
    html<< "</li>"
    return html
  end
end