class ImporterController < ApplicationController

	def index
	end

	def form
		@financials = FinancialElement.all
	end

	def import
		@financials
		puts 'REACHED IMPORT METHOD'
		# this is how you choose the spreadsheet
		spreadsheet = Roo::Spreadsheet.open(params[:file])
		# get the entire 'header' value from the spreadsheet
		header = spreadsheet.row(1) # -> 'date EURUSD Currency EURGBP Currency, etc'
		header = header[1..header.length] # -> redefine this so that date is not a category!!!


		(2..spreadsheet.last_row).each do |i|
			row = spreadsheet.row(i)
			date = row.shift

			row.each_with_index do |val, i|
				@financial = FinancialElement.create(day: date, name: header[i], model_value: val)
				puts "does this print?"
				puts @financial.day
			end
		end

		# maybe think about redirecting it to another page for selecting
		redirect_to graph_path
	end

	def graph
		@categories = FinancialElement.pluck(:name).uniq # -> returns all 6
		dates = FinancialElement.pluck(:day).uniq.sort
		@start_date = dates.first
		@end_date = dates.last

		@category1 = ''
		@category2 = ''
		@chosen_start_date = ''
		@chosen_end_date = ''
		@category1_data = []
		@category2_data = []
		@dates = []
		@newDates = []

		# if params[:category1] && params[:category2] && params[:daterange] # && params[:months]
		if params[:category1] && params[:category2] && params[:daterange]
			# && params[:months]
			@category1 = params[:category1]
			@category2 = params[:category2] 

			split_dates = params[:daterange].split(' - ')
			@chosen_start_date = Date.strptime(split_dates[0], '%m/%d/%Y')
			@chosen_end_date = Date.strptime(split_dates[1], '%m/%d/%Y')

			@months = params[:month]
			#category1_data_records = FinancialElement.where(name: @category1, day: @chosen_start_date..@chosen_end_date).sort_by(&:day)
			#@category1_data = []
			#category1_data_records.each do |record|
			#	@category1_data << record.model_value
			#end
			# 'map' makes it so only the model_value of the element is returned, not the entire element record
			@category1_data = FinancialElement.where(name: @category1, day: @chosen_start_date..@chosen_end_date).sort_by(&:day).map{|element| element.model_value}
			@category2_data = FinancialElement.where(name: @category2, day: @chosen_start_date..@chosen_end_date).sort_by(&:day).map{|element| element.model_value}


			if @category1_data.length > @category2_data.length
				@dates = FinancialElement.where(name: @category1, day: @chosen_start_date..@chosen_end_date).sort_by(&:day).map{|element| element.day}
			else
				@dates = FinancialElement.where(name: @category2, day: @chosen_start_date..@chosen_end_date).sort_by(&:day).map{|element| element.day}
			end

			@timestamps = []

			@dates.each do |date|
				@timestamps << date.strftime('%d/%m/%Y')
				@newDates = date;
			end

			graph_creator(@category1, @category2, @category1_data, @category2_data, @dates)
		end
	end

	def graph_creator(category1, category2, category1_data, category2_data, dates)
		g = Gruff::Line.new("1900x1000")
		g.title = "#{dates.first} to #{dates.last}"
		labels = Hash.new
		max_length =  5 < dates.length ? 5 : dates.length
		(0..dates.length - 1).step(dates.length / max_length).each do |ind|
			labels[ind] = dates[ind]
		end
		g.labels = labels
		g.data @category1.to_sym, @category1_data
		g.data @category2.to_sym, @category2_data
		g.write('public/graph.png')
	end
end





