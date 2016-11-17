module Ebuberable



	class NoBlockGivenError < StandardError
		def initialize(msg = 'no block provided to method call')
			super
		end
	end

  	def map

  		unless block_given?
  			to_enum()
  		else
  			result = []
			each { |e| result << yield(e) }
			result
  		end
  		
	end

	def select

		unless block_given?
			to_enum()
		else
			result = []
			each { |e| yield(e) && result << e }
			result
		end

	end

	def reject

		unless block_given?
			to_enum()
		else
			result = []
			each { |e| !yield(e) && result << e }
			result
		end

	end

	def grep(x)

		raise ArgumentError, "wrong number of arguments (given #{x.size}, expected 1)" if [x].size != 1
		
		result = self.select { |e| x === e }

		unless block_given?
			result
		else
			result.map { |e| yield(e) }
		end

	end

	def all?

		result = true

		unless block_given?
			each do |e|
				result = !!e
				break if !result
			end
		else
			each do |e|
				result = yield(e)
				break if !yield(e)
			end
		end

		result
			
	end

	def reduce(initial = nil)
		
		unless block_given?
			raise NoBlockGivenError.new(
				'simplified #reduce should be provided with mandatory block'
			)
		else
			result = initial
			each do |e|
				result = result ? yield(result, e) : e
			end
			result
		end

	end

end