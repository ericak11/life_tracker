require 'sinatra/base'
require 'redis'
require 'json'
require 'uri'

class App < Sinatra::Base
  # configure do
  #   REDIS_URL = ENV["REDISTOGO_URL"]
  #   uri = URI.parse(ENV["REDISTOGO_URL"])
  #   $redis = Redis.new({:host => uri.host,
  #                       :port => uri.port,
  #                       :password => uri.password})
  #   enable :logging
  #   enable :method_override
  #   $redis = Redis.new(url: REDIS_URL)
  #   # @@coffee = 0
  #   # @@tea = 0
  #   # @@water = 0
  # end
  configure do
    # setting up redis connection
    REDIS_URL = ENV["REDISTOGO_URL"]
    uri = URI.parse(ENV["REDISTOGO_URL"])
    $redis = Redis.new({:host => uri.host,
                        :port => uri.port,
                        :password => uri.password})
    # setnx sets a value if it doesn't exist
    $redis.setnx("coffee", 0)
    $redis.setnx("water", 0)
    $redis.setnx("tea", 0)
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end

####### ROUTES
  get("/")  do
  #   @coffee = @@coffee
  #   @tea = @@tea
  #   @water = @@water
  # setnx sets a value if it doesnt exist
    # $redis.setnx("coffee", 0)
    # $redis.setnx("tea", 0)
    # $redis.setnx("water", 0)
    @coffee = $redis.get("coffee")
    @tea = $redis.get("tea")
    @water = $redis.get("water")
    if params[:choice] == "tea"
      @is_tea = true
    elsif params[:choice] == "coffee"
      @is_coffee = true
    elsif params[:choice] == "water"
      @is_water = true
    end
    render(:erb, :index)
  end


  get("/drinks") do
     render(:erb, :drinks)
  end

  post("/drinks") do
    drink = params[:choice]
    count = $redis.get(drink).to_i
    $redis.set(drink, count += 1)

    # if params[:choice].match("Tea")

    #   @@tea += 1
    # elsif params[:choice].match("Coffee")
    #   @@coffee += 1
    # elsif params[:choice].match("Water")
    #   @@water += 1
    # end
    redirect to ("/?choice=#{params[:choice]}")
  end

end
