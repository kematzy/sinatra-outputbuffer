
require "#{File.dirname(File.dirname(File.expand_path(__FILE__)))}/spec_helper"

describe "Sinatra" do 
  
  describe "OutputBuffer" do 
    
    class MyTestApp 
      helpers Sinatra::OutputBuffer::Helpers
      
      helpers do  
        
        def captured_content(&block) 
          content_html = capture_html(&block)
          "<p>#{content_html}</p>"
        end
        
        def concat_in_p(content_html) 
          concat_content "<p>#{content_html}</p>"
        end
        
        def ruby_not_template_block 
          determine_block_is_template('ruby') do
            content_tag(:span, "This not a template block")
          end
        end
        
        def determine_block_is_template(name, &block) 
          concat_content "<p class='is_template'>The #{name} block passed in is a template</p>" if block_is_template?(block)
        end
        
      end
      
    end
    
    # convenience shared spec that sets up MyTestApp and tests it's OK
    # without it you will get "stack level too deep" errors
    it_should_behave_like "MyTestApp"
    
    
    describe "Helpers" do 
      
      describe "#capture_html" do 
        
        it "should capture the HTML content from ERB templates" do 
erb_block = %Q[
<% @content = captured_content do %>
  <span>Captured Line 1</span>
  <span>Captured Line 2</span>
<% end %>
<%= @content %>
]
          erb_app erb_block
          body.should have_tag('p > span', 'Captured Line 1')
          body.should have_tag('p > span', 'Captured Line 2')
        end
        
        it "should capture the HTML content from Haml templates" do 
haml_block = %Q[
- @content = captured_content do
  %span Captured Line 1
  %span Captured Line 2
= @content
]
          haml_app haml_block
          body.should have_tag('p > span', 'Captured Line 1')
          body.should have_tag('p > span', 'Captured Line 2')
        end
        
      end #/ #capture_html
      
      describe "#concat_content" do 
        
        it "should concatenate the HTML content from ERB templates" do 
          erb_app '<% concat_in_p("Concat Line 3") %>'
          body.should have_tag('p', 'Concat Line 3')
        end
        
        it "should concatenate the HTML content from Haml templates" do 
          haml_app "- concat_in_p('Concat Line 3')"
          body.should have_tag('p', 'Concat Line 3')
        end
        
      end #/ #concat_content
      
      describe "#block_is_template?" do 
        
        it "should return true if called from an ERB template" do 
erb_block = %Q[
<% determine_block_is_template('erb') do %>
  <span>This is erb</span>
  <span>This is erb</span>
<% end %>
]
          erb_app erb_block
          body.should have_tag('p.is_template', 'The erb block passed in is a template')
        end
        
        it "should return false if NOT called from an ERB template" do 
          erb_app '<% ruby_not_template_block %>'
          # body.should have_tag(:debug)
          pending "TODO: Get ERB template detection working (fix block_is_erb? method)"
          body.should_not have_tag('p.is_template', 'The ruby block passed in is a template')
          
        end
        
        it "should return true if called from a Haml template" do 
haml_block = %Q[
- determine_block_is_template('haml') do
  %span This is haml
  %span This is haml
]
          haml_app haml_block
          body.should have_tag('p.is_template', 'The haml block passed in is a template')
        end
        
        it "should return false if NOT called from a Haml template" do 
          haml_app '- ruby_not_template_block'
          body.should_not have_tag('p.is_template', 'The haml block passed in is a template')
        end
        
      end #/ #block_is_template?
      
      describe "#content_for" do 
        
        it "should NOT bleed into current ERB template output" do 
erb_block = %Q[
<h1>:content_for</h1>
<% content_for :demo do %>
  <h1>This is content yielded from a content_for</h1>
<% end %>
]
          erb_app erb_block
          # body.should have_tag(:debug)
          body.should == "\n<h1>:content_for</h1>\n\n"
        end
        
        it "should NOT bleed into current Haml template output" do 
haml_block = %Q[
%h1 :content_for
- content_for :demo do
  %h1 This is content yielded from a content_for
]
          haml_app haml_block
          # body.should have_tag(:debug)
          body.should == "<h1>:content_for</h1>\n"
        end
        
        it "should handle multiple assignments to the same key" do 
erb_block = %Q[
<% content_for :custom_css do %>
body{color:red;}
<% end %>

<% content_for :custom_css do %>
h1{color:black;}
<% end %>

<style>
<%= yield_content :custom_css %>
</style>
]
          erb_app erb_block
          # body.should have_tag(:debug)
          body.should match(/body\{color:red;\}/)
          body.should match(/h1\{color:black;\}/)
        end
        
      end #/ #content_for
      
      describe "#yield_content" do 
        
        it "should yield the buffered content from the current ERB template" do 
erb_block = %Q[
<% content_for :demo do %>
  <h1>This is content yielded from a content_for</h1>
<% end %>
<div class='demo'><%= yield_content :demo %></div>
]
          erb_app erb_block
          body.should have_tag('div.demo > h1', 'This is content yielded from a content_for')
        end
        
        it "should yield the buffered content from the current Haml template" do 
haml_block = %Q[
- content_for :demo do
  %h1 This is content yielded from a content_for

.demo= yield_content :demo
]
          haml_app haml_block
          body.should have_tag('div.demo > h1', 'This is content yielded from a content_for')
        end
        
        it "should yield the buffered content with params from the current ERB template" do 
erb_block = %Q[
<% content_for :demo do |fname, lname| %>
  <h1>This is content yielded with name <%= fname + " " + lname %></h1>
<% end %>
<div class='demo'><%= yield_content :demo, 'Joe', 'Blogs' %></div>
]
          erb_app erb_block
          body.should have_tag('div.demo > h1', 'This is content yielded with name Joe Blogs')
        end
        
        it "should yield the buffered content with params from the current Haml template" do 
          #  NOTE:: the escaped # => \# in the Haml content below. 
          #         Without it the test don't work.s 
haml_block = %Q[
- content_for :demo do |fname, lname|
  %h1 This is content yielded with name \#{fname + " " + lname}
  
.demo= yield_content :demo, 'Joe', 'Blogs'
]
          haml_app haml_block
          body.should have_tag('div.demo > h1', 'This is content yielded with name Joe Blogs')
        end
        
      end #/ #yield_content
      
    end #/ Helpers
    
  end #/ OutputBuffer
  
end #/ Sinatra
