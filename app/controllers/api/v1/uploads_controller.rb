require 'boxr'
class Api::V1::UploadsController < ApplicationController
    CLIENT = Boxr::Client.new('BBCS3X1wrmT8NEhgps7gmrz18T266GLW')
    PARENT_FOLDER = 124248437317;

    def index
    end

    def get_folder
        @items = CLIENT.folder_items(Boxr::ROOT)
        @items.each {|i| puts i.name}
        render json: @items
    end

    def create_folder
        name = params[:name]
        @folder = CLIENT.create_folder(name, PARENT_FOLDER)
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
