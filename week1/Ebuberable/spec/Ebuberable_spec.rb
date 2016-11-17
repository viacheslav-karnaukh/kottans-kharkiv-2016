require 'Ebuberable'


describe 'Ebuberable module' do

	class Stub
		include Ebuberable

		attr_accessor :items

		def initialize(*items)
			@items = items
		end

		def each
			@items.each { |item| yield(item) }
		end
	end

	context 'methods' do

		class Stub
			include Ebuberable
		end

		subject { Stub.new }
		it {
			should respond_to(
				:each,
				:map,
				:select,
				:reject,
				:grep,
				:all?,
				:reduce
			)
		}

	end

	context 'initialization' do
		
		subject { items = Stub.new(1,2,3).items }

		it { should include(1,2,3) }
		
	end

	context '#map' do

		it 'returns Enumerator if no block provided' do
			collection = Stub.new
			result = collection.map
			# expect(result).to eq(Enumerator.new(collection))
		end

		it 'maps items adding 1' do
			collection = Stub.new(1, 2, 3)
			result = collection.map { |item| item + 1 }
			expect(result).to eq([2, 3, 4])
		end

		it 'maps items capitalizing them' do
			collection = Stub.new('gustav', 'taras')
			result = collection.map { |item| item.capitalize }
			expect(result).to eq(['Gustav', 'Taras'])
		end

	end

	context '#select' do

		it 'returns Enumerator if no block provided' do
			collection = Stub.new
			result = collection.select
			# expect(result).to eq(Enumerator.new(collection))
		end

		it 'returns empty array if given block returns nil' do
			collection = Stub.new(1, 2, 3)
			result = collection.select { |n| nil }
			expect(result).to eq([])
		end

		it 'returns array with elements provided to instance if block returns truthy value' do
			collection = Stub.new('uno', 'duo', 'tres')
			result = collection.select { |s| 1 }
			expect(result).to eq(['uno', 'duo', 'tres'])
		end

		it 'returns array with elements for which block returns truthy value' do
			collection = Stub.new(1, 2, 3, 4, 5)
			result = collection.select(&:even?)
			expect(result).to eq([2, 4])
		end

	end

	context '#reject' do

		it 'returns Enumerator if no block provided' do
			collection = Stub.new
			result = collection.reject
			# expect(result).to eq(Enumerator.new(collection))
		end

		it 'returns empty array if given block returns truthy value' do
			collection = Stub.new(1, 2, 3, 4, 5)
			result = collection.reject { |e| true }
			expect(result).to eq([])
		end

		it 'returns array with elements for which block returns falsy value' do
			collection = Stub.new(1, 2, 3, 4, 5)
			result = collection.reject(&:odd?)
			expect(result).to eq([2, 4])
		end

	end

	context '#grep' do

		it 'raises error if called with no arguments' do
			expect { Stub.new.grep }.to raise_error(ArgumentError)
		end

		it 'raises error with proper message' do
			expect { Stub.new.grep(/a/, Numeric) }
				.to raise_error('wrong number of arguments (given 2, expected 1)')
		end

		it 'returns array with elements matched to the pattern' do
			collection = Stub.new(1, '2', 3, '4', 5)
			result1 = collection.grep(Numeric)
			expect(result1).to eq([1, 3, 5])
			result2 = collection.grep(/2/)
			expect(result2).to eq(['2'])
		end

		it 'works with blocks if provided' do
			collection = Stub.new(1, '2', 3, '4', 5)
			result = collection.grep(Numeric) { |n| n * 2 }
			expect(result).to eq([2, 6, 10])
		end

	end

	context '#all?' do

		it 'returns true if no elements nil or false' do
			collection = Stub.new(1, 2, 3)
			result = collection.all?
			expect(result).to eq(true)
		end

		it 'returns false if any element nil or false' do
			collection = Stub.new(1, nil, 3)
			result = collection.all?
			expect(result).to eq(false)
		end

		it 'returns true if the block never returns false or nil' do
			collection = Stub.new(1, 2, 3)
			result = collection.all? { |e| Numeric === e }
			expect(result).to eq(true)
		end

		it 'returns false if the block returns false or nil' do
			collection = Stub.new(1, 2, 3)
			result = collection.all? { |e| e < 3 }
			expect(result).to eq(false)
		end

	end

	context '#reduce' do
		it 'raises error if no block given' do
			expect { Stub.new.reduce }
				.to raise_error(
					Ebuberable::NoBlockGivenError,
					'simplified #reduce should be provided with mandatory block'
				)
		end
		it 'returns sum of all elements' do
			collection = Stub.new(1, 2, 3)
			result = collection.reduce { | sum, n | sum + n }
			expect(result).to eq(6)	
		end
		it 'returns nil if called on empty array' do
			collection = Stub.new
			result = collection.reduce { | sum, n | sum + n }
			expect(result).to eq(nil)	
		end
		it 'works with initial value if provided' do
			collection = Stub.new([1, 2], [3, 4])
			result = collection.reduce([]) do | new_array, pair |
				new_array + pair
			end
			expect(result).to eq([1, 2, 3, 4])	
		end
	end

end

