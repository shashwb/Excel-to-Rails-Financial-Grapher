class ImporterController < ApplicationController

	def index
	end

	def form
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
			# shifts it one place over and returns previous
			# this stores the numerical date into 'date'
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


	def draw_first

	end

	def graph
		@categories = FinancialElement.pluck(:name).uniq
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

		if params[:category1] && params[:category2] && params[:daterange]
			@category1 = params[:category1]
			@category2 = params[:category2]

			split_dates = params[:daterange].split(' - ')
			@chosen_start_date = Date.strptime(split_dates[0], '%m/%d/%Y')
			@chosen_end_date = Date.strptime(split_dates[1], '%m/%d/%Y')

			#category1_data_records = FinancialElement.where(name: @category1, day: @chosen_start_date..@chosen_end_date).sort_by(&:day)
			#@category1_data = []
			#category1_data_records.each do |record|
			#	@category1_data << record.model_value
			#end

			@category1_data = FinancialElement.where(name: @category1, day: @chosen_start_date..@chosen_end_date).sort_by(&:day).map{|element| element.model_value}
			@category2_data = FinancialElement.where(name: @category2, day: @chosen_start_date..@chosen_end_date).sort_by(&:day).map{|element| element.model_value}
			if @category1_data.length > @category2_data.length
				@dates = FinancialElement.where(name: @category1, day: @chosen_start_date..@chosen_end_date).sort_by(&:day).map{|element| element.day}
			else
				@dates = FinancialElement.where(name: @category2, day: @chosen_start_date..@chosen_end_date).sort_by(&:day).map{|element| element.day}
			end
			graph_creator(@category1, @category2, @category1_data, @category2_data, @dates)
		end
	end


	def graph_creator(category1, category2, category1_data, category2_data, dates)
		g = Gruff::Line.new
		g.title = "#{dates.first} --> #{dates.last}"
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





