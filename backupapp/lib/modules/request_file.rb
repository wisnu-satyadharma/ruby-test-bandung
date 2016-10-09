class RequestFile
  def self.process_backup path, document_id, parent_id=nil
    document = Document.find_by(id: document_id)
    Dir.new(path).each do |file|       
      next if file[0] == "." || file == "." || file == ".."
      current_attachment = document.attachments.new

      if File.file?(File.join(path,file))        
        current_attachment.file_size=File.size(File.join(path,file))
        current_attachment.object_type = Attachment.object_types["file"]
        current_attachment.parent_id = parent_id
        current_attachment.item = File.open(File.join(path,file))
        current_attachment.save
      elsif File.directory?(File.join(path,file))
        current_attachment.object_type = Attachment.object_types["directory"]
        current_attachment.parent_id = parent_id
        current_attachment.save
        RequestFile.process_backup(File.join(path,file), document_id, current_attachment.id)
      end       
    end    
  end

  def self.calculating_file path
    total_file = 0 
    total_size = 0
    Dir.new(path).each do |file|       
      next if file[0] == "." || file == "." || file == ".."      
      if File.file?(File.join(path,file))
        total_file +=  1
        total_size +=  File.size?(File.join(path,file))
      elsif File.directory?(File.join(path,file))
        processing_total_file, processing_total_size = (RequestFile.calculating_file(File.join(path,file)))
        total_file += processing_total_file
        total_size += processing_total_size
      end       
    end  
    return total_file, total_size  
  end
end