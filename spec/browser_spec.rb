require File.expand_path("watirspec/spec_helper", File.dirname(__FILE__))

describe "Browser" do
  before do
    browser.goto(WatirSpec.url_for("images.html"))
  end

  context "#attach" do
    it "attaches to existing browser by title" do
      Browser.attach(:title, /Images/).hwnd.should == browser.hwnd
    end

    it "attaches to existing browser by url" do
      Browser.attach(:url, /images\.html/).hwnd.should == browser.hwnd
    end

    it "attaches to existing browser by handle" do
      Browser.attach(:hwnd, browser.hwnd).hwnd.should == browser.hwnd
    end

    it "fails with an error if specified browser was not found" do
      begin
        original_timeout = browser.class.attach_timeout
        browser.class.attach_timeout = 0.1

        expect {
          Browser.attach(:title, "not-existing-window")
        }.to raise_error(NoMatchingWindowFoundException)
      ensure
        browser.class.attach_timeout = original_timeout
      end
    end
  end

  describe "Window offset position" do
    before do
      browser.goto WatirSpec.url_for("forms_with_input_elements.html") 
      browser.window.resize_to(200, 500)
      browser.scroll_to(0, 0)
    end

    describe "#x" do
      it "returns X offset of the browser window content position" do
        browser.x.should == 0
        browser.scroll_to(50, 0)
        browser.x.should == 50
      end
    end
  
    describe "#y" do
      it "returns Y offset of the browser window content position" do
        browser.y.should == 0
        browser.scroll_to(0, 60)
        browser.y.should == 60
      end
    end
  end

  describe "#scroll_to" do
    before do 
      browser.goto WatirSpec.url_for("forms_with_input_elements.html") 
      browser.window.resize_to(200, 500)
    end
    
    it "scrolls to the top left corner when given 0, 0 parameters" do
      browser.scroll_to(0, 0)
      browser.x.should == 0
      browser.y.should == 0
    end
    
    it "scrolls the browser into given x, y position from the basic corner" do
      browser.scroll_to(0, 0)
      
      browser.scroll_to(50, 60)
      browser.x.should == 50
      browser.y.should == 60
    end
    
    it "scrolls the browser into given x, y position no matter where it was" do
      browser.scroll_to(100, 120)
      browser.scroll_to(50, 60)

      browser.x.should == 50
      browser.y.should == 60
    end      
  end
  
  describe "#scroll" do
    before do 
      browser.goto WatirSpec.url_for("forms_with_input_elements.html") 
      browser.window.resize_to(200, 500)
      browser.scroll_to(0, 0)
    end
    
    it "scrolls the browser by given number of pixels in x and y dimensions from top left corner" do
      browser.scroll(50, 60)
      browser.x.should == 50
      browser.y.should == 60
    end
    
    it "scrolls the browser by given number of pixels in x and y dimensions from any offset" do
      browser.scroll_to(50, 60)
      browser.scroll(10, 20)
      browser.x.should == 60
      browser.y.should == 80
    end
    
    it "scrolls the browser by given number of pixels in x and y dimensions from any offset backwards" do
      browser.scroll_to(50, 60)
      browser.scroll(-10, -20)
      browser.x.should == 40
      browser.y.should == 40
    end
    
    it "shouldn't scroll into negative dimensions" do
      browser.scroll_to(50, 60)
      browser.scroll(-60, -80)
      browser.x.should == 0
      browser.y.should == 0
    end
  end
  
  describe "scroll in given direction" do
    before do 
      browser.goto WatirSpec.url_for("forms_with_input_elements.html") 
      browser.window.resize_to(200, 500)
      browser.scroll_to(0, 0)
    end
    
    it "#scroll_right" do
      browser.scroll_right(50)
      browser.x.should == 50
      browser.y.should == 0
    end
    
    it "#scroll_down" do
      browser.scroll_down(60)
      browser.x.should == 0
      browser.y.should == 60
    end
    
    it "#scroll_left" do
      browser.scroll(50, 60)
      browser.scroll_left(20)
      browser.x.should == 30
      browser.y.should == 60
    end
    
    it "#scroll_up" do
      browser.scroll(50, 60)
      browser.scroll_up(20)
      browser.x.should == 50
      browser.y.should == 40
    end
  end

end
