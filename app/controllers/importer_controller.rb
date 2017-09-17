class ImporterController < ApplicationController
	def form
		puts " "
		puts " "
		puts "REACHED THE FORM METHOD"
		puts " "
		puts " "
		@financials = FinancialElement.all
		puts @financials.all

	end

	def import
		@financials
		puts 'REACHED IMPORT METHOD'
		spreadsheet = Roo::Spreadsheet.open(params[:file])
		header = spreadsheet.row(1)
		header = header[1..header.length]

		(2..spreadsheet.last_row).each do |i|
			row = spreadsheet.row(i)
			date = row.shift

			row.each_with_index do |val, i|
				@financial = FinancialElement.create(day: date, name: header[i], model_value: val)
				puts "does this print?"
				puts @financial.day
			end
		end

		# @financials = FinancialElement.all.order(date: :asc)
		puts " "
		puts " "
		puts " DOES THIS SHIT GET HERE? "
		puts " "
		puts " "

		# @financials = FinancialElement.all
		# puts @financials.all
		# puts "financial.model_value :::"
		# puts @financial.model_value

		puts " "
		puts " "
		puts " ------****** GETS TO PUTS FINANCIAL "
		puts " "
		puts " "


		redirect_to importer_form_path
	end


	def draw_first

	end

end
