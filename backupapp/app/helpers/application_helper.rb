module ApplicationHelper
	def profile_size(profile)
		profile.documents.sum(&:file_size).to_i
	end

	def class_alert(type)
		case type
		when "notice"
			return "bg-success"
		else 
			return "bg-danger"
		end
	end

	def icon_alert(type)
		case type
		when "notice"
			return "glyph stroked checkmark"
		else 
			return "glyph stroked cancel"
		end
	end

	def icon_href_alert(type)
		case type
		when "notice"
			return "#stroked-checkmark"
		else 
			return "#stroked-cancel"
		end
	end

end
