require 'sinatra/base'

class App < Sinatra::Base

  configure do
    enable :logging
    enable :method_override
    @@coffee = 0
    @@tea = 0
    @@water = 0
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
    @coffee = @@coffee
    @tea = @@tea
    @water = @@water
    render(:erb, :index)
  end


  get("/drinks") do
     render(:erb, :drinks)
  end

  post("/drinks") do
    if params[:choice].match("Tea")
      @@tea += 1
    elsif params[:choice].match("Coffee")
      @@coffee += 1
    elsif params[:choice].match("Water")
      @@water += 1
    end
    redirect to ("/")
  end

end
