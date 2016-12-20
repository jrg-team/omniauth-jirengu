require 'spec_helper'

describe OmniAuth::Strategies::Jirengu do
  let(:access_token) { double('AccessToken', :options => {}) }
  let(:parsed_response) { double('ParsedResponse') }
  let(:response) { double('Response', :parsed => parsed_response) }

  let(:enterprise_site)          { 'https://some.other.site.com/api/v3' }
  let(:enterprise_authorize_url) { 'https://some.other.site.com/login/oauth/authorize' }
  let(:enterprise_token_url)     { 'https://some.other.site.com/login/oauth/access_token' }
  let(:enterprise) do
    OmniAuth::Strategies::Jirengu.new('JIRENGU_KEY', 'JIRENGU_SECRET',
        {
            :client_options => {
                :site => enterprise_site,
                :authorize_url => enterprise_authorize_url,
                :token_url => enterprise_token_url
            }
        }
    )
  end

  subject do
    OmniAuth::Strategies::Jirengu.new({})
  end

  before(:each) do
    subject.stub(:access_token).and_return(access_token)
  end

  context "client options" do
    it 'should have correct site' do
      subject.options.client_options.site.should eq("http://user.jirengu.com")
    end

    it 'should have correct authorize url' do
      subject.options.client_options.authorize_url.should eq('http://user.jirengu.com/oauth/authorize')
    end

    it 'should have correct token url' do
      subject.options.client_options.token_url.should eq('http://user.jirengu.com/oauth/token')
    end

    describe "should be overrideable" do
      it "for site" do
        enterprise.options.client_options.site.should eq(enterprise_site)
      end

      it "for authorize url" do
        enterprise.options.client_options.authorize_url.should eq(enterprise_authorize_url)
      end

      it "for token url" do
        enterprise.options.client_options.token_url.should eq(enterprise_token_url)
      end
    end
  end

  context "#email" do
    it "should return email from raw_info if available" do
      subject.stub(:raw_info).and_return({'email' => 'you@example.com'})
      subject.email.should eq('you@example.com')
    end

    it "should return nil if there is no raw_info and email access is not allowed" do
      subject.stub(:raw_info).and_return({})
      subject.email.should be_nil
    end

  end

  context "#raw_info" do
    it "should use relative paths" do
      access_token.should_receive(:get).with('me').and_return(response)
      subject.raw_info.should eq(parsed_response)
    end
  end

  context '#info.urls' do
    it 'should use html_url from raw_info' do
      subject.stub(:raw_info).and_return({ 'login' => 'me', 'html_url' => 'http://enterprise/me' })
      subject.info['urls']['GitHub'].should == 'http://enterprise/me'
    end
  end

end
