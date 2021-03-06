require "test_helper"

describe Movie do
  describe 'relations' do
    before do
      # @customer = Customer.create!(name: "test customer")
      @customer = Customer.first

      @movie = Movie.new(title: "test movie")
    end

    it "connects customer and rental customer_id" do
      movie = Movie.first
      rental = Rental.new(movie_id: movie.id, customer_id: @customer.id)
      rental.movie_id.must_equal movie.id
    end

    it 'has a list of customers' do
      @movie.must_respond_to :customers
      second_cust = Customer.create!(name: "fake name")
      @movie.customers << second_cust

      @movie.customers.each do |customer|
        customer.must_be_kind_of Customer
      end
    end
  end

  describe 'validations' do

    it "can be created with all valid fields" do
      movie = Movie.new(title: "test movie", inventory: 4)

      result = movie.valid?

      result.must_equal true
    end

    it 'is invalid without a title' do
      movie = Movie.new

      result = movie.valid?

      result.must_equal false
    end

    it 'is invalid if available inventory greater than inventory' do
      movie= movies(:gijane)

      # this will increment available_inventory value to 4
      movie.inc_avail_inventory
      movie.inc_avail_inventory

      movie.wont_be :valid?
    end

    it 'is invalid if available_inventory is negative' do
      movie= movies(:gijane)

      movie.dec_avail_inventory
      movie.dec_avail_inventory
      movie.dec_avail_inventory

      movie.wont_be :valid?
    end
  end

  describe 'attributes' do
    it 'available_inventory defaults to the inventory amount' do
      movie = movies(:purple)

      movie.available_inventory.must_equal 3
    end
  end

  describe 'describe available inventory methods' do
    # the next two tests uses the yml 'purple' which has available_inventory set to nil as a default
    it 'decreases available inventory of a movie by 1' do
      movie = movies(:purple)
      before_count = movie.available_inventory

      movie.dec_avail_inventory

      after_count = movie.available_inventory

      after_count.must_equal before_count - 1
    end

    it 'increases available inventory of a movie by 1' do
      movie = movies(:purple)
      before_count = movie.available_inventory

      movie.inc_avail_inventory

      after_count = movie.available_inventory

      after_count.must_equal before_count + 1

    end

    it 'invalid if available_inventory is greater than inventory' do
      movie = Movie.first
      stock = movie.inventory

      movie.available_inventory = stock + 2
      result = movie.valid?

      result.must_equal false
    end
  end
end
