class TestsController < Simpler::Controller

  def index
    @time = Time.now
    # render plain: "Hello world!"
  end

  def create

  end

  def show
    @test = Test.first(id: params[:id])
  end

end
