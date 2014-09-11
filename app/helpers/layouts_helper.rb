module LayoutsHelper

	def layout
		@layout ||= user_layout
	end

	def user_layout
		current_user ? current_user.layout : Layout.default
	end
end	