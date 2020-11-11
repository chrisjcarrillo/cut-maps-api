require 'boxr'
require 'watir'
require 'webdrivers'
require 'cgi'

class Api::V1::UploadsController < ApplicationController

    PARENT_FOLDER = 124248437317;

    def login
        oauth_url = Boxr::oauth_url(URI.encode_www_form_component('1233'))
        render json: oauth_url
        # browser = Watir::Browser.new
        # browser.goto (oauth_url.host + oauth_url.path + '?' + oauth_url.query )
        # username = browser.input(:id => 'login').send_keys 'chrisjcarrillo@hotmail.com'
        # password = browser.input(:id => 'password').send_keys 'Ronaldo10!'
        # submit_button = browser.input(:title => 'Authorize').click
        # consent_button = browser.button(:title => 'Grant access to Box').when_present.click
        # return_url = browser.url
        # this = CGI::parse(return_url)
        # render json: this['code'].to_s
    end 

    def get_token
        tokens = Boxr::get_tokens(
            params['code'],
            grant_type: 'authorization_code',
            assertion: nil,
            scope: nil,
            username: nil,
            client_id: ENV['BOX_CLIENT_ID'],
            client_secret: ENV['BOX_CLIENT_SECRET'])

        @token = TokenCredential.create!(access_token: tokens['access_token'], refresh_token: tokens['refresh_token'])
        render json: @token
    end

    def save_tokens(access, refresh)
        TokenCredential.create!(access_token: access, refresh_token: refresh)
    end

    def client
        token_refresh_callback = lambda { |access, refresh, identifier| save_tokens(access, refresh) }
        Boxr::Client.new(TokenCredential.last.access_token,
                         refresh_token: TokenCredential.last.refresh_token,
                         client_id: ENV['BOX_CLIENT_ID'],
                         client_secret: ENV['BOX_CLIENT_SECRET'],
                         &token_refresh_callback)
    end

    def index
    end

    def get_folder
        @client = client
        @items = @client.folder_items(Boxr::ROOT)
        @items.each {|i| puts i.name}
        render json: @items
    end

    def create_folder
        @client = client
        name = params[:name]
        @folder = @client.create_folder(name, PARENT_FOLDER)
        render json: @folder
    end

    def upload_image
        image = params[:image]
        folder = params[:folder_id]
        file_name = params[:file_name]
        @folder = CLIENT.folder_from_id(124247017735, fields: [])
        @file = CLIENT.upload_file(image, @folder, name: file_name)
        render json: @file
    end
    
    def upload_pdf
        @folder = CLIENT.folder_from_id(124248437317, fields: [])
        @file = CLIENT.upload_file('test.txt', @folder)
    end
end
