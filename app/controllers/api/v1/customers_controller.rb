class Api::V1::CustomersController < ApplicationController

  def index
    customers = mongo.collection('customers').find()
    customers = customers.map do |c|
      {
        id: c["_id"].to_s,
        name: c["name"],
        phone: c["phone"]
      }
    end
    render json: customers
  end

  def create
    customer = Customer.create!(customer_attributes)
    render json: customer
  end

  def update
    customer = Customer.find(params[:id])
    customer.update(customer_attributes)
    render json: customer
  end

  private

  def customer_attributes
    params.require(:customer).permit(:name, :phone)
  end

  def self.mongo
    return @mongo if @mongo
    if ENV['MONGOLAB_URI']
      @mongo = Mongo::MongoClient.from_uri(ENV['MONGOLAB_URI']).db()
    else
      @mongo = Mongo::MongoClient.new().db('crm')
    end
  end
  delegate :mongo, :to => :class
end
