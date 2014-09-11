module ThemesHelper

	def theme
		@theme ||= user_theme
	end

	def user_theme
		current_user ? current_user.theme : Theme.default
	end
end	