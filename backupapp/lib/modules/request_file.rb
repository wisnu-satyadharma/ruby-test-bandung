class RequestFile
  def self.process_backup path, document_id, parent_id=nil
    document = Document.find_by(id: document_id)
    exclusions = RequestFile.determine_exclusion(document.profile_id)
    Dir.new(path).each do |file|       
      document.reload
      next if file[0] == "." || file == "." || file == ".."      
      current_attachment = document.attachments.new
      if File.file?(File.join(path,file))     
        next if RequestFile.exclude?(document.profile_id, file, path, exclusions)
        current_attachment.file_path = File.join(path,file)
        current_attachment.file_size=File.size(File.join(path,file))
        current_attachment.object_type = Attachment.object_types["file"]
        current_attachment.parent_id = parent_id
        current_attachment.item = File.open(File.join(path,file))
        current_attachment.status = RequestFile.define_status(document.profile_id, document.id, File.join(path,file))
        current_attachment.save
      elsif File.directory?(File.join(path,file)) 
        current_attachment.file_path = File.join(path,file)
        current_attachment.object_type = Attachment.object_types["directory"]
        current_attachment.parent_id = parent_id
        current_attachment.item_file_name = File.basename(File.join(path,file))
        current_attachment.status = RequestFile.define_status(document.profile_id, document.id, File.join(path,file))
        current_attachment.save
        RequestFile.process_backup(File.join(path,file), document_id, current_attachment.id)
      end       
    end        
  end

  def self.define_status profile_id, document_id, path
    document = Document.find_by(id: document_id)
    prev_file = Attachment.joins(:document =>[:profile]).where("profiles.id =? and documents.version = ? and attachments.file_path = ?", profile_id, document.version-1, path).first
    if prev_file.blank?
      return Attachment.statuses["added"]
    end

    return nil if File.directory?(path)
    if File.open(path).read != Paperclip.io_adapters.for(prev_file.item).read
      Attachment.statuses["modified"]
    end
  end

  def self.exclude?(profile_id, file, path, exclusions)
    status = false
    profile = Profile.find_by(id: profile_id)

    #path_exclusion    
    if exclusions[:path_exclusion].present?
      exclusions[:path_exclusion].each do |path_exclusion|
        path_exclusion_path = File.join(profile.directory, path_exclusion)
        status = true if File.join(path,file).include?(path_exclusion_path)
      end
    end

    #file_exclusion
    if exclusions[:file_exclusion].present?
      exclusions[:file_exclusion].each do |file_exclusion|
        path_file_exclusion = File.join(profile.directory, file_exclusion)
        status = true if File.join(path,file).include?(path_file_exclusion)
      end
    end

    #path_and_filename_exclusion
    if exclusions[:path_and_filename_exclusion].present?
      exclusions[:path_and_filename_exclusion].each do |path_and_filename_exclusion|
        path_and_filename_exclusion = File.join(profile.directory, path_and_filename_exclusion)
        status = true if File.join(path,file).include?(path_and_filename_exclusion)
      end
    end

    #extension_exclusion
    if exclusions[:extension_exclusion].present?
      exclusions[:extension_exclusion].each do |extension_exclusion|
        if path == profile.directory && file.split(".").last == extension_exclusion.split(".").last
          status = true
        end                
      end
    end

    #path_and_extension_exclusion
    if exclusions[:path_and_extension_exclusion].present?
      exclusions[:path_and_extension_exclusion].each do |path_and_extension_exclusion|
        exclusion_full_path = File.join(profile.directory, path_and_extension_exclusion)
        exclusion_path = exclusion_full_path.split("/").take(exclusion_full_path.split("/").size-1).join("/")
        exclusion_filename = exclusion_full_path.split("/").last
        exclusion_extension = exclusion_filename.split(".").last
        file_extension = file.split(".").last
        if path.include?(exclusion_path) && exclusion_extension == file_extension
          status = true
        end
      end
    end


    return status
  end

  def self.profile_exclusions profile_id
    profile = Profile.find_by(id: profile_id)
    exclusions = profile.exclusion if profile.present?
    return [] if exclusions.blank?
    criteria = []
    exclusions = exclusions.split(",")
    return exclusions

  end

  def self.path_exclusion profile_id    
    exclusions = RequestFile.profile_exclusions(profile_id)
    return [] if exclusions.blank?
    criteria = []
    exclusions.each do |exclusion|
      criteria << exclusion if exclusion[-1] == "/" && exclusion.exclude?("*")
    end
    criteria
  end

  def self.filename_exclusion profile_id
    exclusions = RequestFile.profile_exclusions(profile_id)
    return [] if exclusions.blank?
    criteria = []
    exclusions.each do |exclusion|
      criteria << exclusion if exclusion.exclude?("/") && exclusion.include?(".") && exclusion.exclude?("*")
    end
    criteria    
  end

  def self.path_and_filenname_exclusion profile_id
    exclusions = RequestFile.profile_exclusions(profile_id)
    return [] if exclusions.blank?
    criteria = []
    exclusions.each do |exclusion|
      criteria << exclusion if exclusion.include?("/") && exclusion.split("/").last.include?(".") && exclusion.split("/").last.exclude?("*")
    end
    criteria        
  end

  def self.extension_exclusion profile_id
    exclusions = RequestFile.profile_exclusions(profile_id)
    return [] if exclusions.blank?
    criteria = []
    exclusions.each do |exclusion|
      criteria << exclusion if exclusion.exclude?("/") && exclusion.include?(".") && exclusion.include?("*")
    end
    criteria        
  end

  def self.path_and_extension_exclusion profile_id
    exclusions = RequestFile.profile_exclusions(profile_id)
    return [] if exclusions.blank?
    criteria = []
    exclusions.each do |exclusion|
      criteria << exclusion if exclusion.include?("/") && exclusion.split("/").last.include?(".") && exclusion.split("/").last.include?("*")
    end
    criteria        
    
  end

  def self.determine_exclusion profile_id
    determined_exclusions = {}    
    determined_exclusions[:path_exclusion] = RequestFile.path_exclusion(profile_id)    
    determined_exclusions[:file_exclusion] = RequestFile.filename_exclusion(profile_id)    
    determined_exclusions[:path_and_filename_exclusion] = RequestFile.path_and_filenname_exclusion(profile_id)
    determined_exclusions[:extension_exclusion] = RequestFile.extension_exclusion(profile_id)
    determined_exclusions[:path_and_extension_exclusion] = RequestFile.path_and_extension_exclusion(profile_id)    
    determined_exclusions
  end

  def self.calculating_file path, profile_id
    total_file = 0.0
    total_size = 0.0    
    exclusions = RequestFile.determine_exclusion(profile_id)

    Dir.new(path).each do |file|       
      next if file[0] == "." || file == "." || file == ".."      
      next if RequestFile.exclude?(profile_id, file, path, exclusions)
      if File.file?(File.join(path,file))        
        total_file +=  1
        total_size +=  File.size?(File.join(path,file)).to_f
      elsif File.directory?(File.join(path,file))
        processing_total_file, processing_total_size = (RequestFile.calculating_file(File.join(path,file), profile_id))
        total_file +=  processing_total_file
        total_size +=  processing_total_size
      end       
    end  
    return total_file.to_f, total_size.to_f
  end
end