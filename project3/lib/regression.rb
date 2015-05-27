# Regression class
require 'matrix'
ZERO = 0.01
# A Regression class which performs many different regressions
# and decides on the best one out of {linear, polynomial, exponential,
# logarithmic}
class Regression 
	# Making some variables readable
	attr_reader :type, :coefficients, :r_2

	# The constructor
	def initialize
		@type = :none
		@coefficients = []
		@r_2 = 0
	end

	# This function performs linear and polynomial regression
	# Taken from the spec
	def polynomial_regression x_array, y_array, degree
		x_data = x_array.map { |x_i| (0..degree).map {|pow| (x_i**pow).to_f}}
		mx = Matrix[*x_data]
		my = Matrix.column_vector(y_array)
		begin
			coefficients = ((mx.t*mx).inv * mx.t * my).transpose.to_a[0]
		rescue ExceptionForMatrix::ErrNotRegular
		    return
		end
		# Get the y-values predicted by performing this regression
		y_predicted = []
		x_array.each do |x|
			sum = 0
			coefficients.each_index {|i| sum += coefficients[i]*(x**i)}
			y_predicted.push(sum)
		end
		r_2 = r_squared y_array, y_predicted
		# If this is better than the current R^2 value store the coefficients
		if(@type == :none or r_2 > @r_2)
			@type = :polynomial
			@coefficients = coefficients
			@r_2 = r_2
		end
	end


	# This function performs logarithmic regression
	def logarithmic_regression x_array, y_array
		coefficients = []
		# Perform logarithmic regression
		ylogx_sum, y_sum, logx_sum, logx_squared_sum, n = 0, 0, 0, 0, x_array.length

		x_array.each_index do |i|
			begin 
				if x_array[i] <= ZERO
					return
				end
				ylogx_sum += y_array[i]*Math.log(x_array[i])
				y_sum += y_array[i]
				logx_sum += Math.log(x_array[i])
				logx_squared_sum += (Math.log(x_array[i]))**2
			rescue Math::DomainError
				# If logarithmic regression doesn't work we return
				return
			end
		end

		# Calculate the coefficients
		a = (n*ylogx_sum - y_sum*logx_sum)/(n*logx_squared_sum - logx_sum**2)
		b = (y_sum - a*logx_sum)/n 
		coefficients.push(a)
		coefficients.push(b)

		# Get the y-values predicted by performing this regression
		y_predicted = []
		x_array.each do |x|
			sum = a*Math.log(x) + b
			y_predicted.push sum
		end
		r_2 = r_squared y_array, y_predicted
		# If this is better than the current R^2 value, store the coefficients
		if(@type == :none or r_2 > @r_2) 
			@type = :logarithmic
			@coefficients = coefficients
			@r_2 = r_2
		end

	end

	# This function performs exponential regression
	def exponential_regression x_array, y_array
		coefficients = []
		# Perform exponential regression 
		logy_sum, x_squared_sum, x_sum, xlogy_sum, n = 0, 0, 0, 0, x_array.length

		x_array.each_index do |i|
			begin 
				if y_array[i] <= ZERO
					return
				end				
				logy_sum += Math.log(y_array[i])
				x_squared_sum += x_array[i]**2
				x_sum += x_array[i]
				xlogy_sum += x_array[i]*Math.log(y_array[i])
			rescue Math::DomainError
				# If exponential regression doesn't work we return
				return
			end
		end

		# Calculate the coefficients
		a = Math.exp((logy_sum*x_squared_sum - x_sum*xlogy_sum)/(n*x_squared_sum - x_sum**2))
		b = (n*xlogy_sum - x_sum*logy_sum)/(n*x_squared_sum - x_sum**2)
		coefficients.push(a)
		coefficients.push(b)
		# Get the y-values predicted by performing this regression
		y_predicted = []
		x_array.each do |x|
			sum = a*Math.exp(b*x)
			y_predicted.push sum
		end
		r_2 = r_squared y_array, y_predicted
		# If this is better than the current R^2 value, store the coefficients
		if(@type == :none or r_2 > @r_2)
			@type = :exponential
			@coefficients = coefficients
			@r_2 = r_2
		end
	end

	# Calculates the R^2 value 
	# y_array: An array of actual y values
	# y_predicted_array: An array of y values predicted
	# by your model
	def r_squared y_array, y_predicted_array 
		# sse (Sum of squared errors)
		# sst (Total sum of squares)
		# R^2 = 1 - sse/sst
		sse = 0
		sst = 0
		sum = 0
		# Calculate the mean of y values
		y_array.each {|y| sum += y}
		y_mean = sum.to_f/y_array.length
		# Calculate R^2
		y_array.each_index do |i|
			sse += (y_array[i] - y_predicted_array[i])**2
			sst += (y_array[i] - y_mean)**2
			if sst <= ZERO
				return 1
			end
		end
		return (1-sse/sst)
	end

	# This function can be called by the client to get the best type of regression
	def regress x_array, y_array
		# Reset
		@type = :none
		@coefficients = []
		@r_2 = 0
		# Return if there is one x or y value
		if x_array.length == 1 
			@type = :polynomial
			@coefficients = [y_array[0]]
			@r_2 = 1
			return
		end
		# Do all the possible regressions 
		for i in (1..10)
			polynomial_regression x_array, y_array, i
		end
		logarithmic_regression x_array, y_array
		exponential_regression x_array, y_array
	end

	# This function can be called by the client to get an extrapolation
	def extrapolate n
		if @type == :none
			return
		elsif @type == :polynomial
			sum = 0
			@coefficients.each_index {|i| sum += @coefficients[i]*(n**i)}
			return sum.abs
		elsif @type == :logarithmic
			sum = coefficients[0]*Math.log(n) + coefficients[1]
			return sum.abs
		elsif @type == :exponential
			sum = coefficients[0]*Math.exp(coefficients[1]*n)
			return sum.abs
		else
			return nil
		end
	end
end